//
//  CanvasView.m
//  FaceDetector
//
//  Created by whj on 16/10/19.
//  Copyright © 2016年 dream. All rights reserved.
//

#import "CanvasView.h"

@interface CanvasView () {
    
    CGContextRef context;
}

@end

@implementation CanvasView

- (void)drawRect:(CGRect)rect {
    
    if (context) {
        CGContextClearRect(context, self.bounds) ;
    }
    context = UIGraphicsGetCurrentContext();
    
    for (NSDictionary *dicPerson in self.faces) {
        
        if ([dicPerson objectForKey:Key_Points]) {
            
            for (id point in [dicPerson objectForKey:Key_Points]) {
                CGPoint p = [point CGPointValue];
                CGContextAddEllipseInRect(context, CGRectMake(p.x - 1 , p.y - 1 , 2 , 2));
            }
        }
        
        if ([dicPerson objectForKey:Key_FaceRect]) {
            
            CGRect rect = [[dicPerson objectForKey:Key_FaceRect] CGRectValue];
            
            // 完整矩形
            // CGContextAddRect(context,rect) ;
            
            // 只画矩形四角
            // 左上
            CGContextMoveToPoint(context, rect.origin.x, rect.origin.y + rect.size.height / 8);
            CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y);
            CGContextAddLineToPoint(context, rect.origin.x + rect.size.width / 8, rect.origin.y);
            
            // 右上
            CGContextMoveToPoint(context, rect.origin.x + rect.size.width * 7 / 8, rect.origin.y);
            CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y);
            CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height / 8);
            
            // 左下
            CGContextMoveToPoint(context, rect.origin.x, rect.origin.y + rect.size.height * 7 / 8);
            CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + rect.size.height);
            CGContextAddLineToPoint(context, rect.origin.x + rect.size.width / 8, rect.origin.y + rect.size.height);
            
            // 右下
            CGContextMoveToPoint(context, rect.origin.x + rect.size.width * 7 / 8, rect.origin.y + rect.size.height);
            CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
            CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height * 7 / 8);
        }
    }
    
    [[UIColor greenColor] set];
    CGContextSetLineWidth(context, 2);
    CGContextStrokePath(context);
}

@end
