//
//  HJAlertViewChain.h
//  UIAlertViewChain
//
//  Created by whj on 16/5/31.
//  Copyright © 2016年 whj. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - UIAlertView Extension

typedef UIAlertView *(^Content)(id content);

@interface UIAlertView ()

@property (nonatomic, strong) Content addTitle;
@property (nonatomic, strong) Content addMessage;

/**
 *  delegate 已经在方法 instance 中给了自己，
 *  如果使用该属性UIAlertViewDelegate Block将不起作用
 */
//@property (nonatomic, strong) Content addDelegate;

@end


#pragma mark - HJAlertViewChain

typedef void (^AlertViewCancel)(UIAlertView *alertView);
typedef void (^DidPresentAlertView)(UIAlertView *alertView);
typedef void (^WillPresentAlertView)(UIAlertView *alertView);
typedef void (^ClickedButtonAtIndex)(UIAlertView *alertView, NSInteger buttonIndex);
typedef void (^DidDismissWithButtonIndex)(UIAlertView *alertView, NSInteger buttonIndex);
typedef void (^WillDismissWithButtonIndex)(UIAlertView *alertView, NSInteger buttonIndex);
typedef BOOL (^AlertViewShouldEnableFirstOtherButton)(UIAlertView *alertView);


@interface HJAlertViewChain : UIAlertView

#pragma mark - UIAlertView


#pragma mark - UIAlertViewDelegate Block

@property (nonatomic, strong) AlertViewCancel alertViewCancel;
@property (nonatomic, strong) WillPresentAlertView willPresentAlertView;
@property (nonatomic, strong) DidPresentAlertView didPresentAlertView;
@property (nonatomic, strong) ClickedButtonAtIndex clickedButtonAtIndex;
@property (nonatomic, strong) DidDismissWithButtonIndex didDismissWithButtonIndex;
@property (nonatomic, strong) WillDismissWithButtonIndex willDismissWithButtonIndex;
@property (nonatomic, strong) AlertViewShouldEnableFirstOtherButton alertViewShouldEnableFirstOtherButton;


#pragma mark - Method

/**
 *  实例化一个对象
 *
 *  @return 对象
 */
+ (instancetype)instance;

@end
