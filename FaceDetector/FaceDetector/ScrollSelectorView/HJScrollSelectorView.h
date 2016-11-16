//
//  HJScrollSelectorView.h
//  FaceDetector
//
//  Created by whj on 2016/11/15.
//  Copyright © 2016年 dream. All rights reserved.
//



#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    Orientation_Up,
    Orientation_Left,
    Orientation_Default = Orientation_Up,
} ScrollSelectorViewOrientation;

typedef void(^TouchedAction)(id sender);


/**
 使用说明:
 0.导入文件夹ScrollSelectorView;
 1.#import "HJScrollSelectorView.h";
 2.@property (nonatomic, strong) HJScrollSelectorView *scrollSelectorView;
 3.self.scrollSelectorView = [[HJScrollSelectorView alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
 [self.scrollSelectorView resource:@[@"icon-film", @"icon_photo"]];
 [self.scrollSelectorView registerCellName:@"HJImageTableViewCell"];
 [self.scrollSelectorView setCellHeight:150];
 [self.scrollSelectorView cellOrientation:Orientation_Left];
 [self.view addSubview:self.scrollSelectorView];
 
 __weak typeof(self) weakSelf = self;
 [self.scrollSelectorView cellTouchedWithBlock:^(id sender) {
 
 __weak typeof(weakSelf) strongSelf = weakSelf;
 [strongSelf changeStyle:[sender isEqualToString:@"icon_photo"]];
 }];
 */

@interface HJScrollSelectorView : UIView

- (void)resource:(NSArray *)resource;
- (void)registerCellName:(NSString *)cellName;
- (void)cellOrientation:(ScrollSelectorViewOrientation)orientation;
- (void)cellTouchedWithBlock:(TouchedAction)sender;

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign, readonly) ScrollSelectorViewOrientation orientation;

@end
