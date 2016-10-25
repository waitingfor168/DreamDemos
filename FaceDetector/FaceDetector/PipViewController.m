//
//  PipViewController.m
//  FaceDetector
//
//  Created by whj on 16/10/25.
//  Copyright © 2016年 dream. All rights reserved.
//

#import "PipViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "VideoManager.h"

@interface PipViewController ()

@property (nonatomic, strong) VideoManager *videoManager;

@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UIView *PreView;
@property (weak, nonatomic) IBOutlet UIImageView *blurImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *pipImageView;

@property (nonatomic, strong) UIImage *maskImage;
@property (nonatomic, strong) CALayer *maskLayer;

@property (nonatomic) CIContext *ciContext;
@property (nonatomic) CIFilter *blurFilter;

@end

@implementation PipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"PIP";
    
    [self p_initObject];
    [self p_setup];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self p_clear];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    NSLog(@"MemoryWarning !!!");
}

- (void)p_initObject {
    
    // 图片高斯模糊
//    UIImage *image = [UIImage imageNamed:@"m0_fg.png"];
//    self.bgImageView.image = [[self class] coreBlurImage:image withBlurNumber:15];
    
    _maskImage = [UIImage imageNamed:@"m0_mask.png"];
    _maskLayer = [CALayer layer];
    _maskLayer.frame = CGRectMake(0, 0, 150, 310);
    _maskLayer.contents = (__bridge id)(_maskImage.CGImage);
    _pipImageView.layer.mask = _maskLayer;
    
    _ciContext = [CIContext contextWithOptions:nil];
    _blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [_blurFilter setValue:@(10) forKey:@"inputRadius"];
    
    self.videoManager = [VideoManager instanceWithPreview:self.PreView];
    [self.view bringSubviewToFront:self.bgImageView];
    [self.view bringSubviewToFront:self.pipImageView];
    
    __weak typeof(self) weakSelf = self;
    [self.videoManager setOutput:^(AVCaptureOutput *captureOutput, CMSampleBufferRef sampleBuffer, AVCaptureConnection *connection) {
        [weakSelf captureOutput:captureOutput didOutputSampleBuffer:sampleBuffer fromConnection:connection];
    }];
}

- (void)p_clear {
    
    [self.videoManager shutDown];
    
    self.videoManager = nil;
}

- (void)p_setup {
    
    [self.videoManager setup];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection {
    
    // get the image
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    CIImage *ciImage = [[CIImage alloc] initWithCVPixelBuffer:pixelBuffer
                                                      options:(__bridge NSDictionary *)attachments];
    // 调整ciImage的方向
    if (self.videoManager.isFront) {
        
        ciImage = [ciImage imageByApplyingOrientation:UIImageOrientationLeftMirrored];
    } else {
        
        ciImage = [ciImage imageByApplyingOrientation:UIImageOrientationDownMirrored];
    }
    
    if (attachments) {
        CFRelease(attachments);
    }
    
    if (_blurFilter ) {
        //设置filter
        [_blurFilter setValue:ciImage forKey:kCIInputImageKey];
        
        //模糊图片
        CIImage *outputImage = [_blurFilter valueForKey:kCIOutputImageKey];
        
        @autoreleasepool {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                CGRect rect = outputImage.extent;
                rect.size.width += rect.origin.x * 2;
                rect.size.height += rect.origin.y * 2;
                rect.origin.x = 0.0;
                rect.origin.y = 0.0;
                
                struct CGImage *cgImage = [_ciContext createCGImage:outputImage fromRect:rect];
                self.blurImageView.image = [UIImage imageWithCGImage:cgImage];
                self.pipImageView.image = [UIImage imageWithCIImage:ciImage];
                
                CGImageRelease(cgImage);
                cgImage = nil;
            });
        }
    }
}

#pragma mark - Unit

+(UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur {
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage= [CIImage imageWithCGImage:image.CGImage];
    //设置filter
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey]; [filter setValue:@(blur) forKey: @"inputRadius"];
    //模糊图片
    CIImage *result=[filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage=[context createCGImage:result fromRect:[result extent]];
    UIImage *blurImage=[UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return blurImage;
}

@end
