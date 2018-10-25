//
//  LoginViewController.m
//  几里
//
//  Created by 泰山金融 on 2018/7/9.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "login2ViewController.h"
#import "RegisterViewController.h"
#import <BmobSDK/Bmob.h>
#import "GBEncodeTool.h"

#import "NSString+AES256.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property (nonatomic,strong) UILabel * titleLabel;//登录 注册
@property (nonatomic,strong) UITextField * phoneNum;//账号输入框

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KAppBackViewColor;
    // Do any additional setup after loading the view.
    
    [self setUI];

}

- (void)setUI{

    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40,64 + 20, 100, 50)];
    _titleLabel.text = @"登录/注册";
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:_titleLabel];
    
    _phoneNum = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(_titleLabel.frame), CGRectGetMaxY(_titleLabel.frame) + 10, kScreenW - 80, 30)];
    _phoneNum.font = [UIFont systemFontOfSize:17];
    _phoneNum.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneNum.keyboardType = UIKeyboardTypeNumberPad;
    _phoneNum.delegate = self;
    _phoneNum.borderStyle = UITextBorderStyleNone;
    _phoneNum.placeholder = @"手机号";
    [self.view addSubview:_phoneNum];
    
    UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_phoneNum.frame), CGRectGetMaxY(_phoneNum.frame), _phoneNum.frame.size.width, 1)];
    [self.view addSubview:line];
    line.backgroundColor = [UIColor grayColor];
    
    UIButton * nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(_phoneNum.frame), CGRectGetMaxY(line.frame) + 30, line.frame.size.width, 40)];
    nextBtn.layer.shadowOffset = CGSizeMake(5, 5);
    nextBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    nextBtn.layer.shadowOpacity =  0.8;
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    nextBtn.backgroundColor = kAppMainColor;;
    [nextBtn addTarget:self action:@selector(nextBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
}

- (void)nextBtnEvent{
    
    [self.view endEditing:YES];
    
    [STTextHudTool  loading];
    BmobQuery *query = [BmobUser query];
    [query whereKey:@"mobilePhoneNumber" equalTo:self.phoneNum.text];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [STTextHudTool hideSTHud];
            if (array.count) {
                BmobUser *user = [array firstObject];
                login2ViewController * login = [[login2ViewController alloc] init];
                login.phoneNum = self.phoneNum.text;
                login.ID = user.username;
                [self presentViewController:login animated:YES completion:nil];
            }else{
                RegisterViewController * login = [[RegisterViewController alloc] init];
                login.titleStr = @"注册";
                login.phoneNum = self.phoneNum.text;
                [self presentViewController:login animated:YES completion:nil];
            }
        
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    if (textField == self.phoneNum) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else if (self.phoneNum.text.length >= 11) {
            self.phoneNum.text = [textField.text substringToIndex:11];
            
            return NO;
        }
    }
    return YES;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_phoneNum resignFirstResponder];
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
