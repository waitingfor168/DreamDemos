//
//  VideoManager.h
//  FaceDetector
//
//  Created by whj on 16/10/20.
//  Copyright © 2016年 dream. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef void(^CaptureOutput)(AVCaptureOutput *captureOutput, CMSampleBufferRef sampleBuffer, AVCaptureConnection *connection);

@interface VideoManager : NSObject

+ (instancetype)instanceWithPreview:(UIView *)preview;

- (void)setOutput:(CaptureOutput)captureOutput;

- (void)setup;
- (void)shutDown;


/**
 切换摄像头
 */
- (void)cameraToggle;

/**
 是否为前置摄像头
 */
@property (nonatomic, assign) BOOL isFront;

@end
