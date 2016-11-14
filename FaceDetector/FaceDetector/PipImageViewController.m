//
//  PipImageViewController.m
//  FaceDetector
//
//  Created by whj on 2016/11/7.
//  Copyright © 2016年 dream. All rights reserved.
//

#import "PipImageViewController.h"
#import "SKSCustomImagePickerController.h"
#import "UIImage+ReDrew.h"
#import "ZoomImage.h"

@interface PipImageViewController () <SKSCustomImagePickerControllerDelegate>

@property (nonatomic, strong) SKSCustomImagePickerController *imagePickerController;

@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UIImageView *blurImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet ZoomImage *pipImageView;

@property (nonatomic, strong) UIImage *originImage;
@property (nonatomic, strong) UIImage *maskImage;
@property (nonatomic, strong) CALayer *maskLayer;

@end

@implementation PipImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"PIP Image";
    
    [self p_initObject];
    [self p_setup];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    NSLog(@"MemoryWarning !!!");
}

-(void)dealloc {

     [self p_clear];
}

- (void)p_initObject {
    
}

- (void)p_clear {
    
    self.imagePickerController = nil;
}

- (void)p_setup {
    
    self.imagePickerController = [SKSCustomImagePickerController customImagePickerControllerWithTarget:self];
    self.originImage = [UIImage imageNamed:@"bg.jpg"];
    self.bgImageView.image = _originImage;
    
}

- (IBAction)savePhotoAction:(UIButton *)sender {
    
    UIImage *image = [UIImage imageRenderView:self.baseView];
    
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}

- (IBAction)selectImage:(id)sender {

    [self.imagePickerController openLocalPhoto];
}

- (IBAction)changeAction:(UIButton *)sender {
    
    [self changeStyle:(int)(sender.tag - 200)];
}

#pragma mark - Unit

- (void)changeStyle:(int)style {
    
    if (self.originImage == nil) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择一张图片" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (style == 0) {
        
        _bgImageView.image = [UIImage imageNamed:@"film.png"];
        _maskImage = [UIImage imageNamed:@"film_mask.png"];
        float scale = _bgImageView.image.size.width / self.view.frame.size.width;
        
        CGSize size = _maskImage.size;
        _maskLayer = [CALayer layer];
        _maskLayer.frame = CGRectMake(0, 0, size.width / scale, size.height / scale);
        _maskLayer.contents = (__bridge id)(_maskImage.CGImage);
        _pipImageView.layer.mask = _maskLayer;
        _pipImageView.frame = CGRectMake(39, 78, size.width / scale, size.height / scale);
        
    } else {
        
        _bgImageView.image = [UIImage imageNamed:@"photo.png"];
        _maskImage = [UIImage imageNamed:@"photo_mask.png"];
        float scale = _bgImageView.image.size.width / self.view.frame.size.width;
        
        CGSize size = _maskImage.size;
        _maskLayer = [CALayer layer];
        _maskLayer.frame = CGRectMake(0, 0, size.width / scale, size.height / scale);
        _maskLayer.contents = (__bridge id)(_maskImage.CGImage);
        _pipImageView.layer.mask = _maskLayer;
        _pipImageView.frame = CGRectMake(70, 60, size.width / scale, size.height / scale);
    }
    
    UIImage *brImage = [UIImage boxblurImage:self.originImage withBlurNumber:30];
    
    self.blurImageView.image = brImage;
    [self.pipImageView setImage:self.originImage];
}

#pragma mark - SKSCustomImagePickerControllerDelegate

- (void)customImagePickerController:(SKSCustomImagePickerController *)picker didFinishPickingMediaWithImage:(UIImage *)image {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.originImage = image;
        self.bgImageView.image = image;
    });
}

@end
