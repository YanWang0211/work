//
//  MoreBoard.h
//  几里
//
//  Created by 泰山金融 on 2018/7/17.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MoreBoardBlock) (int type);

@interface MoreBoard : UIView

@property (nonatomic,copy) MoreBoardBlock  moreBoarkBlock;//

@end
