//
//  SKSHardwareAuthorization.h
//  SkySea
//
//  Created by whj on 16/6/28.
//  Copyright © 2016年 skysea. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SKSALAuthorizationStatus)(BOOL authorized);
typedef void(^SKSAVAuthorizationStatus)(BOOL authorized);

@interface SKSHardwareAuthorization : NSObject

/**
 *  获取全局唯一的一个对象
 *
 *  @return 对象
 */
+ (instancetype)defaultInstance;

/**
 *  检测相册权限
 *
 *  @param block 回掉
 */
- (void)accessLibrary:(SKSALAuthorizationStatus)block;

/**
 *  检测相机权限
 *
 *  @param block 回掉
 */
- (void)accessCamera:(SKSAVAuthorizationStatus)block;

@end
