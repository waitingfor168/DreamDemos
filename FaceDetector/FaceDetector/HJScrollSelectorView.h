//
//  HJScrollSelectorView.h
//  FaceDetector
//
//  Created by whj on 2016/11/15.
//  Copyright © 2016年 dream. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TouchedAction)(id sender);

@interface HJScrollSelectorView : UIView

- (void)resource:(NSArray *)resource;
- (void)registerCellName:(NSString *)cellName;
- (void)cellTouchedWithBlock:(TouchedAction)sender;

@end
