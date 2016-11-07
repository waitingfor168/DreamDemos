//
//  SKSCustomImagePickerController.m
//  SkySea
//
//  Created by whj on 15/8/3.
//  Copyright (c) 2015年 skysea. All rights reserved.
//

#import "SKSCustomImagePickerController.h"
#import "SKSHardwareAuthorization.h"
//#import "PECropViewController.h"

//UIApplication
#define SKSApplication          [UIApplication sharedApplication]
#define SKSKeyWindow            SKSApplication.keyWindow
#define SKSKeyWindowBounds      SKSKeyWindow.bounds
#define SKSRootViewController   [SKSKeyWindow rootViewController]

@interface SKSCustomImagePickerController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {

    __weak UIViewController<SKSCustomImagePickerControllerDelegate> *_target;
}

@end

@implementation SKSCustomImagePickerController

+ (instancetype)customImagePickerControllerWithTarget:(id)target {
    
    return [[SKSCustomImagePickerController alloc] initWithTarget:target];
}

- (id)initWithTarget:(id)target {
    
    if (self = [super init]) {
        
        [self setDelegate:self];
        [self setAllowsEditing:YES];
        [self.view setBackgroundColor:[UIColor grayColor]];
        
        _target = target;
        [self setCustomDelegate:_target];
    }
    
    return self;
}

- (void)openCamera {
    
    [[SKSHardwareAuthorization defaultInstance] accessCamera:^(BOOL authorized) {
        
        if (authorized) {
            
            if ([SKSCustomImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                
                [self setSourceType:UIImagePickerControllerSourceTypeCamera];
                [self setShowsCameraControls:YES];
                
                //[_target presentViewController:self animated:YES completion:nil];
                [SKSRootViewController presentViewController:self animated:YES completion:nil];
            }else{
                
                NSLog(@"No Camera");
            }
        }
    }];
}

- (void)openLocalPhoto {
    
    [[SKSHardwareAuthorization defaultInstance] accessLibrary:^(BOOL authorized) {
        
        if (authorized) {
            
            [self setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            //[_target presentViewController:self animated:YES completion:nil];
            [SKSRootViewController presentViewController:self animated:YES completion:nil];
        }
    }];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UINavigationController
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    [[UIApplication  sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    navigationController.navigationBar.titleTextAttributes = dict;
    
    for (UIViewController *viewController in [navigationController viewControllers]) {
        viewController.view.backgroundColor = [UIColor whiteColor];
//        viewController.view.backgroundColor = [UIColor clearColor];
//        for (UIView *view in [viewController.view subviews]) {
//            
//            view.backgroundColor = [UIColor clearColor];
//            UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
//            
//            if ([view isKindOfClass:[UITableView class]]) {
//                
//                UITableView *tableView = (UITableView *)view;
//                
//                [imageview setFrame:CGRectMake(0, -64, tableView.frame.size.width, tableView.frame.size.height + 64)];
//                
//                UIView *view = [[UIView alloc] init];
//                [view setBackgroundColor:[UIColor clearColor]];
//                [view addSubview:imageview];
//                
//                tableView.backgroundView = view;
//                
//            }
        
//            if ([view isKindOfClass:[UICollectionView class]]) {
//                
//                UICollectionView *collectionView = (UICollectionView *)view;
//                
//                [imageview setFrame:collectionView.bounds];
//                
//                UIView *view = [[UIView alloc] init];
//                [view setBackgroundColor:[UIColor clearColor]];
//                [view addSubview:imageview];
//                
//                collectionView.backgroundView = view;
//            }
//        }
    }
}

-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    [[UIApplication  sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    navigationController.navigationBar.titleTextAttributes = dict;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIImagePickerController Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if (info == nil) {
        
        NSLog(@"PickingMediaInfo not can not nil");
        [picker dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        [picker dismissViewControllerAnimated:YES completion:^{
            
            [self.customDelegate customImagePickerController:self didFinishPickingMediaWithImage:image];
        }];
    }
}

//#pragma mark - UIImagePickerController delegate
//
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
//
//    [picker dismissViewControllerAnimated:YES completion:^{
//        PECropViewController *crop = [[PECropViewController alloc] init];
//        crop.delegate = self;
//        crop.image = selectedImage;
//
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:crop];
//        [_target presentViewController:nav animated:YES completion:NULL];
//    }];
//}
//
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
//    [picker dismissViewControllerAnimated:YES completion:nil];
//}
//
//
//#pragma mark - PECropViewController
//
//- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage
//{
//    [controller dismissViewControllerAnimated:YES completion:NULL];
//
//    [self.customDelegate customImagePickerController:self didFinishPickingMediaWithImage:image];
//}
//
//- (void)cropViewControllerDidCancel:(PECropViewController *)controller {
//    [controller dismissViewControllerAnimated:YES completion:NULL];
//}

@end
