//
//  CommentModel.m
//  几里
//
//  Created by 泰山金融 on 2018/10/15.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

+ (CommentModel *)createModelWithBombObject:(BmobObject *)object{
    
    CommentModel * model = [[CommentModel alloc] init];
    model.objectId = object.objectId;
    
    NSDictionary * dataDic = [object valueForKey:@"dataDic"];
    model.comment = [dataDic valueForKey:@"content"];
    model.userObjectId = [[dataDic valueForKey:@"person"] valueForKey:@"objectId"];
 
    return model;
}

@end
