//
//  Person.m
//  运行时
//
//  Created by yxf on 2019/4/2.
//  Copyright © 2019 k_yan. All rights reserved.
//

#import "KYTimer.h"
#import <objc/runtime.h>

@interface KYTimerProxy : NSProxy

///target
@property (nonatomic,weak)id target;


-(instancetype)initWithTarget:(id)target;

@end

@implementation KYTimerProxy

-(instancetype)initWithTarget:(id)target{
    _target = target;
    return self;
}

-(void)forwardInvocation:(NSInvocation *)invocation{
    [invocation invokeWithTarget:_target];
}

-(NSMethodSignature *)methodSignatureForSelector:(SEL)sel{
    return [_target methodSignatureForSelector:sel];
}



@end

@interface KYTimer ()

///是否是nstimer类型
@property (nonatomic,assign)BOOL isNSTimer;

///nstimer timer
@property (nonatomic,strong)NSTimer *timer;

///gcd timer
@property (nonatomic,strong)dispatch_source_t gcdTimer;

@end

@implementation KYTimer

+(instancetype)timerWithTimeInterval:(NSTimeInterval)interval target:(id)target selector:(SEL)sel userInfo:(id)userInfo repeat:(BOOL)repeat{
    KYTimer *kt = [[self alloc] init];
    KYTimerProxy *proxy = [[KYTimerProxy alloc] initWithTarget:target];
    NSTimer *timer = [NSTimer timerWithTimeInterval:interval
                                             target:proxy
                                           selector:sel
                                           userInfo:userInfo
                                            repeats:repeat];
    kt.timer = timer;
    kt.isNSTimer = YES;
    return kt;
}

+(instancetype)gcdTimerWithStartInterval:(NSTimeInterval)startTime timeInterval:(NSTimeInterval)interval action:(void (^)(void))action queue:(dispatch_queue_t)queue repeat:(BOOL)repeat{
    KYTimer *kt = [[KYTimer alloc] init];
    kt.isNSTimer = NO;
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer,
                              dispatch_time(DISPATCH_TIME_NOW,  startTime* NSEC_PER_SEC),
                              interval * NSEC_PER_SEC,
                              0.05 * NSEC_PER_SEC);
    __weak typeof(kt) wt = kt;
    dispatch_source_set_event_handler(timer, ^{
        if (!wt) { return; }
        action();
        if (!repeat) {
            [wt gcdStop];
        }
    });
    kt.gcdTimer = timer;
    return kt;
}

-(void)addTimerToRunloop:(NSRunLoop *)runloop mode:(NSRunLoopMode)mode{
    [runloop addTimer:_timer forMode:mode];
}

-(void)gcdFire{
    NSAssert(!_isNSTimer, @"不是基于gcd的timer,请使用addTimerToRunloop:(NSRunLoop *)runloop mode:(NSRunLoopMode)mode");
    if (_gcdTimer) {
        dispatch_resume(_gcdTimer);
    }
}

-(void)stop{
    if (_isNSTimer) {
        [_timer invalidate];
        _timer = nil;
        return;
    }
    [self gcdStop];
}

-(void)gcdStop{
    if (_gcdTimer) {
        dispatch_source_cancel(_gcdTimer);
        _gcdTimer = nil;
    }
}

-(void)dealloc{
    NSLog(@"dealloc:%@",[self class]);
    [self stop];
}

@end
