//
//  MaskImageViewController.m
//  FaceDetector
//
//  Created by whj on 16/10/21.
//  Copyright © 2016年 dream. All rights reserved.
//

#import "MaskImageViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "VideoManager.h"
#include "cubeMap.c"

@interface MaskImageViewController ()

@property (nonatomic, strong) VideoManager *videoManager;

@property (nonatomic, strong) IBOutlet UIView *baseView;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;

@end

@implementation MaskImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"MaskImage";
    
    [self combinationImage];
    return;
    
    // check camera authorization
    // TODO:
    
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
    
    self.videoManager = [VideoManager instanceWithPreview:self.baseView];
    
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
    ciImage = [ciImage imageByApplyingOrientation:UIImageOrientationDownMirrored];
    
    if (attachments) {
        CFRelease(attachments);
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
//        CIFilter *filter = [CIFilter filterWithName:@"CIColorInvert" keysAndValues:@"inputImage" ,ciImage ,nil];
//        self.imageView.image = [UIImage imageWithCIImage:[filter outputImage]];
        [self filterImage:ciImage];
    });
    
}

- (void)filterImage:(CIImage *)ciImage {

    //更换背景图片
    CubeMap myCube = createCubeMap(35, 55);
    NSData *myData = [[NSData alloc]initWithBytesNoCopy:myCube.data length:myCube.length freeWhenDone:true];
    CIFilter *colorCubeFilter = [CIFilter filterWithName:@"CIColorCube"];
    [colorCubeFilter setValue:[NSNumber numberWithFloat:myCube.dimension] forKey:@"inputCubeDimension"];
    [colorCubeFilter setValue:myData forKey:@"inputCubeData"];
    [colorCubeFilter setValue:ciImage forKey:kCIInputImageKey];
    
    CIImage *outputImage = colorCubeFilter.outputImage;
    
    CIFilter *sourceOverCompositingFilter = [CIFilter filterWithName:@"CISourceOverCompositing"];
    [sourceOverCompositingFilter setValue:outputImage forKey:kCIInputImageKey];
//    [sourceOverCompositingFilter setValue:[CIImage imageWithCGImage:backImageView.image.CGImage] forKey:kCIInputBackgroundImageKey];
    
    outputImage = sourceOverCompositingFilter.outputImage;
    CGImage *cgImage = [[CIContext contextWithOptions:nil] createCGImage:outputImage fromRect:outputImage.extent];
    
    self.imageView.image = [UIImage imageWithCGImage:cgImage];
}

- (void)combinationImage {

    //显示原图片
    UILabel *oldLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 65, 160, 15)];
    oldLabel.text = @"原图";
    oldLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:oldLabel];
    
    UIImageView *oldImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 80, 120, 120)];
    oldImageView.image = [UIImage imageNamed:@"icon003.jpg"];
    [self.view addSubview:oldImageView];
    
    //显示背景图片
    UILabel *backLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 65, 160, 15)];
    backLabel.text = @"背景图";
    backLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:backLabel];
    
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(165, 80, 120, 120)];
    backImageView.image = [UIImage imageNamed:@"background.jpg"];
    [self.view addSubview:backImageView];
    
    
    
    //更换背景图片
//    CubeMap myCubeRed = createCubeMap(-5, 5); // red 0, 360
    CubeMap myCubeBlue = createCubeMap(235, 245); // blue 240
//    CubeMap myCubeGreen = createCubeMap(115, 125); // green 120
//    CubeMap myCubeWhite = createCubeMap(220, 260); // white
    CubeMap myCube = myCubeBlue;
    NSData *myData = [[NSData alloc]initWithBytesNoCopy:myCube.data length:myCube.length freeWhenDone:true];
    CIFilter *colorCubeFilter = [CIFilter filterWithName:@"CIColorCube"];
    [colorCubeFilter setValue:[NSNumber numberWithFloat:myCube.dimension] forKey:@"inputCubeDimension"];
    [colorCubeFilter setValue:myData forKey:@"inputCubeData"];
    [colorCubeFilter setValue:[CIImage imageWithCGImage:oldImageView.image.CGImage] forKey:kCIInputImageKey];
    
    CIImage *outputImage = colorCubeFilter.outputImage;
    
    CIFilter *sourceOverCompositingFilter = [CIFilter filterWithName:@"CISourceOverCompositing"];
    [sourceOverCompositingFilter setValue:outputImage forKey:kCIInputImageKey];
    [sourceOverCompositingFilter setValue:[CIImage imageWithCGImage:backImageView.image.CGImage] forKey:kCIInputBackgroundImageKey];
    
    outputImage = sourceOverCompositingFilter.outputImage;
    CGImage *cgImage = [[CIContext contextWithOptions: nil]createCGImage:outputImage fromRect:outputImage.extent];
    
    UILabel *newLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, 320, 15)];
    newLabel.text = @"合成图";
    newLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:newLabel];
    
    
    UIImageView *newImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 220, 300, 300)];
    newImageView.image = [UIImage imageWithCGImage:cgImage];
    [self.view addSubview:newImageView];
}

@end
