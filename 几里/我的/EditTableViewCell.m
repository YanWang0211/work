//
//  EditTableViewCell.m
//  几里
//
//  Created by 泰山金融 on 2018/10/13.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import "EditTableViewCell.h"

@implementation EditTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

-(void)refreshCellWithTitle:(NSString *)name andIndex:(long)index andImage:(NSString *)url{

    _name.text = name;
    
    if (index == 0 || index == 1) {
        _imageV.hidden = NO;
    }else{
        _imageV.hidden = YES;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
