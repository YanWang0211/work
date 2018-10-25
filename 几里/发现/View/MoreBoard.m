//
//  MoreBoard.m
//  几里
//
//  Created by 泰山金融 on 2018/7/17.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import "MoreBoard.h"

@implementation MoreBoard

- (instancetype)initWithFrame:(CGRect)frame{
    if (self  == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setUI];
    }
    return self;
}

- (void)setUI{
    
    NSArray *imageArr = @[@"chatroom_camera",@"chatroom_photo",@"chatroom_video",@"chatroom_location"];
    NSArray *title = @[@"拍照",@"相册",@"视频",@"位置"];
    for (int i = 0 ; i < imageArr.count; i ++) {
     
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenW / 4 * i, 0, kScreenW / 4, 200)];
        [btn setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [btn setTitle:title[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:btn];
        btn.imageEdgeInsets = UIEdgeInsetsMake(-20, 20, 20, -20);
        btn.titleEdgeInsets = UIEdgeInsetsMake(20, -20, -20, 20);
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100 + i;
    }
}

- (void)clickBtn:(UIButton *)btn{
    if (btn.tag == 100) {
        _moreBoarkBlock(1);
        
    }
    if (btn.tag == 101) {
        _moreBoarkBlock(2);
        return;

    }
    if (btn.tag == 102) {
        _moreBoarkBlock(3);
        return;

    }
    if (btn.tag == 103) {
        _moreBoarkBlock(4);
        return;

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
