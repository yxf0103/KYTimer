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

-(void)dealloc{
    NSLog(@"%s",__func__);
}

#pragma mark - override funcs

/*
 消息转发: unrecognized selector的最后三次机会
 当对象收到消息selector时，会去其类对象的方法列表中搜索此方法，如果没有找到，就去其super类中寻找，以此类推
 如果还是找不到，就会执行消息转发
 
 第一次机会: 所属类动态方法解析 resolveInstanceMethod
 首先，如果沿继承树没有搜索到相关方法则会向接收者所属的类进行一次请求，看是否能够动态的添加一个方法，注意这是一个类方法，因为是向接收者所属的类进行请求。
 
 第二次机会: 备援接收者 forwardingTargetForSelector
 当对象所属类不能动态添加方法后，runtime就会询问当前的接受者是否有其他对象可以处理这个未知的selector
 
 第三次机会: 消息重定向
 当没有备援接收者时，就只剩下最后一次机会，那就是消息重定向。这个时候runtime会将未知消息的所有细节都封装为NSInvocation对象，然后调用下述方法:
 -(void)forwardInvocation:(NSInvocation *)anInvocation;
 */

//第一次机会: 所属类动态方法解析

void timeClick(id self,SEL _cmd){
    NSLog(@"--hahaha--");
}

+(BOOL)resolveInstanceMethod:(SEL)sel{
//    if (sel == @selector(timeClick:)) {
//        class_addMethod([self class], sel, (IMP)timeClick, "v@:");
//        return YES;
//    }
    return [super resolveInstanceMethod:sel];
}

//第二次机会: 备援接收者
-(id)forwardingTargetForSelector:(SEL)aSelector{
    if ([self.proxy respondsToSelector:aSelector]) {
        return self.proxy;
    }
    return [super forwardingTargetForSelector:aSelector];
}

//第三次机会: 消息重定向
-(void)forwardInvocation:(NSInvocation *)anInvocation{
    [super forwardInvocation:anInvocation];
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
