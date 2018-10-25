//
//  FYAlertView.h
//  几里
//
//  Created by 泰山金融 on 2018/7/10.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^FYAlertEvent)();


@interface FYAlertView : NSObject

+(void)showOneAlertWithDetail:(NSString *)detail;

+(void)showTwoAlertWithDetail:(NSString *)detail andEvent:(FYAlertEvent)event;


@end
