//
//  KYGCDTimer.h
//  KYTimer
//
//  Created by yxf on 2021/10/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KYGCDTimer : NSObject

/// 基于gcdtimer的定时器,定时器默认不执行，需要使用fire开始执行
+(instancetype)timerStartAfter:(NSTimeInterval)startTime
                  timeInterval:(NSTimeInterval)interval
                        action:(void (^)(void))action
                         queue:(dispatch_queue_t)queue
                        repeat:(BOOL)repeat;

-(void)fire;

-(void)stop;

@end

NS_ASSUME_NONNULL_END
