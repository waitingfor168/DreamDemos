//
//  HJAlertViewChain.m
//  UIAlertViewChain
//
//  Created by whj on 16/5/31.
//  Copyright © 2016年 whj. All rights reserved.
//

#import "HJAlertViewChain.h"

@interface HJAlertViewChain () <UIAlertViewDelegate>

@end

@implementation HJAlertViewChain

+ (instancetype)instance
{
    return [[HJAlertViewChain alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
}

#pragma mark - OverWrite

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_clickedButtonAtIndex) {
        _clickedButtonAtIndex(alertView, buttonIndex);
    }
}

- (void)alertViewCancel:(UIAlertView *)alertView
{
    if (_alertViewCancel) {
        _alertViewCancel(alertView);
    }
}

- (void)willPresentAlertView:(UIAlertView *)alertView
{
    if (_willPresentAlertView) {
        _willPresentAlertView(alertView);
    }
}

- (void)didPresentAlertView:(UIAlertView *)alertView
{
    if (_didPresentAlertView) {
        _didPresentAlertView(alertView);
    }
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (_willDismissWithButtonIndex) {
        _willDismissWithButtonIndex(alertView, buttonIndex);
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (_didDismissWithButtonIndex) {
        _didDismissWithButtonIndex(alertView, buttonIndex);
    }
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if (_alertViewShouldEnableFirstOtherButton) {
        return _alertViewShouldEnableFirstOtherButton(alertView);
    }
    return YES;
}

@end
