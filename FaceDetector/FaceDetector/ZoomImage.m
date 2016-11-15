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
}

@end

@implementation ZoomImage

- (void)setImage:(UIImage *)image {

    [self p_initView];
    
    if (_imageview) {
        
        [_imageview removeFromSuperview];
    }
    
    // UIImageView的宽高即Image的宽高
    _imageview = [[UIImageView alloc] initWithImage:image];
    [_scrollview addSubview:_imageview];
    
    _scrollview.contentSize = image.size;
}

- (void)p_initView {
    
    if (_scrollview == nil) {
        
        _scrollview = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollview.showsVerticalScrollIndicator = NO;
        _scrollview.showsHorizontalScrollIndicator = NO;
        _scrollview.backgroundColor = [UIColor clearColor];
        [self addSubview:_scrollview];
        
        _scrollview.delegate=self;
        _scrollview.maximumZoomScale=2.0;
        _scrollview.minimumZoomScale=0.6;
        _scrollview.zoomScale = 0.6;
    }
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return _imageview;
}


@end
