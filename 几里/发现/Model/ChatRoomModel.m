//
//  ChatRoomModel.m
//  几里
//
//  Created by 泰山金融 on 2018/7/10.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import "ChatRoomModel.h"

@implementation ChatRoomModel

+ (ChatRoomModel *)createModelWithDic:(NSDictionary *)dic{
    
    ChatRoomModel *model = [[ChatRoomModel alloc] init];
    
    model.ctime = kToString([dic valueForKey:@"ctime"]);
    model.name = kToString([dic valueForKey:@"name"]);
    model.totalMemberCount = kToString([dic valueForKey:@"totalMemberCount"]);
    model.maxMemberCount = kToString([dic valueForKey:@"maxMemberCount"]);
    model.desc = kToString([dic valueForKey:@"desc"]);
    model.roomID = kToString([dic valueForKey:@"roomID"]);
//    model.appkey = [NSString stringWithFormat:@"%@",[dic objectForKey:@"appkey"]];

    return model;
    
}

@end

