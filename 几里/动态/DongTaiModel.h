//
//  DongTaiModel.h
//  几里
//
//  Created by 泰山金融 on 2018/10/12.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/BmobObject.h>

@interface DongTaiModel : NSObject

@property (nonatomic,strong) NSString * objectId;//id

@property (nonatomic,strong) NSString * content;//n内容
@property (nonatomic,strong) NSString * imageUrl;//
@property (nonatomic,assign) CGPoint   point;//经纬度
@property (nonatomic,strong) NSString * address;
@property (nonatomic,strong) NSString * person;//关联的person  并设置权限  只供发布者可读写  其他人只读
@property (nonatomic,assign) long  liken;//喜欢的数量
@property (nonatomic,assign) long commentn;//评论数量
@property (nonatomic,assign) long report;//
@property (nonatomic,strong) NSString * updatedAtStr;//

@property (nonatomic,strong) NSString * userID;//
@property (nonatomic,strong) NSString * username;//
@property (nonatomic,strong) NSString * userheader;//
@property (nonatomic,assign) long       usersex;//
@property (nonatomic,strong) NSString * nicename;//
@property (nonatomic,strong) NSDate * createdAt;//
@property (nonatomic,strong) NSDate * updatedAt;//
@property (nonatomic,strong) NSString * className;//

+ (DongTaiModel *)createModelWithBmobObject:(BmobObject *)object;


@end
