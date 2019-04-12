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

/**
 基于nstimer的定时器对象，定时器的任务实际执行者是proxy，d所以proxy必须实现aSelector
 KYTimer的持有者必须调用stop方法才能销毁KYTimer，否则KYTimer会存在内存泄漏
 定时器默认不执行，需要使用fire开始执行
 
 @param ti 时间间隔
 @param proxy 代理
 @param aSelector 任务
 @param userInfo 携带的信息
 @param yesOrNo 是否重复
 @return KYTimer
 */
+(instancetype)timerWithTimeInterval:(NSTimeInterval)ti
                               proxy:(id)proxy
                            selector:(SEL)aSelector
                            userInfo:(nullable id)userInfo
                             repeats:(BOOL)yesOrNo;

//这里是立即执行的
-(void)fire;

//持有者必须在其dealoc方法中调用此方法，否则会出现unrecognized selector ❌
-(void)stop;

#pragma mark - gcd timer
/**
 基于gcdtimer的定时器，不存在内存泄漏
 定时器默认不执行，需要使用gcdFire开始执行

 @param dateInterval 开始时间
 @param ti 时间间隔
 @param repeatAble 是否重复
 @param action 任务
 @return KYTimer
 */
+(instancetype)gcdTimerWithStartInterval:(NSInteger)dateInterval
                            timeInterval:(NSTimeInterval)ti
                                  repeat:(BOOL)repeatAble
                                  action:(void (^)(void))action;

//这里在dateInterval之后执行
-(void)gcdFire;

//这里不需要强制调用，当对象被销毁时，定时器也被销毁了
-(void)gcdStop;

@end


NS_ASSUME_NONNULL_END
