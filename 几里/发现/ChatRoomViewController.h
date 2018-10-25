//
//  ChatRoomViewController.h
//  几里
//
//  Created by 王岩 on 2018/7/10.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatRoomModel.h"

typedef void (^showMenuBlock)(void);

@interface ChatRoomViewController : UIViewController

@property(nonatomic,strong) ChatRoomModel * chatRoomModel;

@property (nonatomic,copy) showMenuBlock block;

@end
