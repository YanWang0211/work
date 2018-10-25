//
//  chatcellbackview.m
//  几里
//
//  Created by 泰山金融 on 2018/8/8.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import "chatcellbackview.h"

@implementation chatcellbackview

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
  
    /*画圆角矩形*/
    float fw = self.frame.size.width;
    float fh = self.frame.size.height;
    
    if (self.type == 1) {
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextMoveToPoint(context, 0, 0);  // 开始坐标左边开始
        CGContextAddLineToPoint(context, fw - 15, 0);
        CGContextAddQuadCurveToPoint(context, fw,0,fw,15);  // you上角角度
        CGContextAddLineToPoint(context, fw, fh - 15);
        CGContextAddQuadCurveToPoint(context, fw, fh, fw - 15, fh); // 右下角角度
        CGContextAddLineToPoint(context, 15, fh);
        CGContextAddQuadCurveToPoint(context, 0, fh, 0, fh - 15); // 左xia角
         CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    }else{
        CGContextSetStrokeColorWithColor(context, kAppMainColor.CGColor);
        CGContextMoveToPoint(context, fw, 0);  // 开始坐标you边开始
        CGContextAddLineToPoint(context, fw, fh - 15);
        CGContextAddQuadCurveToPoint(context, fw, fh, fw - 15, fh); // 右下角角度
        CGContextAddLineToPoint(context, 15, fh);
        CGContextAddQuadCurveToPoint(context, 0, fh, 0, fh - 15); // 左xia角
        CGContextAddLineToPoint(context, 0, 15);
        CGContextAddQuadCurveToPoint(context, 0, 0, 15, 0);  // 左上角角度
         CGContextSetFillColorWithColor(context, kAppMainColor.CGColor);
    }

    CGContextClosePath(context);
    
    CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径

}

@end
