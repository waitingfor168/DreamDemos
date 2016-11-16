//
//  HJImageTableViewCell.m
//  FaceDetector
//
//  Created by whj on 2016/11/15.
//  Copyright © 2016年 dream. All rights reserved.
//

#import "HJImageTableViewCell.h"

@interface HJImageTableViewCell () {

    UIImageView *_imageView;
}

@end

@implementation HJImageTableViewCell


#pragma mark - OverWrite

- (void)p_initView {
    
    _imageView=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, CellProtocolHeight - 10, CellProtocolHeight - 10)];
    _imageView.contentMode = UIViewContentModeScaleToFill;
    _imageView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_imageView];
}

- (void)cellWithConent:(id)conent {

    _imageView.image = [UIImage imageNamed:conent];
    NSLog(@"==>>:%@", conent);
}

@end
