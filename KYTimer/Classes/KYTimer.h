//
//  Person.h
//  运行时
//
//  Created by yxf on 2019/4/2.
//  Copyright © 2019 k_yan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KYTimer : NSObject

/// 基于nstimer的定时器对象,定时器默认不执行，需要使用fire开始执行
+(instancetype)timerWithTimeInterval:(NSTimeInterval)interval
                              target:(id)target
                            selector:(SEL)sel
                            userInfo:(nullable id)userInfo
                              repeat:(BOOL)repeat;

/// 基于gcdtimer的定时器,定时器默认不执行，需要使用gcdFire开始执行
+(instancetype)gcdTimerWithStartInterval:(NSTimeInterval)startTime
                            timeInterval:(NSTimeInterval)interval
                                  action:(void (^)(void))action
                                   queue:(dispatch_queue_t)queue
                                  repeat:(BOOL)repeat;

/// 添加基于nstimer的定时器对象到runloop
-(void)addTimerToRunloop:(NSRunLoop *)runloop mode:(NSRunLoopMode)mode;
/// 基于gcdtimer的定时器开始工作
-(void)gcdFire;

/// 定时器停止工作
-(void)stop;

@end


NS_ASSUME_NONNULL_END
