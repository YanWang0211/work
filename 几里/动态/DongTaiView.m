//
//  DongTaiView.m
//  几里
//
//  Created by 泰山金融 on 2018/10/12.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import "DongTaiView.h"
#import <BmobSDK/Bmob.h>
#import "DongTaiModel.h"
#import "DongTaiCell.h"
#import "CommentView.h"
@interface DongTaiView ()<UITableViewDelegate,UITableViewDataSource,DongTaiCellDelegate>
@property (nonatomic,strong) UITableView * tableview;
@property (nonatomic,assign) long  page;
@property (nonatomic,strong) NSMutableArray * dataArr;
@property (nonatomic,strong) NSString * objectId;
@property (nonatomic,strong) CommentView * commentV;

@property (nonatomic,strong) UIButton  * mengban;

@end
@implementation DongTaiView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        _page = 0;
        [self  createUI];
        [self loadData];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)createUI{
    
    _tableview = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.rowHeight = UITableViewAutomaticDimension;
    [_tableview registerNib:[UINib nibWithNibName:@"DongTaiCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self addSubview:_tableview];
    _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 0;
        [self.dataArr removeAllObjects];
        [self loadData];
    }];
    
    _tableview.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
         [self loadData];
    }];
}

- (void)loadData{
    
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Dynamic"];
    [bquery includeKey:@"person"];
    bquery.skip = self.page;
    [bquery setLimit:15];
    //查找GameScore表的数据
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (error) {
           
        }else{
            if (array.count) {
                self.page += array.count;
                for (BmobObject *obj in array) {
                    //打印playerName
                    DongTaiModel * model = [DongTaiModel createModelWithBmobObject:obj];
                    [self.dataArr addObject:model];
                }
                
                [self.tableview reloadData];
            
            }else{
                [STTextHudTool showErrorText:@"已经加载全部数据"];
            }
            
        }
        
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DongTaiCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.delegate = self;
    DongTaiModel * model = [self.dataArr objectAtIndex:indexPath.row];
    [cell refreshCellWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height =  90;
    
    DongTaiModel * model = [self.dataArr objectAtIndex:indexPath.row];

    if (model.imageUrl) {
        height += 120;
    }
    
    if (model.content) {
        CGSize size = [model.content boundingRectWithSize:CGSizeMake(screenW - 85, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size;
        height += size.height + 10;
    }
    
    return height;
}

- (NSMutableArray *)dataArr{

    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    
    return _dataArr;
}


- (void)commentEvent:(DongTaiModel  *)model{
    if (!_mengban) {
        _mengban = [[UIButton alloc] initWithFrame:self.bounds];
        _mengban.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [self addSubview:_mengban];
        [_mengban addTarget:self action:@selector(closeSomeView) forControlEvents:UIControlEventTouchUpInside];
        
    }
   
    if (!_commentV) {
        
        _commentV = [[CommentView alloc] initWithFrame:CGRectMake(0, screenH, screenW, screenH * 0.6) andObjectId:model.objectId andCreatedAt:model.createdAt andUpdatedAt:model.updatedAt];

        [self addSubview:_commentV];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.commentV.frame = CGRectMake(0, screenH * 0.4, screenW, screenH * 0.6);
        }];
    }
    
}

- (void)reportEvent:(NSString *)objectId{
    
    
    
}

- (void)closeSomeView{
    
    [_mengban removeFromSuperview];
    _mengban = nil;
    if (_commentV) {
        [_commentV removeFromSuperview];
        _commentV = nil;
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
