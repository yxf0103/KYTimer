//
//  KYGCDTimer.m
//  KYTimer
//
//  Created by yxf on 2021/10/22.
//

#import "KYGCDTimer.h"

@interface KYGCDTimer ()

///gcd timer
@property (nonatomic,strong)dispatch_source_t gcdTimer;

@end

@implementation KYGCDTimer

+(instancetype)timerStartAfter:(NSTimeInterval)startTime
                  timeInterval:(NSTimeInterval)interval
                        action:(void (^)(void))action
                         queue:(dispatch_queue_t)queue
                        repeat:(BOOL)repeat{
    KYGCDTimer *gcdTimer = [[KYGCDTimer alloc] init];
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,
                                                     0,
                                                     0,
                                                     queue);
    dispatch_source_set_timer(timer,
                              dispatch_time(DISPATCH_TIME_NOW,
                                            startTime* NSEC_PER_SEC),
                              interval * NSEC_PER_SEC,
                              0.05 * NSEC_PER_SEC);
    __weak typeof(gcdTimer) wt = gcdTimer;
    dispatch_source_set_event_handler(timer, ^{
        if (!wt) { return; }
        action();
        if (!repeat) {
            [wt stop];
        }
    });
    gcdTimer.gcdTimer = timer;
    return gcdTimer;
}

-(void)fire{
    if (_gcdTimer) {
        dispatch_resume(_gcdTimer);
    }
}

-(void)stop{
    if (_gcdTimer) {
        dispatch_source_cancel(_gcdTimer);
        _gcdTimer = nil;
    }
}

@end
