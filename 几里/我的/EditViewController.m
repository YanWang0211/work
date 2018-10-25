//
//  EditViewController.m
//  几里
//
//  Created by 泰山金融 on 2018/10/13.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import "EditViewController.h"
#import "EditTableViewCell.h"
#import "EditInfoViewController.h"
@interface EditViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * tableView;//
@property (nonatomic,strong) NSArray * dataArr;
@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title  = @"编辑";
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    [self createNavigationBar];
    _dataArr = @[@"头像",@"背景",@"昵称",@"年龄",@"性别",@"地址"];
    [self createUI];
    // Do any additional setup after loading the view.
}

- (void)createNavigationBar{
    
    UIView * navigation = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenW, StatusBarHeight)];
    navigation.backgroundColor = kAppMainColor;
    [self.view addSubview:navigation];
    
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, StatusBarHeight - 37, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    [navigation addSubview:backBtn];
    [backBtn addTarget:self action:@selector(popToSupperView) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    label.text = @"编辑";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.center = CGPointMake(screenW/2, StatusBarHeight - 20);
    [navigation addSubview:label];
    
}
- (void)popToSupperView{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)createUI{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, StatusBarHeight, screenW, 350) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    [_tableView registerNib:[UINib nibWithNibName:@"EditTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EditTableViewCell  * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (indexPath.row == 0 || indexPath.row == 1) {
        
        [cell refreshCellWithTitle:_dataArr[indexPath.row] andIndex:indexPath.row andImage:nil];
        
    }else{
        
        [cell refreshCellWithTitle:_dataArr[indexPath.row] andIndex:indexPath.row andImage:nil];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 || indexPath.row == 1) {
        return 70;
    }else{
        return 50;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EditInfoViewController * vc = [[EditInfoViewController alloc] init];
    vc.sign = indexPath.row;
    [self.navigationController pushViewController:vc animated:YES];
    
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
