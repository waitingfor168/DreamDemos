//
//  HJTableViewCellProtocol.h
//  FaceDetector
//
//  Created by whj on 2016/11/15.
//  Copyright © 2016年 dream. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CellProtocolHeight 80

@protocol HJTableViewCellProtocol <NSObject>

@required

/**
 外层传入的资源

 @param conent 资源内容
 */
- (void)cellWithConent:(id)conent;

@end
