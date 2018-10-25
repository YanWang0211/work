//
//  CommentViewCell.m
//  几里
//
//  Created by 泰山金融 on 2018/10/15.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import "CommentViewCell.h"
#import <BmobSDK/Bmob.h>

@implementation CommentViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _headerImage.layer.cornerRadius = 20;
    _headerImage.layer.masksToBounds = YES;
    // Initialization code
}

- (void)refreshCellWithModel:(CommentModel *)model{
    
    self.comment.text = model.comment;
    

    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"_User"];
    [bquery getObjectInBackgroundWithId:model.userObjectId block:^(BmobObject *object,NSError *error){
        if (error){
            //进行错误处理
        }else{
            //表里有id为0c6db13c的数据
            if (object) {
                
                if ([object objectForKey:@"nicename"]) {
                    self.name.text = [object objectForKey:@"nicename"];
                }else{
                    self.name.text = [object objectForKey:@"username"];
                }

                [self.headerImage sd_setImageWithURL:[ NSURL URLWithString:[[object objectForKey:@"photo"] valueForKey:@"url"]]];
              
            }
            }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
