//
//  WYSlider.m
//  几里
//
//  Created by 泰山金融 on 2018/8/8.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import "WYSlider.h"

@implementation WYSlider
//- (CGRect)minimumValueImageRectForBounds:(CGRect)bounds;  //返回左边图片大小
//- (CGRect)maximumValueImageRectForBounds:(CGRect)bounds;  //返回右边图片大小
- (CGRect)trackRectForBounds:(CGRect)bounds{
    return CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));

}             //返回滑道大小
//- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value{
//
//    return CGRectInset([super thumbRectForBounds:bounds trackRect:rect value:value],  CGRectGetHeight(self.frame),  CGRectGetHeight(self.frame));
//}  //返回滑块大小


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
