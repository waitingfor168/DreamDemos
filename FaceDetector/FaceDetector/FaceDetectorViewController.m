//
//  FaceDetectorViewController.m
//  FaceDetector
//
//  Created by whj on 16/10/19.
//  Copyright © 2016年 dream. All rights reserved.
//

#import "FaceDetectorViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface FaceDetectorViewController () <AVCaptureVideoDataOutputSampleBufferDelegate> {

}

@property (nonatomic) dispatch_queue_t captureSessionQueue;
@property (nonatomic) dispatch_queue_t videoDataOutputQueue;

@property (nonatomic) UIBackgroundTaskIdentifier backgroundTaskIdentifier;

@property (nonatomic, strong) CIDetector *faceDetector;

@property (nonatomic, strong) AVCaptureDevice *captureDevice;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureConnection *captureConnection;
@property (nonatomic, strong) AVCaptureDeviceInput *captureDeviceInput;
@property (nonatomic, strong) AVCaptureVideoDataOutput *captureVideoDataOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;

@end

@implementation FaceDetectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

    self.captureSessionQueue = dispatch_queue_create("dream.facedetector.session.queue", DISPATCH_QUEUE_SERIAL);
    self.videoDataOutputQueue = dispatch_queue_create("dream.facedetector.dataoutput.queue", DISPATCH_QUEUE_SERIAL);
    
    self.captureSession = [[AVCaptureSession alloc] init];
    self.captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    
    self.captureDevice = [[self class] deviceType:AVMediaTypeVideo position:AVCaptureDevicePositionFront];
    
    NSError *error = nil;
    self.captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.captureDevice error:&error];
    
    if (error) {
        NSLog(@"captureDeviceInput:%@", error);
    }
    
    self.captureVideoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    self.captureConnection = [self.captureVideoDataOutput connectionWithMediaType:AVMediaTypeVideo];
    
    NSDictionary *detectorOptions = @{CIDetectorAccuracy : CIDetectorAccuracyLow};
    self.faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:detectorOptions];
    
    self.captureVideoPreviewLayer.frame= self.view.frame;
    self.captureVideoPreviewLayer.position=self.view.center;
    self.captureVideoPreviewLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.captureVideoPreviewLayer];
}

- (void)p_clear {

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

- (void)p_setup {

    dispatch_async(self.captureSessionQueue, ^{
       
        self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
        
        [self.captureSession beginConfiguration];
        
        self.captureSession.sessionPreset = AVCaptureSessionPreset640x480;
        
        if ([self.captureSession canAddInput:self.captureDeviceInput]) {
            [self.captureSession addInput:self.captureDeviceInput];
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
        
        [self.captureSession commitConfiguration];
        [self.captureSession startRunning];
    });
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection {

    // get the image
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    CIImage *ciImage = [[CIImage alloc] initWithCVPixelBuffer:pixelBuffer
                                                      options:(__bridge NSDictionary *)attachments];
    if (attachments) {
        CFRelease(attachments);
    }
    
    NSDictionary *imageOptions = @{CIDetectorImageOrientation : @(6)};
    
    NSArray *features = [self.faceDetector featuresInImage:ciImage
                                                   options:imageOptions];
    
    // get the clean aperture
    // the clean aperture is a rectangle that defines the portion of the encoded pixel dimensions
    // that represents image data valid for display.
//    CMFormatDescriptionRef fdesc = CMSampleBufferGetFormatDescription(sampleBuffer);
//    CGRect cleanAperture = CMVideoFormatDescriptionGetCleanAperture(fdesc, false /*originIsTopLeft == false*/);
    
    for ( CIFaceFeature *ff in features ) {
        // find the correct position for the square layer within the previewLayer
        // the feature box originates in the bottom left of the video frame.
        // (Bottom right if mirroring is turned on)
//        CGRect faceRect = [ff bounds];
        
        NSLog(@"==>>:%@", ff);
    }
}

#pragma mark - Class

+ (AVCaptureDevice *)deviceType:(NSString *)mediaType position:(AVCaptureDevicePosition)position{
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
    AVCaptureDevice *captureDevice = [devices firstObject];
    
    for (AVCaptureDevice *device in devices){
        if ([device position] == position){
            captureDevice = device;
            break;
        }
    }
    
    return captureDevice;
}

@end
