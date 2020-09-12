# KYTimer
a memory safe timer.


[![CI Status](https://img.shields.io/travis/massyxf/KYTimer.svg?style=flat)](https://travis-ci.org/massyxf/KYTimer)
[![Version](https://img.shields.io/cocoapods/v/KYTimer.svg?style=flat)](https://cocoapods.org/pods/KYTimer)
[![License](https://img.shields.io/cocoapods/l/KYTimer.svg?style=flat)](https://cocoapods.org/pods/KYTimer)
[![Platform](https://img.shields.io/cocoapods/p/KYTimer.svg?style=flat)](https://cocoapods.org/pods/KYTimer)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

KYTimer is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'KYTimer'
```
## How to use
> 使用时KYTimer需要被强引用，否则会自动释放

### 方案1
```
_timer = [KYTimer timerWithTimeInterval:1 target:self selector:@selector(timerProxyRun) userInfo:nil repeat:YES];
[_timer addTimerToRunloop:[NSRunLoop currentRunLoop] mode:NSRunLoopCommonModes];

```

### 方案2
```
_gcdTimer = [KYTimer gcdTimerWithStartInterval:10 timeInterval:1 action:^{
    NSLog(@"基于gcdtimer的定时器");
} queue:dispatch_get_main_queue() repeat:YES];
[_gcdTimer gcdFire];

```


## Author

massyxf, messy007@163.com

## License

KYTimer is available under the MIT license. See the LICENSE file for more info.
