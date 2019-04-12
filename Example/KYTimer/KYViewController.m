//
//  KYViewController.m
//  KYTimer
//
//  Created by massyxf on 04/12/2019.
//  Copyright (c) 2019 massyxf. All rights reserved.
//

#import "KYViewController.h"
#import "KYTimer.h"

@interface KYViewController ()

/*timer*/
@property (nonatomic,strong)KYTimer *timer;

/*timer*/
@property (nonatomic,strong)KYTimer *gcdTimer;

@end

@implementation KYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _timer = [KYTimer timerWithTimeInterval:1 proxy:self selector:@selector(timerProxyRun) userInfo:nil repeats:YES];
    
    _gcdTimer = [KYTimer gcdTimerWithStartInterval:10 timeInterval:1 repeat:YES action:^{
        NSLog(@"基于gcdtimer的定时器");
    }];
	
}

-(void)timerProxyRun{
    NSLog(@"基于nstimer的定时器");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
