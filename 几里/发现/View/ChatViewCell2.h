//
//  ChatViewCell2.h
//  几里
//
//  Created by 泰山金融 on 2018/8/9.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessageModel.h"
@protocol ChatCell1Delegate2 <NSObject>

- (void)headImageClickEvent2:(ChatMessageModel *)model;

@end


@interface ChatViewCell2 : UITableViewCell
@property (nonatomic,weak) id<ChatCell1Delegate2>  delegate;//

- (void)refreshCellWithMessage:(ChatMessageModel *)message;

@end
