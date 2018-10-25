//
//  LeftTableViewCell.m
//  几里
//
//  Created by 泰山金融 on 2018/10/12.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import "LeftTableViewCell.h"

@implementation LeftTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Initialization code
}


- (void)refreshCellWithImage:(NSString *)iamgeName andTitle:(NSString *)name{
    
    _imageV.image = [UIImage imageNamed:iamgeName];
    _name.text = name;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
