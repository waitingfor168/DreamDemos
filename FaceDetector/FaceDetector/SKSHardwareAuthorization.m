//
//  SKSHardwareAuthorization.m
//  SkySea
//
//  Created by whj on 16/6/28.
//  Copyright © 2016年 skysea. All rights reserved.
//

#import "SKSHardwareAuthorization.h"
//#import "SDCAlertController.h"

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation SKSHardwareAuthorization

+ (instancetype)defaultInstance {
    
    static SKSHardwareAuthorization *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SKSHardwareAuthorization alloc] init];
    });
    
    return instance;
}

- (void)accessLibrary:(SKSALAuthorizationStatus)block
{
//    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
//    
//    if (status == ALAuthorizationStatusRestricted || status == ALAuthorizationStatusDenied) {
//        
//        SDCAlertController *alert = [SDCAlertController alertControllerWithTitle:nil
//                                                                         message:NSLocalizedString(@"STR_PHOTOS_VISIT_PROWER", @"warning open photo prower")
//                                                                  preferredStyle:SDCAlertControllerStyleLegacyAlert
//                                                                         handler:nil];
//        SDCAlertAction *action = [SDCAlertAction actionWithTitle:@"好"
//                                                           style:SDCAlertActionStyleDefault
//                                                         handler:^(SDCAlertAction *action) {
//                                                             
//                                                            if (block) block(NO);
//                                                             // [UIApplication c_openUrlAppSetting];
//                                                         }];
//        [alert addAction:action];
//        [alert presentWithCompletion:nil];
//    }
//    else {
//        
       if (block) block(YES);
//    }
}

- (void)accessCamera:(SKSAVAuthorizationStatus)block
{
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
//        
//        if (block) block(YES);
//        return;
//    }
//    
//    AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//    
//    if (authorizationStatus == AVAuthorizationStatusRestricted || authorizationStatus == AVAuthorizationStatusDenied) {
//        
//        SDCAlertController *alert = [SDCAlertController alertControllerWithTitle:nil
//                                                                         message:NSLocalizedString(@"STR_CAMERA_VISIT_PROWER", "camera visit prower")
//                                                                  preferredStyle:SDCAlertControllerStyleLegacyAlert
//                                                                         handler:nil];
//        SDCAlertAction *action = [SDCAlertAction actionWithTitle:@"好"
//                                                           style:SDCAlertActionStyleDefault
//                                                         handler:^(SDCAlertAction *action) {
//                                                             
//                                                             if (block) block(NO);
//                                                         }];
//        [alert addAction:action];
//        [alert presentWithCompletion:nil];
//    }
//    else {
//        
       if (block) block(YES);
//    }
}

@end
