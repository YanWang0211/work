//
//  Config.m
//  几里
//
//  Created by 泰山金融 on 2018/7/12.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import "Config.h"



@implementation Config
//ID
+ (void)setUserIdWithValue:(NSString *)value{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:USER_ID];
    [defaults synchronize];
}
+ (NSString *)getUserId{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:USER_ID];
}

+ (void)setUserUidWithValue:(NSString *)value{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:USER_UID];
    [defaults synchronize];
}

+ (NSString *)getUserUid{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:USER_UID];
}

//账户名称
+ (void)setUserNameWithValue:(NSString *)value{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:USER_NAME];
    [defaults synchronize];
}
+ (NSString *)getUserName{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:USER_NAME];
}
//昵称
+ (void)setNickNameWithValue:(NSString *)value{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:NICK_NAME];
    [defaults synchronize];
}
+ (NSString *)getNickName{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:NICK_NAME];
}
//头像
+ (void)setAvatarWithValue:(NSString *)value{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:NICK_AVATAR];
    [defaults synchronize];
}
+ (NSString *)getAvatar{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:NICK_AVATAR];
}
//性别
+ (void)setGenderWithValue:(NSString *)value{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:NICK_GENDER];
    [defaults synchronize];
}
+ (NSString *)getGender{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:NICK_GENDER];
}
//生日
+ (void)setBirthdayWithValue:(NSString *)value{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:BIRTHDAY];
    [defaults synchronize];
}
+ (NSString *)getBirthday{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:BIRTHDAY];
}
//地区
+ (void)setGegionWithValue:(NSString *)value{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:REGION];
    [defaults synchronize];
}
+ (NSString *)getGegion{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:REGION];
}
//签名
+ (void)setSignatureWithValue:(NSString *)value{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:GIGNATURE];
    [defaults synchronize];
}
+ (NSString *)getSignature{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:GIGNATURE];
}
//地址
+ (void)setAddressWithValue:(NSString *)value{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:ADDRESS];
    [defaults synchronize];
}
+ (NSString *)getAddress{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:ADDRESS];
}

//手机号
+ (void)setPhoneNumWithValue:(NSString *)value{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:PHONE_NUM];
    [defaults synchronize];
}
+ (NSString *)getPhoneNum{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:PHONE_NUM];
}
//MD5 3次密码
+ (void)setMD5_3WithValue:(NSString *)value{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:PASSWORD3];
    [defaults synchronize];
}
+ (NSString *)getMD5_3{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:PASSWORD3];
}
//MD5 5次密码
+ (void)setMD5_5WithValue:(NSString *)value{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:PASSWORD5];
    [defaults synchronize];
}
+ (NSString *)getMD5_5{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:PASSWORD5];
}
//ID
+ (void)setUserObjectIdWithValue:(NSString *)value{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:OBJECTID];
    [defaults synchronize];
}
+ (NSString *)getUserObjectID{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:OBJECTID];
}

+ (void)cleanUserInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:USER_ID    ];
    [defaults setObject:nil forKey:USER_UID   ];
    [defaults setObject:nil forKey:USER_NAME  ];
    [defaults setObject:nil forKey:NICK_NAME  ];
    [defaults setObject:nil forKey:NICK_AVATAR];
    [defaults setObject:nil forKey:NICK_GENDER];
    [defaults setObject:nil forKey:BIRTHDAY   ];
    [defaults setObject:nil forKey:REGION     ];
    [defaults setObject:nil forKey:GIGNATURE  ];
    [defaults setObject:nil forKey:ADDRESS    ];
    [defaults setObject:nil forKey:NOTE_NAME  ];
    [defaults setObject:nil forKey:PHONE_NUM  ];
    [defaults setObject:nil forKey:PASSWORD3  ];
    [defaults setObject:nil forKey:PASSWORD5  ];
    [defaults setObject:nil forKey:OBJECTID  ];

    [defaults synchronize];
}

@end
