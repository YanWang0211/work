//
//  FYTabbar.m
//  几里
//
//  Created by 泰山金融 on 2018/7/9.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import "FYTabbar.h"

@implementation FYTabbar
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
//        [self setupInit];
    }
    return self;
}

- (void)setupInit
{
    if (!isIPhoneX())
    {
        // 设置样式 取出边线
        self.barStyle = UIBarStyleBlack;
//        self.backgroundImage = [UIImage imageNamed:@"ic_tab_bg"];
    }
    else
    {
        self.backgroundColor = [UIColor whiteColor];
        self.tintColor = [UIColor whiteColor];
        self.translucent = YES;
    }
}
#pragma mark 布局子控件
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    for (UIView *subView in self.subviews)
    {
        if ([subView isKindOfClass:NSClassFromString(@"UITabBarButton")])
        {
            UIControl *tabBarBtn = (UIControl *)subView;
            [tabBarBtn addTarget:self action:@selector(tabBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }

}


#pragma mark 动画
- (void)tabBarButtonClick:(UIControl *)tabBarButton
{
    for (UIView *imageView in tabBarButton.subviews)
    {
        if ([imageView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")])
        {
            // 需要实现的帧动画,这里根据需求自定义
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
            animation.keyPath = @"transform.scale";
            // @1.0,@1.3,@0.9,@1.15,@0.95,@1.02,@1.0
            animation.values = @[@1.0,@1.25,@0.9,@1.15,@1.0];
            animation.duration = 0.4;
            animation.calculationMode = kCAAnimationCubic;
            // 把动画添加上去就OK了
            [imageView.layer addAnimation:animation forKey:nil];
        }
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
