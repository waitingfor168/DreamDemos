//
//  CanvasView.h
//  FaceDetector
//
//  Created by whj on 16/10/19.
//  Copyright © 2016年 dream. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Key_Points      @"dream.canvas.points.key"
#define Key_FaceRect    @"dream.canvas.face.rect.key"

@interface CanvasView : UIView


/**
 面部坐标集合
 */
@property (nonatomic, strong) NSArray *faces;

@end
