//
//  KYProxyTimer.h
//  KYTimer
//
//  Created by yxf on 2021/10/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KYProxyTimer : NSObject

/// 基于nstimer的定时器对象,定时器默认不执行，需要使用fire开始执行
+(instancetype)timerWithTimeInterval:(NSTimeInterval)interval
                              target:(id)target
                            selector:(SEL)sel
                            userInfo:(nullable id)userInfo
                              repeat:(BOOL)repeat;

/// 添加基于nstimer的定时器对象到runloop
-(void)addTimerToRunloop:(NSRunLoop *)runloop mode:(NSRunLoopMode)mode;

/// 定时器停止工作
-(void)stop;

@end

NS_ASSUME_NONNULL_END
