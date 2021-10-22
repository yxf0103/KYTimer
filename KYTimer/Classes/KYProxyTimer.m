//
//  KYProxyTimer.m
//  KYTimer
//
//  Created by yxf on 2021/10/22.
//

#import "KYProxyTimer.h"
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

@interface KYProxyTimer ()

///nstimer timer
@property (nonatomic,strong)NSTimer *timer;

@end


@implementation KYProxyTimer

+(instancetype)timerWithTimeInterval:(NSTimeInterval)interval target:(id)target selector:(SEL)sel userInfo:(id)userInfo repeat:(BOOL)repeat{
    KYProxyTimer *kt = [[self alloc] init];
    KYTimerProxy *proxy = [[KYTimerProxy alloc] initWithTarget:target];
    NSTimer *timer = [NSTimer timerWithTimeInterval:interval
                                             target:proxy
                                           selector:sel
                                           userInfo:userInfo
                                            repeats:repeat];
    kt.timer = timer;
    return kt;
}

-(void)addTimerToRunloop:(NSRunLoop *)runloop mode:(NSRunLoopMode)mode{
    [runloop addTimer:_timer forMode:mode];
}

-(void)stop{
    [_timer invalidate];
    _timer = nil;
}

-(void)dealloc{
    [self stop];
}

@end
