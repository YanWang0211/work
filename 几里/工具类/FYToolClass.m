//
//  FYToolClass.m
//  几里
//
//  Created by 泰山金融 on 2018/7/10.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import "FYToolClass.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import<MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CommonCrypto/CommonDigest.h>
@implementation FYToolClass

+ (BOOL)isBlankWithString:(NSString *)string{
    
    NSString *str = [NSString stringWithFormat:@"%@",string];
    
    if ([str isEqualToString:@""]) {
        return YES;
    }
    
    if ([str isEqualToString:@"<null>"]) {
        return YES;
    }
    
    if ([str isEqualToString:@"(null)"]) {
        return YES;
    }
    
    if ([str isEqualToString:@"<nil>"]) {
        return YES;
    }
    
    if (str == nil || str == NULL) {
        return YES;
    }
    
    if ([str isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([str isEqual:[NSNull null]]) {
        return YES;
    }
    
    if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }

    return NO;
}

+ (void)checkCameraWithSuperView:(UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate> *)superview{

    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.editing = NO;
    imagePicker.allowsEditing = NO;
    imagePicker.delegate = superview;
    imagePicker.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.videoQuality = UIImagePickerControllerQualityTypeMedium;

    AVAuthorizationStatus authStatus =  [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    //    AVAuthorizationStatusNotDetermined = 0 判断是否启用相册权限
    //    AVAuthorizationStatusRestricted,  受限制
    //    AVAuthorizationStatusDenied,       不允许
    //    AVAuthorizationStatusAuthorized  允许
    if(authStatus == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {

            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //第一次成功的操作
                    if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]) {
                        //            imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:imagePicker.sourceType];
                        [superview presentViewController:imagePicker animated:YES completion:nil];
                    }
                });
            }else{
                //第一次不允许的操作
            }
        }];
        
    }
    else if (authStatus == AVAuthorizationStatusAuthorized){
        //允许权限之后的操作
        if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]) {
//            imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:imagePicker.sourceType];
            [superview presentViewController:imagePicker animated:YES completion:nil];
        }
    
    }
    else if (authStatus == AVAuthorizationStatusDenied){
        //不允许权限之后的操作
        [FYAlertView showOneAlertWithDetail:@"请到设置中对相机授权"];

    }
    else if (authStatus == AVAuthorizationStatusRestricted){
        //系统受限制之后的操作
        [FYAlertView showOneAlertWithDetail:@"系统受限"];

    }
    
    
}

+ (void)checkPhotoWithSuperView:(UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate> *)superview{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//    imagePicker.editing = YES;
//    imagePicker.allowsEditing =   YES;
    imagePicker.delegate = superview;
    
    //PHAuthorizationStatusNotDetermined，未启用权限
    //PHAuthorizationStatusRestricted， 系统限制
    //PHAuthorizationStatusDenied，     不允许操作
    //PHAuthorizationStatusAuthorized， 允许操作
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if(status == PHAuthorizationStatusNotDetermined){
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    [superview presentViewController:imagePicker animated:YES completion:nil];
                    //第一次允许权限之后的操作
                });
            }else{
                //第一次不允许权限之后的操作
            }
        }];
        
    }
    else if (status == PHAuthorizationStatusAuthorized){
        //允许权限操作
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [superview presentViewController:imagePicker animated:YES completion:nil];
    }
    else if (status == PHAuthorizationStatusDenied){
        [FYAlertView showOneAlertWithDetail:@"请到设置中对相册授权"];
        //不允许权限操作
    }
    else if (status == PHAuthorizationStatusRestricted){
        //系统受限制操作
        [FYAlertView showOneAlertWithDetail:@"系统受限"];
    }
    
}

+ (void)checkVideoWithSuperView:(UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate> *)superview{

    ALAuthorizationStatus authorizationStatus = [ALAssetsLibrary authorizationStatus];
    // 如果没有获取访问授权，或者访问授权状态已经被明确禁止，则显示提示语，引导用户开启授权
    if (authorizationStatus == ALAuthorizationStatusRestricted || authorizationStatus == ALAuthorizationStatusDenied) {
        //系统受限制操作
        [FYAlertView showOneAlertWithDetail:@"系统受限"];
    }else if (authorizationStatus  == ALAuthorizationStatusAuthorized){
        //允许操作
        
    }else if (authorizationStatus == ALAuthorizationStatusNotDetermined){
        
    }
    
}
#pragma mark - 32位 小写
+(NSString *)MD5ForLower32Bate:(NSString *)str{
    
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    
    return digest;
}

#pragma mark - 32位 大写
+(NSString *)MD5ForUpper32Bate:(NSString *)str{
    
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02X", result[i]];
    }
    
    return digest;
}

#pragma mark - 16位 大写
+(NSString *)MD5ForUpper16Bate:(NSString *)str{
    
    NSString *md5Str = [self MD5ForUpper32Bate:str];
    
    NSString  *string;
    for (int i=0; i<24; i++) {
        string=[md5Str substringWithRange:NSMakeRange(8, 16)];
    }
    return string;
}


#pragma mark - 16位 小写
+(NSString *)MD5ForLower16Bate:(NSString *)str{
    
    NSString *md5Str = [self MD5ForLower32Bate:str];
    
    NSString  *string;
    for (int i=0; i<24; i++) {
        string=[md5Str substringWithRange:NSMakeRange(8, 16)];
    }
    return string;
}


@end
