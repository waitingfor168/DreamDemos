//
//  SKSCustomImagePickerController.h
//  SkySea
//
//  Created by whj on 15/8/3.
//  Copyright (c) 2015年 skysea. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SKSCustomImagePickerControllerDelegate;

@interface SKSCustomImagePickerController : UIImagePickerController

+ (instancetype)customImagePickerControllerWithTarget:(id)target;

- (void)openCamera;
- (void)openLocalPhoto;

@property (nonatomic, weak) id <SKSCustomImagePickerControllerDelegate> customDelegate;

@end

@protocol SKSCustomImagePickerControllerDelegate <NSObject>
@optional

- (void)customImagePickerController:(SKSCustomImagePickerController *)picker didFinishPickingMediaWithImage:(UIImage *)image;
- (void)customImagePickerController:(SKSCustomImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;

@end
