//
//  DongTaiCell.m
//  几里
//
//  Created by 泰山金融 on 2018/10/12.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import "DongTaiCell.h"
#import <BmobSDK/Bmob.h>
@interface DongTaiCell ()
{
    float nameW,VIPW,contentH,imageW,imageH;
}

@property (nonatomic,strong) NSString * objectId;//id
@property (nonatomic,strong) DongTaiModel * model;

@end

@implementation DongTaiCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _VIP.contentMode  = UIViewContentModeScaleAspectFill;
    _contentImage.contentMode  = UIViewContentModeScaleAspectFill;
    _header.layer.cornerRadius = 17.5;
    _header.layer.masksToBounds = YES;
    _contentImage.layer.cornerRadius = 6;
    // Initialization code
}

- (void)refreshCellWithModel:(DongTaiModel *)model{
    _objectId = model.objectId;
    _model = model;
    NSURL * url = [NSURL URLWithString:model.userheader];
    [_header sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"logo"]];
    
  
    
    
    if (model.usersex == 1) {
        _sex.image = [UIImage imageNamed:@"ic_boy1"];
    }else if (model.usersex == 2){
         _sex.image = [UIImage imageNamed:@"ic_girl1"];
    }else{
         _sex.image = [UIImage imageNamed:@""];
    }
    
    _name.text = model.nicename?model.nicename:model.username;
    CGSize size = [_name.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size;
    nameW = size.width + 5;
    if (model.content) {
        _content.text = model.content;
         CGSize size1 = [_content.text boundingRectWithSize:CGSizeMake(screenW - 85, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size;
        contentH = size1.height + 5;
    }else{
        contentH = 0.1;
        _content.text = nil;
    }
    
    if (model.imageUrl) {
        [_contentImage sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image){
                self.contentImage.image = image;
                self->imageH = 120;
                self->imageW = image.size.width/image.size.height * self->imageH;
                [self layoutSubviews];
            }else{
                //something went wrong
            }
            
        }];
    }else{
        imageH = 0.1;
        _contentImage.image = nil;
    }
    
    
    [_commentBtn setTitle:[NSString stringWithFormat:@"%ld",model.commentn] forState:UIControlStateNormal];
    
    [self layoutSubviews];
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    self.nameWidth.constant = nameW;
    self.contentHeight.constant = contentH;
    self.imageHeight.constant = imageH;
    self.imageWidth.constant = imageW;
}

- (IBAction)moreBtnEvent:(id)sender {
    
    [self.delegate reportEvent:_objectId];
    
}

- (IBAction)commentBtnEvent:(id)sender {
    
    [self.delegate commentEvent:_model];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
