//
//  ViewController.m
//  FaceDetector
//
//  Created by whj on 16/10/19.
//  Copyright © 2016年 dream. All rights reserved.
//

#import "ViewController.h"
#import "FaceDetectorViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    FaceDetectorViewController *faceDetectorViewController = [[FaceDetectorViewController alloc] init];
    [self.navigationController pushViewController:faceDetectorViewController animated:YES];
}

@end
