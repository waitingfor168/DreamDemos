//
//  ViewController.m
//  UIAlertViewChain
//
//  Created by whj on 16/5/31.
//  Copyright © 2016年 whj. All rights reserved.
//

#import "ViewController.h"

#import "HJAlertViewChain.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self p_testAlert];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Init

- (void)p_testAlert
{
    HJAlertViewChain *alertViewChain = [[HJAlertViewChain alloc] init];
    [alertViewChain addButtonWithTitle:@"Test"];
    alertViewChain.clickedButtonAtIndex = ^ (UIAlertView *alertView, NSInteger buttonIndex) {
        NSLog(@"======>>>");
    };
    [alertViewChain show];
}


@end
