//
//  VideoManager.m
//  FaceDetector
//
//  Created by whj on 16/10/20.
//  Copyright © 2016年 dream. All rights reserved.
//

#import "VideoManager.h"

@interface VideoManager () <AVCaptureVideoDataOutputSampleBufferDelegate> {
    
    __weak UIView *_preView;
}

@property (nonatomic) dispatch_queue_t captureSessionQueue;
@property (nonatomic) dispatch_queue_t videoDataOutputQueue;

@property (nonatomic) UIBackgroundTaskIdentifier backgroundTaskIdentifier;

@property (nonatomic, strong) AVCaptureDevice *captureDevice;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureConnection *captureConnection;
@property (nonatomic, strong) AVCaptureDeviceInput *captureDeviceInput;
@property (nonatomic, strong) AVCaptureVideoDataOutput *captureVideoDataOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

@property (nonatomic, assign) AVCaptureDevicePosition devicePosition;
@property (nonatomic, copy) CaptureOutput captureOutput;

@end

@implementation VideoManager

+ (instancetype)instanceWithPreview:(UIView *)preview {
  
    return [[self alloc] initWithPreview:preview];
}

- (instancetype)initWithPreview:(UIView *)preview {
    
    if (self = [super init]) {
        
        _preView = preview;
        
        [self initObject];
    }
    return self;
}

- (void)initObject {
    
    self.devicePosition = AVCaptureDevicePositionUnspecified;
    
    self.captureSessionQueue = dispatch_queue_create("dream.facedetector.session.queue", DISPATCH_QUEUE_SERIAL);
    self.videoDataOutputQueue = dispatch_queue_create("dream.facedetector.dataoutput.queue", DISPATCH_QUEUE_SERIAL);
    
    
    self.captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] init];
    self.captureVideoPreviewLayer.frame = _preView.frame;
    self.captureVideoPreviewLayer.position = _preView.center;
    self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [_preView.layer addSublayer:self.captureVideoPreviewLayer];
}

- (void)shutDown {
    
    [self.captureSession stopRunning];
    
    if (self.captureVideoPreviewLayer) {
        
        [self.captureVideoPreviewLayer removeFromSuperlayer];
        self.captureVideoPreviewLayer = nil;
    }
    
    if (self.captureVideoDataOutput) {
        
        self.captureVideoDataOutput = nil;
    }
    
    if (self.captureDeviceInput) {
        
        self.captureDeviceInput = nil;
    }
    
    if (self.captureDevice) {
        
        self.captureDevice = nil;
    }
    
    if (self.captureSession) {
        
        self.captureSession = nil;
    }
    
    self.captureSessionQueue = nil;
    self.videoDataOutputQueue = nil;
}

- (void)setup {

    [self changeCamera];
    [self setupPre];
}

- (void)setOutput:(CaptureOutput)captureOutput {

    self.captureOutput = captureOutput;
}

- (void)cameraToggle {
    
    [self changeCamera];
    [self setupPre];
}

- (void)setupPre {
    
    dispatch_async(self.captureSessionQueue, ^{
        
        self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
        
        self.captureDevice = [[self class] deviceType:AVMediaTypeVideo position:self.devicePosition];
        
        NSError *error = nil;
        self.captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.captureDevice error:&error];
        
        if (error) {
            NSLog(@"captureDeviceInput:%@", error);
        }
        
        [self.captureSession beginConfiguration];
        
        [self reInitSession];
        [self reInitOutput];
        
        [self resetupVideoInput];
        [self resetupVideoOutput];
        [self.captureSession commitConfiguration];
        
        if (![self.captureSession isRunning]) {
            
            [self.captureSession startRunning];
        }
    });
}

- (void)reInitSession {

    if (self.captureSession) {
        
        self.captureSession = nil;
    }
    
    self.captureSession = [[AVCaptureSession alloc] init];
    self.captureSession.sessionPreset = AVCaptureSessionPreset640x480;
    self.captureVideoPreviewLayer.session =  self.captureSession;
}

- (void)reInitOutput {

    if (self.captureVideoDataOutput) {
        
        self.captureVideoDataOutput = nil;
    }
    
    self.captureVideoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    self.captureConnection = [self.captureVideoDataOutput connectionWithMediaType:AVMediaTypeVideo];
}

- (void)resetupVideoInput {
    
    // remove
    if (self.captureDeviceInput) {
        
        [self.captureSession removeInput:self.captureDeviceInput];
    }
    
    if ([self.captureSession canAddInput:self.captureDeviceInput]) {
        [self.captureSession addInput:self.captureDeviceInput];
    }
}

- (void)resetupVideoOutput {
    
    // remove
    if (self.captureVideoDataOutput) {
    
        [self.captureSession removeOutput:self.captureVideoDataOutput];
    }
    
    if ([self.captureSession canAddOutput:self.captureVideoDataOutput]) {
        [self.captureSession addOutput:self.captureVideoDataOutput];
    }
    
    self.captureConnection.enabled = YES;
    if ([self.captureConnection isVideoStabilizationSupported]) {
        [self.captureConnection setPreferredVideoStabilizationMode:AVCaptureVideoStabilizationModeAuto];
    }
    
    if ([self.captureConnection isVideoOrientationSupported]) {
        [self.captureConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    }
    
    // discard if the data output queue is blocked
    self.captureVideoDataOutput.alwaysDiscardsLateVideoFrames = YES;
    self.captureVideoDataOutput.videoSettings = @{(id)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)};
    [self.captureVideoDataOutput setSampleBufferDelegate:self queue:self.videoDataOutputQueue];
}

- (void)changeCamera {

    AVCaptureDevice *currentVideoDevice = self.captureDeviceInput.device;
    AVCaptureDevicePosition currentPosition = [currentVideoDevice position];
    
    switch (currentPosition){
        case AVCaptureDevicePositionUnspecified:
            self.devicePosition = AVCaptureDevicePositionFront;
            break;
        case AVCaptureDevicePositionBack:
            self.devicePosition = AVCaptureDevicePositionFront;
            break;
        case AVCaptureDevicePositionFront:
            self.devicePosition = AVCaptureDevicePositionBack;
            break;
    }
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection {
    
    self.captureOutput(captureOutput, sampleBuffer, connection);
}

#pragma mark - Unit

+ (AVCaptureDevice *)deviceType:(NSString *)mediaType position:(AVCaptureDevicePosition)position{
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
    
    for (AVCaptureDevice *device in devices){
        if ([device position] == position){
            return device;
        }
    }
    
    return nil;
}

+ (NSUInteger)cameraCount {

    return [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
}

@end
