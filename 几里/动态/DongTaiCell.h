//
//  DongTaiCell.h
//  几里
//
//  Created by 泰山金融 on 2018/10/12.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DongTaiModel.h"

@protocol DongTaiCellDelegate <NSObject>

- (void)commentEvent:(DongTaiModel *)model;

- (void)reportEvent:(NSString *)objectId;

@end


@interface DongTaiCell : UITableViewCell

@property (nonatomic,weak) id<DongTaiCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *header;

@property (weak, nonatomic) IBOutlet UIImageView *VIP;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *sex;

@property (weak, nonatomic) IBOutlet UIImageView *contentImage;

@property (weak, nonatomic) IBOutlet UILabel *content;

@property (weak, nonatomic) IBOutlet UILabel *bottonLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *VIPWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;

- (void)refreshCellWithModel:(DongTaiModel *)model;


@end
