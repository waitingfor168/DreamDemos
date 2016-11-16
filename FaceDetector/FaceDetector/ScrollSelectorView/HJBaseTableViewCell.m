//
//  HJBaseTableViewCell.m
//  FaceDetector
//
//  Created by whj on 2016/11/15.
//  Copyright © 2016年 dream. All rights reserved.
//

#import "HJBaseTableViewCell.h"

@implementation HJBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.transform = CGAffineTransformMakeRotation(M_PI_2);
        self.backgroundColor = [UIColor clearColor];
        
        [self p_initView];
    }
    return self;
}

#pragma mark - OverWrite
- (void)p_initView {}
- (void)cellWithConent:(id)conent {}

@end
