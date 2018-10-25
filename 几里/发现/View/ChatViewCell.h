//
//  ChatViewCell.h
//  几里
//
//  Created by 泰山金融 on 2018/7/11.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessageModel.h"

@protocol ChatCell1Delegate <NSObject>

- (void)headImageClickEvent:(ChatMessageModel *)model;

@end



@interface ChatViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView * stateImage;//发送状态动画

@property (nonatomic,weak) id<ChatCell1Delegate>  delegate;//

- (void)refreshCellWithMessage:(ChatMessageModel *)message;

@end
