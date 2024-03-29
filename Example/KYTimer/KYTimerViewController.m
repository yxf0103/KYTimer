//
//  KYTimerViewController.m
//  KYTimer_Example
//
//  Created by yxf on 2020/8/2.
//  Copyright © 2020 massyxf. All rights reserved.
//

#import "KYTimerViewController.h"
#import <KYTimer/KYProxyTimer.h>
#import <KYTimer/KYGCDTimer.h>

@interface KYTimerViewController ()

@property (nonatomic,strong)KYProxyTimer *timer;

@property (nonatomic,strong)KYGCDTimer *gcdTimer;

@end

@implementation KYTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"dismiss" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(100, 100, 80, 40);
    [btn addTarget:self action:@selector(dismissBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _timer = [KYProxyTimer timerWithTimeInterval:1 target:self selector:@selector(timerProxyRun) userInfo:nil repeat:YES];
    [_timer addTimerToRunloop:[NSRunLoop currentRunLoop] mode:NSRunLoopCommonModes];
    
    _gcdTimer = [KYGCDTimer timerStartAfter:10 timeInterval:1 action:^{
        NSLog(@"基于gcdtimer的定时器");
    } queue:dispatch_get_main_queue() repeat:YES];
    [_gcdTimer fire];
    
}

-(void)dealloc{
    NSLog(@"delloac:%@",[self class]);
}

-(void)timerProxyRun{
    NSLog(@"基于nstimer的定时器");
}

-(void)dismissBtnClicked:(UIButton *)btn{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
