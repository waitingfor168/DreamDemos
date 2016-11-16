//
//  PipImageViewController.m
//  FaceDetector
//
//  Created by whj on 2016/11/7.
//  Copyright © 2016年 dream. All rights reserved.
//

#import "PipImageViewController.h"
#import "SKSCustomImagePickerController.h"
#import "HJScrollSelectorView.h"
#import "UIImage+ReDrew.h"
#import "UIView+Mask.h"
#import "ZoomImage.h"

/** 弱引用 */
#define WS __weak typeof(self) weakSelf = self;
#define WeakObj(obj) __weak typeof(obj) weakObj = obj;

/** 强引用 */
#define SWS __weak typeof(weakSelf) strongSelf = weakSelf;
#define StrongObj(obj) __strong typeof(obj) strongObj = obj;

@interface PipImageViewController () <SKSCustomImagePickerControllerDelegate>

@property (nonatomic, strong) SKSCustomImagePickerController *imagePickerController;

@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UIImageView *blurImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet ZoomImage *pipImageView;

@property (nonatomic, strong) HJScrollSelectorView *scrollSelectorView;
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
    
    
    self.scrollSelectorView = [[HJScrollSelectorView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 150, self.view.frame.size.width, 150)];
    [self.scrollSelectorView resource:@[@"icon-film", @"icon_photo", @"icon-film", @"icon_photo", @"icon-film", @"icon_photo", @"icon-film", @"icon_photo"]];
    [self.scrollSelectorView registerCellName:@"HJImageTableViewCell"];
    [self.scrollSelectorView setCellHeight:150];
    [self.scrollSelectorView cellOrientation:Orientation_Left];
    [self.view addSubview:self.scrollSelectorView];
    
    __weak typeof(self) weakSelf = self;
    [self.scrollSelectorView cellTouchedWithBlock:^(id sender) {
        
        __weak typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf changeStyle:[sender isEqualToString:@"icon_photo"]];
    }];
}

- (IBAction)savePhotoAction:(UIButton *)sender {
    
    UIImage *image = [UIImage imageRenderView:self.baseView];
    
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}

- (IBAction)selectImage:(id)sender {

    [self.imagePickerController openLocalPhoto];
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
        _maskImage = [UIImage imageNamed:@"film_mask0.png"];
       
    } else {
        
        _bgImageView.image = [UIImage imageNamed:@"photo.png"];
        _maskImage = [UIImage imageNamed:@"photo_mask0.png"];
    }
    
    float scale = _bgImageView.image.size.width / self.view.frame.size.width;
    
    CGFloat sizeWidth = _maskImage.size.width / scale;
    CGFloat sizeHeight = _maskImage.size.height / scale;
    CGRect frame = CGRectZero;
    frame.size = CGSizeMake(sizeWidth, sizeHeight);
    [_pipImageView viewMaskFrame:frame image:_maskImage];
    
    // 背景高斯模糊
    UIImage *brImage = [UIImage boxblurImage:self.originImage withBlurNumber:30];
    self.blurImageView.image = brImage;
    
    // ZoomImage setImage:
    self.pipImageView.image = self.originImage;
}

#pragma mark - SKSCustomImagePickerControllerDelegate

- (void)customImagePickerController:(SKSCustomImagePickerController *)picker didFinishPickingMediaWithImage:(UIImage *)image {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.originImage = image;
        self.bgImageView.image = image;
    });
}

@end
