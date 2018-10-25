//
//  recoderAnimationView.m
//  几里
//
//  Created by 泰山金融 on 2018/8/10.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import "recoderAnimationView.h"

@interface recoderAnimationView ()

@property (nonatomic,strong) NSString * title;
@property (nonatomic,strong) NSString * image;//
@property (nonatomic,strong) UILabel  * titleL;//
@property (nonatomic,strong) UIImageView * imageV;//

@end

@implementation recoderAnimationView

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title withImage:(NSString *)image{
    if ( self == [super initWithFrame:frame]) {
        self.title = title;
        self.image = image;
        self.layer.masksToBounds = YES;
        [self setUI];
    }
    return self;
}

- (void) setUI{
    
    _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
    _imageV.image = [UIImage imageNamed:self.image];
    [self addSubview:_imageV];
    
    _titleL = [[UILabel alloc] initWithFrame:CGRectMake(0,self.frame.size.width - 10, self.frame.size.width, 20)];
    _titleL.textAlignment = NSTextAlignmentCenter;
    _titleL.font = [UIFont systemFontOfSize:17];
    _titleL.textColor = [UIColor whiteColor];
    [self addSubview:_titleL];
    _titleL.text = self.title;
    
    [self startAnimation];
    
    if (self.title == nil) {
        self.backgroundColor = [UIColor clearColor];
    }else{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    }
    
}

- (void)startAnimation{
    //缩放动画
    CABasicAnimation *anima2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anima2.fromValue = [NSNumber numberWithFloat:0.8f];
    anima2.toValue = [NSNumber numberWithFloat:0.6f];
    anima2.duration = 1;
    anima2.autoreverses = YES;
    anima2.repeatCount = MAXFLOAT;
    
    
    CABasicAnimation *showViewAnn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    showViewAnn.fromValue = [NSNumber numberWithFloat:1.0f];
    showViewAnn.toValue = [NSNumber numberWithFloat:0.7f];
    showViewAnn.duration = 1;
    showViewAnn.autoreverses = YES;
    showViewAnn.repeatCount = MAXFLOAT;
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = [NSArray arrayWithObjects:anima2,showViewAnn, nil];
    groupAnimation.duration = 1;
    groupAnimation.autoreverses = YES;
    groupAnimation.repeatCount = MAXFLOAT;
    [_imageV.layer addAnimation:groupAnimation forKey:@"groupAnimation"];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
