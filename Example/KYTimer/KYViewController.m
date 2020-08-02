//
//  KYViewController.m
//  KYTimer
//
//  Created by massyxf on 04/12/2019.
//  Copyright (c) 2019 massyxf. All rights reserved.
//

#import "KYViewController.h"
#import "KYTimerViewController.h"

@interface KYViewController ()


@end

@implementation KYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    KYTimerViewController *timerVc = [[KYTimerViewController alloc] init];
    timerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:timerVc animated:YES completion:nil];
}


@end
