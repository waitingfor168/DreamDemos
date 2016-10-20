//
//  FaceDetectorViewController.m
//  FaceDetector
//
//  Created by whj on 16/10/19.
//  Copyright © 2016年 dream. All rights reserved.
//

#import "FaceDetectorViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CanvasView.h"

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

@property (nonatomic, strong) CanvasView *canvasView;
@property (nonatomic, strong) NSMutableArray *facePoints;

@property (nonatomic, strong) UIImageView *imageView;

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
    
    self.captureVideoPreviewLayer.frame = self.view.frame;
    self.captureVideoPreviewLayer.position = self.view.center;
    self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.captureVideoPreviewLayer];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 480, 640)];
    self.imageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.imageView];
    [self.view bringSubviewToFront:self.imageView];
    
    self.canvasView = [[CanvasView alloc] initWithFrame:self.view.bounds];
    self.canvasView.backgroundColor = [UIColor clearColor];
    self.canvasView.center = self.view.center;
    [self.view addSubview:self.canvasView];
    [self.view bringSubviewToFront:self.canvasView];
    
    self.facePoints = [[NSMutableArray alloc] initWithCapacity:0];
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
    
    self.facePoints = nil;
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
    // 调整ciImage的方向
    ciImage = [ciImage imageByApplyingOrientation:UIImageOrientationDownMirrored];
    
    if (attachments) {
        CFRelease(attachments);
    }
    
    // ciImage 相对于手机的方向
    NSDictionary *imageOptions = @{CIDetectorImageOrientation : @(1)};
    NSArray *features = [self.faceDetector featuresInImage:ciImage
                                                   options:imageOptions];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
//        self.imageView.image = [UIImage imageWithCIImage:ciImage];
    });
    
    [self p_chanagePoint:features size:ciImage.extent.size];
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

#pragma mark - Unit

- (void)p_chanagePoint:(NSArray *)features size:(CGSize)ciImageSize {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // 坐标转换
        CGAffineTransform transform = CGAffineTransformIdentity;
        transform = CGAffineTransformScale(transform, 1, -1);
        transform = CGAffineTransformTranslate(transform, 0, -ciImageSize.height);
        
        self.canvasView.hidden = YES;
        if (features == nil || features.count < 1) return;
        
        self.canvasView.hidden = NO;
        [self.facePoints removeAllObjects];
        
        for (CIFaceFeature *faceFeature in features) {
            
            CGRect faceViewBounds = CGRectApplyAffineTransform(faceFeature.bounds, transform);
            CGPoint mouthPosition = CGPointApplyAffineTransform(faceFeature.mouthPosition, transform);
            CGPoint leftEyePosition = CGPointApplyAffineTransform(faceFeature.leftEyePosition, transform);
            CGPoint rightEyePosition = CGPointApplyAffineTransform(faceFeature.rightEyePosition, transform);
            
            // 获取在ciImage的左边相对于实际view的坐标
            CGFloat width = self.view.bounds.size.width;
            CGFloat height = self.view.bounds.size.height;
            CGFloat widthScale = width / ciImageSize.width;
            CGFloat heightScale = height / ciImageSize.height;
            
            faceViewBounds.origin.x *= widthScale;
            faceViewBounds.origin.y *= heightScale;
            faceViewBounds.size.width *= widthScale;
            faceViewBounds.size.height *= heightScale;
            
            mouthPosition.x *= widthScale;
            mouthPosition.y *= heightScale;
            leftEyePosition.x *= widthScale;
            leftEyePosition.y *= heightScale;
            rightEyePosition.x *= widthScale;
            rightEyePosition.y *= heightScale;
            
            // Point Rect 装箱
            NSArray *points = @[[NSValue valueWithCGPoint:leftEyePosition],
                                [NSValue valueWithCGPoint:rightEyePosition],
                                [NSValue valueWithCGPoint:mouthPosition]];
            NSValue *faceRectValue = [NSValue valueWithCGRect:faceViewBounds];
            NSDictionary *faceDictionary = @{Key_FaceRect : faceRectValue, Key_Points : points};
            
            [self.facePoints addObject:faceDictionary];
        }
        self.canvasView.faces = self.facePoints;
        [self.canvasView setNeedsDisplay];
    });
}

@end
