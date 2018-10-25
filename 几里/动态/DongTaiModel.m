//
//  DongTaiModel.m
//  几里
//
//  Created by 泰山金融 on 2018/10/12.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import "DongTaiModel.h"

@implementation DongTaiModel


+(DongTaiModel *)createModelWithBmobObject:(BmobObject *)object{
    
    DongTaiModel * model = [[DongTaiModel alloc] init];
    
    model.objectId = object.objectId;
    model.createdAt =  object.createdAt;
    model.updatedAt = object.updatedAt;
    model.className = model.className;

    NSDictionary * dataDic = [object valueForKey:@"dataDic"];
    model.content = [dataDic valueForKey:@"content"];
    model.address = [dataDic valueForKey:@"address"];
    model.updatedAtStr  = [dataDic valueForKey:@"updatedAt"];
    model.point = CGPointMake([[[dataDic valueForKey:@"point"] valueForKey:@"longitude"] doubleValue], [[[dataDic valueForKey:@"point"] valueForKey:@"latitude"] doubleValue]);
    if ([dataDic objectForKey:@"image"]) {
        model.imageUrl = [[dataDic valueForKey:@"image"] valueForKey:@"url"];
    }
    if ([dataDic objectForKey:@"person"]) {
        model.person = [[dataDic valueForKey:@"person"] valueForKey:@"objectId"];
    }
    if ([dataDic objectForKey:@"commentn"]) {
        model.commentn = [[dataDic valueForKey:@"commentn"] longValue];
    }else{
        model.commentn = 0;
    }
    if ([dataDic objectForKey:@"report"]) {
        model.commentn = [[dataDic valueForKey:@"report"] longValue];
    }
    
    if ([dataDic objectForKey:@"person"]) {
        model.userID = [[dataDic valueForKey:@"person"] valueForKey:@"objectId"];
        model.username = [[dataDic valueForKey:@"person"] valueForKey:@"username"];
        model.usersex = [[[dataDic valueForKey:@"person"] valueForKey:@"sex"] longValue];
        model.nicename = [[dataDic valueForKey:@"person"] valueForKey:@"nicename"];
        model.userheader = [[[dataDic valueForKey:@"person"] valueForKey:@"photo"] valueForKey:@"url"];

    }
    
    
    return model;
}

@end
