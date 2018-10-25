//
//  EditTableViewCell.h
//  几里
//
//  Created by 泰山金融 on 2018/10/13.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UIImageView *imageV;


- (void)refreshCellWithTitle:(NSString * )name andIndex:(long)index andImage:(NSString *)url;

@end
