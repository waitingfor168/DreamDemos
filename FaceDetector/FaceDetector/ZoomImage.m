//
//  ZoomImage.m
//  FaceDetector
//
//  Created by whj on 2016/11/14.
//  Copyright © 2016年 dream. All rights reserved.
//

#import "ZoomImage.h"

@interface ZoomImage () <UIScrollViewDelegate> {

    UIScrollView *_scrollview;
    UIImageView *_imageview;
    UIImage *_image;
}

@end

@implementation ZoomImage

+ (instancetype)instanceWithFrame:(CGRect)frame image:(UIImage *)image {

    return [[self alloc] initFrame:frame image:image];
}

- (instancetype)initFrame:(CGRect)frame image:(UIImage *)image {

    if (self = [super initWithFrame:frame]) {
        
        _image = image;
        
        [self p_initView];
    }
    return self;
}

- (void)setImage:(UIImage *)image {

    _image = image;
    
    [self p_initView];
}

- (void)p_initView {
    
    _scrollview=[[UIScrollView alloc]initWithFrame:self.bounds];
    [self addSubview:_scrollview];
    
    _imageview=[[UIImageView alloc]initWithImage:_image];
    [_scrollview addSubview:_imageview];
    
    _scrollview.contentSize=_image.size;
    
    _scrollview.delegate=self;
    _scrollview.maximumZoomScale=2.0;
    _scrollview.minimumZoomScale=0.5;
    _scrollview.zoomScale = 0.5;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return _imageview;
}


@end
