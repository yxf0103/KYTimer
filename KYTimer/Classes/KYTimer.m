//
//  Person.m
//  运行时
//
//  Created by yxf on 2019/4/2.
//  Copyright © 2019 k_yan. All rights reserved.
//

#import "KYTimer.h"
#import <objc/runtime.h>

@interface KYTimer ()

/*timer*/
@property (nonatomic,weak)NSTimer *timer;

/*proxy*/
@property (nonatomic,weak)id proxy;

//⚠️dispatch_source_t  GCD对象应该看作一个对象，所以其修饰符为strong或者retain
//现在retain也可以在arc中使用了，作用等同于strong
/*timer*/
@property (nonatomic,strong)dispatch_source_t gcdTimer;

@end

@implementation KYTimer

+(instancetype)timerWithTimeInterval:(NSTimeInterval)ti proxy:(nonnull id)proxy selector:(nonnull SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo{
    KYTimer *kytimer = [[self alloc] init];
    NSTimer *timer = [NSTimer timerWithTimeInterval:ti
                                             target:kytimer
                                           selector:aSelector
                                           userInfo:userInfo
                                            repeats:yesOrNo];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    kytimer.timer = timer;
    kytimer.proxy = proxy;
    
    return kytimer;
}

-(void)fire{
    [self.timer fire];
}

-(void)stop{
    [self.timer invalidate];
    self.timer = nil;
}

//第二次机会: 备援接收者
-(id)forwardingTargetForSelector:(SEL)aSelector{
    if ([self.proxy respondsToSelector:aSelector]) {
        return self.proxy;
    }
    return [super forwardingTargetForSelector:aSelector];
}

#pragma mark - gcd timer
+(instancetype)gcdTimerWithStartInterval:(NSInteger)dateInterval
                            timeInterval:(NSTimeInterval)ti
                                  repeat:(BOOL)repeatAble
                                  action:(void (^)(void))action{
    KYTimer *kt = [[KYTimer alloc] init];
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_source_t gt = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    kt.gcdTimer = gt;
    
    __weak typeof(kt) wt = kt;
    dispatch_source_set_event_handler(gt, ^{
        action();
        if (!repeatAble) {
            [wt gcdStop];
        }
    });
    
    //首次执行时间、执行间隔和精确度
    dispatch_source_set_timer(gt, dispatch_time(DISPATCH_TIME_NOW, dateInterval * NSEC_PER_SEC), ti * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
    
    return kt;
}

-(void)gcdFire{
    if (_gcdTimer) {
        dispatch_resume(_gcdTimer);
    }
}

-(void)gcdStop{
    if (_gcdTimer) {
        dispatch_source_cancel(_gcdTimer);
        _gcdTimer = nil;
    }
}

@end
