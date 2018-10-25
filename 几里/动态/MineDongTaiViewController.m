//
//  MineDongTaiViewController.m
//  几里
//
//  Created by 泰山金融 on 2018/10/13.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import "MineDongTaiViewController.h"
#import <BmobSDK/Bmob.h>
#import "DongTaiModel.h"
#import "DongTaiCell.h"
@interface MineDongTaiViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * tableview;
@property (nonatomic,assign) long  page;
@property (nonatomic,strong) NSMutableArray * dataArr;

@end

@implementation MineDongTaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 0;
    [self createNavigationBar];
    [self  createUI];
    [self loadData];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}
- (void)createUI{
    
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, StatusBarHeight, screenW, screenH - StatusBarHeight) style:UITableViewStylePlain];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.rowHeight = UITableViewAutomaticDimension;
    [_tableview registerNib:[UINib nibWithNibName:@"DongTaiCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableview];
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
    [bquery whereKey:@"person" equalTo:[Config getUserObjectID]];

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


- (void)createNavigationBar{
    
    UIView * navigation = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenW, StatusBarHeight)];
    navigation.backgroundColor = kAppMainColor;
    [self.view addSubview:navigation];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, StatusBarHeight - 37, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    [navigation addSubview:backBtn];
    [backBtn addTarget:self action:@selector(popToSupperView) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    label.text = @"我的动态";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.center = CGPointMake(screenW/2, StatusBarHeight - 20);
    [navigation addSubview:label];
    
}
- (void)popToSupperView{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
