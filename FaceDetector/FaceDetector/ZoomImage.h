//
//  ZoomImage.h
//  FaceDetector
//
//  Created by whj on 2016/11/14.
//  Copyright © 2016年 dream. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZoomImage : UIView

+ (instancetype)instanceWithFrame:(CGRect)frame image:(UIImage *)image;
- (instancetype)initFrame:(CGRect)frame image:(UIImage *)image;
- (void)setImage:(UIImage *)image;

@end
