//
//  UIImage+ReDrew.h
//  FaceDetector
//
//  Created by whj on 16/10/27.
//  Copyright © 2016年 dream. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ReDrew)

+ (UIImage *)imageRenderView:(UIView *)view;
+ (UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

@end
