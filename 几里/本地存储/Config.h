//
//  Config.h
//  几里
//
//  Created by 泰山金融 on 2018/7/12.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JMessage/JMessage.h>
#define USER_ID      @"ID"//极光  bomb的 注册名称
#define USER_UID     @"uid"
#define USER_NAME    @"username"
#define NICK_NAME    @"nickname"
#define NICK_AVATAR  @"avatar"//头像
#define NICK_GENDER  @"gender"//性别
#define BIRTHDAY     @"birthday"
#define REGION       @"region"
#define GIGNATURE    @"signature"
#define ADDRESS      @"address"
#define NOTE_NAME    @"noteName"
#define PHONE_NUM    @"phoneNum"
#define PASSWORD3    @"password3"
#define PASSWORD5    @"password5"
#define OBJECTID     @"objectid"

@interface Config : NSObject

//ID
+ (void)setUserIdWithValue:(NSString *)value;
+ (NSString *)getUserId;

//用户uid
+ (void)setUserUidWithValue:(NSString *)value;
+ (NSString *)getUserUid;
//账户名称
+ (void)setUserNameWithValue:(NSString *)value;
+ (NSString *)getUserName;
//昵称
+ (void)setNickNameWithValue:(NSString *)value;
+ (NSString *)getNickName;
//头像
+ (void)setAvatarWithValue:(NSString *)value;
+ (NSString *)getAvatar;
//性别
+ (void)setGenderWithValue:(NSString *)value;
+ (NSString *)getGender;
//生日
+ (void)setBirthdayWithValue:(NSString *)value;
+ (NSString *)getBirthday;
//地区
+ (void)setGegionWithValue:(NSString *)value;
+ (NSString *)getGegion;
//签名
+ (void)setSignatureWithValue:(NSString *)value;
+ (NSString *)getSignature;
//地址
+ (void)setAddressWithValue:(NSString *)value;
+ (NSString *)getAddress;
//备注名
+ (void)setNoteNameWithValue:(NSString *)value;
+ (NSString *)getNoteName;

//手机号
+ (void)setPhoneNumWithValue:(NSString *)value;
+ (NSString *)getPhoneNum;
//MD5 3次密码
+ (void)setMD5_3WithValue:(NSString *)value;
+ (NSString *)getMD5_3;
//MD5 5次密码
+ (void)setMD5_5WithValue:(NSString *)value;
+ (NSString *)getMD5_5;
//ID
+ (void)setUserObjectIdWithValue:(NSString *)value;
+ (NSString *)getUserObjectID;
//退出登录 清除用户信息
+ (void)cleanUserInfo;

@end
