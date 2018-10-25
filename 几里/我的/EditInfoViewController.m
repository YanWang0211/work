//
//  EditInfoViewController.m
//  几里
//
//  Created by 泰山金融 on 2018/10/25.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import "EditInfoViewController.h"

@interface EditInfoViewController ()
@property (nonatomic,strong) UITextField * textfield;

@end

@implementation EditInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray * titleArr = @[@"更改头像",@"更改背景",@"更改昵称",@"更改年龄",@"更改性别",@"更改地址"];
    
    self.navigationItem.title = [titleArr objectAtIndex:_sign];
    
    [self createUI];
    
    // Do any additional setup after loading the view.
}


- (void)createUI{
    
    _textfield = [[UITextField alloc] initWithFrame:CGRectMake(screenW * 0.1, 0, screenW * 0.8, 40)];
    _textfield.borderStyle = 3;
    [self.view addSubview:_textfield];
    
    
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
