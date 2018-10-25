//
//  CommentModel.h
//  几里
//
//  Created by 泰山金融 on 2018/10/15.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/BmobObject.h>

@interface CommentModel : NSObject
@property (nonatomic,strong) NSString * objectId;
@property (nonatomic,strong) NSString * userObjectId;
@property (nonatomic,strong) NSString * parentpID;

@property (nonatomic,strong) NSString * comment;


+ (CommentModel *)createModelWithBombObject:(BmobObject *)object;

@end
