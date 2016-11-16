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
        self.backgroundColor = [UIColor clearColor];
        
        self.viewMaps = [NSMutableDictionary dictionary];
        
        [self p_initData];
        [self p_initView];
        [self p_addConstraints];
    }
    return self;
}

#pragma mark - OverWrite

- (void)p_initData {}
- (void)p_initView {}
- (void)p_addConstraints {}
- (void)cellWithConent:(id)conent {}

@end
