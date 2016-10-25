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
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *pipImageView;

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
    
    @autoreleasepool {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.pipImageView.image = [UIImage imageWithCIImage:ciImage];
        });
    }
}

@end
