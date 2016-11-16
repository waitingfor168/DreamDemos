//
//  HJImageTableViewCell.m
//  FaceDetector
//
//  Created by whj on 2016/11/15.
//  Copyright © 2016年 dream. All rights reserved.
//

#import "HJImageTableViewCell.h"

@interface HJImageTableViewCell () {

    UIImageView *_iconImageView;
}

@end

@implementation HJImageTableViewCell


#pragma mark - OverWrite

- (void)p_initView {
    
    _iconImageView=[[UIImageView alloc] init];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    _iconImageView.backgroundColor = [UIColor lightGrayColor];
    _iconImageView.translatesAutoresizingMaskIntoConstraints = false;
    [self addSubview:_iconImageView];
    
    self.viewMaps[@"iconImageView"] = _iconImageView;
}

- (void)p_addConstraints {
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-3-[iconImageView]-3-|" options:0 metrics:nil views:self.viewMaps]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3-[iconImageView]-3-|" options:0 metrics:nil views:self.viewMaps]];
}

- (void)cellWithConent:(id)conent {

    _iconImageView.image = [UIImage imageNamed:conent];
}

@end
