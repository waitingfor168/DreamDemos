//
//  HJScrollSelectorView.m
//  FaceDetector
//
//  Created by whj on 2016/11/15.
//  Copyright © 2016年 dream. All rights reserved.
//

#import "HJScrollSelectorView.h"
#import "HJTableViewCellProtocol.h"

@interface HJScrollSelectorView () <UITableViewDelegate, UITableViewDataSource> {

    UITableView *_tabelView;
    NSArray *_dataResources;
    NSString *_cellName;
    
    CGFloat cellHeight;
}

@property (nonatomic, copy) TouchedAction touchedAction;

@end

@implementation HJScrollSelectorView

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        [self ss_initTableView];
        [self ss_initData];
    }
    return self;
}

- (void)ss_initTableView {
    
    _tabelView = [[UITableView alloc] initWithFrame:CGRectZero];
    _tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tabelView.backgroundColor = [UIColor whiteColor];
    _tabelView.showsHorizontalScrollIndicator = NO;
    _tabelView.showsVerticalScrollIndicator = NO;
    _tabelView.pagingEnabled = YES;
    _tabelView.dataSource = self;
    _tabelView.delegate = self;
    [self addSubview:_tabelView];
}

- (void)ss_initData {

    cellHeight = CellProtocolHeight;
    
    [self orientation];
}

#pragma mark - Methods

- (void)resource:(NSArray *)resource {

    NSAssert(resource, @"resource should not be nil.");
    _dataResources = resource;
}

- (void)registerCellName:(NSString *)cellName {

    NSAssert(cellName, @"Cell Name should not be nil.");
    _cellName = cellName;
    Class cellClass = NSClassFromString(cellName);
    [_tabelView registerClass:cellClass forCellReuseIdentifier:cellName];
}

- (void)orientation {

    // 居中旋转
    float viewWidth = self.bounds.size.width;
    float viewHeight = self.bounds.size.height;
    float viewPointx = (viewWidth - viewHeight) / 2;
    float viewPointy = (viewHeight - viewWidth) / 2;
    
    _tabelView.frame = CGRectMake(viewPointx, viewPointy, viewHeight, viewWidth);
    _tabelView.transform = CGAffineTransformMakeRotation(-M_PI_2);
}

- (void)cellHeight:(CGFloat)height {

    cellHeight = height;
}

- (void)cellTouchedWithBlock:(TouchedAction)sender {

    self.touchedAction = sender;
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataResources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell<HJTableViewCellProtocol> *cell = [tableView dequeueReusableCellWithIdentifier:_cellName
                                                                                     forIndexPath:indexPath];
        
    if ([cell respondsToSelector:@selector(cellWithConent:)]) {
        
        [cell cellWithConent:_dataResources[indexPath.row]];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    self.touchedAction(_dataResources[indexPath.row]);
}

@end
