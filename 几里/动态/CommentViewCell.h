//
//  CommentViewCell.h
//  几里
//
//  Created by 泰山金融 on 2018/10/15.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@interface CommentViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImage;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *comment;

- (void)refreshCellWithModel:(CommentModel *)model;

@end
