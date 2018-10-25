//
//  FYToolClass.h
//  几里
//
//  Created by 泰山金融 on 2018/7/10.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FYToolClass : NSObject


//字符串空判断
+ (BOOL)isBlankWithString:(NSString *)string;

+ (void)checkCameraWithSuperView:(UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate> *)superview ;

+ (void)checkPhotoWithSuperView:(UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate> *)superview;

+ (void)checkVideoWithSuperView:(UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate> *)superview;

// 32位小写
+(NSString *)MD5ForLower32Bate:(NSString *)str;
// 32位大写
+(NSString *)MD5ForUpper32Bate:(NSString *)str;
// 16为大写
+(NSString *)MD5ForUpper16Bate:(NSString *)str;
// 16位小写
+(NSString *)MD5ForLower16Bate:(NSString *)str;

@end
