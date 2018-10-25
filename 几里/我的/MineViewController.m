//
//  MineViewController.m
//  几里
//
//  Created by 泰山金融 on 2018/7/9.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import "MineViewController.h"
#import <JMessage/JMessage.h>
#import "EditViewController.h"
@interface MineViewController ()
@property (nonatomic,strong) UIImageView * header;//touxiang
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JMSGUser *user =[JMSGUser myInfo];
    self.view.backgroundColor = kAppMainColor;
    [self setNavigation];
    [self setUI];
    
    // Do any additional setup after loading the view.
}
- (void)setNavigation{
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, StatusBarHeight - 37, 30, 30)];
    [backBtn setImage:[UIImage imageNamed:@"ic_back"] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(popToSupperView) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton * editBtn = [[UIButton alloc] initWithFrame:CGRectMake(screenW - 20 - 30, 20+7 , 40, 30)];
    [editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:editBtn];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(editInfoEvent) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)setUI{
    
    UIView * backview = [[UIView alloc] initWithFrame:CGRectMake(0, screenH - 200, screenW, 200 + 30)];
    backview.backgroundColor = [UIColor whiteColor];
    backview.layer.cornerRadius = 20;
    backview.layer.masksToBounds = YES;
    [self.view addSubview:backview];
    
    _header = [[UIImageView alloc] init];
    [_header sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"headImage_place"]];
    _header.layer.cornerRadius = 50;
    _header.layer.borderWidth = 1;
    _header.layer.borderColor = [UIColor whiteColor].CGColor;
    _header.layer.masksToBounds = YES;
    [self.view addSubview:_header];
    [_header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100);
        make.centerX.mas_equalTo(backview.mas_centerX);
        make.centerY.mas_equalTo(backview.mas_top);
    }];
    
    
    UILabel *nickname = [[UILabel alloc] init];
    nickname.text = @"昵称";
    nickname.textColor = [UIColor grayColor];
    nickname.font = [UIFont systemFontOfSize:14];
    [backview addSubview:nickname];
    [nickname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(20);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(60);
        make.centerY.mas_equalTo(backview.mas_centerY);
    }];
    
    UILabel *number = [[UILabel alloc] init];
    number.text = @"方圆号";
    number.textColor = [UIColor grayColor];
    number.font = [UIFont systemFontOfSize:14];
    [backview addSubview:number];
    
    [number mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nickname.mas_left);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(60);
        make.top.mas_equalTo(nickname.mas_bottom).offset(20);
    }];
   
    UILabel *number2 = [[UILabel alloc] init];
    number2.text = [Config getUserId];
    number2.textColor = [UIColor blackColor];
    number2.font = [UIFont systemFontOfSize:14];
    [backview addSubview:number2];
    
    [number2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(number.mas_right).offset(10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(100);
        make.top.mas_equalTo(number.mas_top);
    }];
}

- (void)editInfoEvent{
    
    EditViewController * vc = [[EditViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
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
