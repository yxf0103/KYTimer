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
