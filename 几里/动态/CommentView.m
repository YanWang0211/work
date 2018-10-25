//
//  CommentView.m
//  几里
//
//  Created by 泰山金融 on 2018/10/15.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import "CommentView.h"
#import "CommentViewCell.h"
#import <BmobSDK/Bmob.h>

@interface CommentView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableview;
@property (nonatomic,strong) NSMutableArray * dataArr;
@end


@implementation CommentView

- (instancetype)initWithFrame:(CGRect)frame andObjectId:(NSString *)objectId andCreatedAt:(NSDate *)createat andUpdatedAt:(NSDate *)updatedat{
    if (self = [super initWithFrame:frame]) {
       self.objectId = objectId;
       self.createdAt = createat;
       self.updatedAt = updatedat;
        [self setUI];
        [self loadData];
    }
    return self;
}


- (void)setUI{
    
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, screenW, self.frame.size.height -  50) style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    [self addSubview:_tableview];
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableview registerNib:[UINib nibWithNibName:@"CommentViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
}

- (void)loadData{
    
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Comment"];
    BmobObject * object = [[BmobObject alloc] init];
    object.objectId = self.objectId;
    object.createdAt = self.createdAt;
    object.updatedAt = self.updatedAt;
    object.className = @"Dynamic";
    [bquery whereKey:@"dynamic" equalTo:object];
    //查找GameScore表的数据
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
            
        }else{
            if (array.count) {
                
                for (BmobObject *obj in array) {
                    CommentModel  * model = [CommentModel createModelWithBombObject:obj];
                    [self.dataArr addObject:model];
                }
                
                [self.tableview reloadData];
                
            }else{
//                [STTextHudTool showErrorText:@"已经加载全部数据"];
            }
            
        }
        
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CommentModel * model = [self.dataArr objectAtIndex:indexPath.row];

    CGSize size = [model.comment boundingRectWithSize:CGSizeMake(screenW - 70, CGFLOAT_MIN) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{} context:nil].size;
    
    return size.height + 45;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    CommentModel * model = [self.dataArr objectAtIndex:indexPath.row];
    
    [cell refreshCellWithModel:model];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.dataArr.count;
    
}

- (NSMutableArray *)dataArr{
    
    if (!_dataArr) {
        _dataArr    = [[NSMutableArray alloc] init];
    }
    return _dataArr;
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
