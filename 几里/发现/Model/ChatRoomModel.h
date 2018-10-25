//
//  ChatRoomModel.h
//  几里
//
//  Created by 泰山金融 on 2018/7/10.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatRoomModel : NSObject
@property (nonatomic,strong) NSString * roomID;//房间ID
@property (nonatomic,strong) NSString * name;//房间名称
@property (nonatomic,strong) NSString * desc;//描述
@property (nonatomic,strong) NSString * appkey;//
@property (nonatomic,strong) NSString * totalMemberCount;//人数
@property (nonatomic,strong) NSString * maxMemberCount;//最大人数
@property (nonatomic,strong) NSString * ctime;//创建时间

+ (ChatRoomModel *)createModelWithDic:(NSDictionary *)dic;

@end
