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

@interface HJScrollSelectorView : UIView

- (void)resource:(NSArray *)resource;
- (void)registerCellName:(NSString *)cellName;
- (void)cellOrientation:(ScrollSelectorViewOrientation)orientation;
- (void)cellTouchedWithBlock:(TouchedAction)sender;

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign, readonly) ScrollSelectorViewOrientation orientation;

@end
