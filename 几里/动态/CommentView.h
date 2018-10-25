//
//  CommentView.h
//  几里
//
//  Created by 泰山金融 on 2018/10/15.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentView : UIView

- (instancetype)initWithFrame:(CGRect)frame andObjectId:(NSString *)objectId andCreatedAt:(NSDate *)createat andUpdatedAt:(NSDate *)updatedat;

@property (nonatomic,strong) NSString * objectId;
@property (nonatomic,strong) NSDate * createdAt;//
@property (nonatomic,strong) NSDate * updatedAt;//

@end
