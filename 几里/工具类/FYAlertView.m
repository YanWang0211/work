//
//  FYAlertView.m
//  几里
//
//  Created by 泰山金融 on 2018/7/10.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import "FYAlertView.h"
#import <MMAlertView.h>
#import <MMPopupItem.h>
@implementation FYAlertView

+(void)showOneAlertWithDetail:(NSString *)detail{
    
    MMAlertView *alert = [[MMAlertView alloc] initWithTitle:@"温馨提示" detail:detail items:@[MMItemMake(@"退下吧!", MMItemTypeNormal, ^(NSInteger index) {
        
    })]];

    [alert show];
    
}

+(void)showTwoAlertWithDetail:(NSString *)detail andEvent:(FYAlertEvent)event{
    
    MMAlertView *alert = [[MMAlertView alloc] initWithTitle:@"温馨提示" detail:detail items:@[MMItemMake(@"确定", MMItemTypeNormal, ^(NSInteger index) {
             event();
    }),MMItemMake(@"取消", MMItemTypeNormal, ^(NSInteger index) {
        
    })]];
    
    [alert show];
}
    

@end
