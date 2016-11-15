//
//  UIView+Mask.m
//  FaceDetector
//
//  Created by whj on 2016/11/15.
//  Copyright © 2016年 dream. All rights reserved.
//

#import "UIView+Mask.h"

@implementation UIView (Mask)

- (void)viewMaskFrame:(CGRect)frame image:(UIImage *)maskImage {
    
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = frame;
    maskLayer.contents = (__bridge id)(maskImage.CGImage);
    
    self.frame = frame;
    self.layer.mask = maskLayer;
}

@end
