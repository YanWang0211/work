//
//  login2ViewController.m
//  几里
//
//  Created by 泰山金融 on 2018/8/3.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import "login2ViewController.h"
#import "RegisterViewController.h"
#import <BmobSDK/Bmob.h>
@interface login2ViewController ()<UITextFieldDelegate>
@property (nonatomic,strong) UILabel * titleLabel;//
@property (nonatomic,strong) UITextField * passwordTextField;//
@property (nonatomic,strong) UIButton * forgetBtn;//忘记密码
@property (nonatomic,strong) UIButton * loginBtn;//完成btn
@property (nonatomic,strong) JMSGUser *user;
@end

@implementation login2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createUI];
    // Do any additional setup after loading the view.
}
- (void)createUI{
    
    UIButton * closebtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 40, 20, 20)];
    [closebtn setImage:[UIImage imageNamed:@"login_close"] forState:UIControlStateNormal];
    closebtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [closebtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closebtn];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40,64 + 20, 100, 50)];
    _titleLabel.text = @"登录";
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:_titleLabel];
    
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(_titleLabel.frame), CGRectGetMaxY(_titleLabel.frame) + 10, kScreenW - 80, 30)];
    _passwordTextField.font = [UIFont systemFontOfSize:17];
//    _passwordTextField.keyboardType = UIKeyboardTypeNumberPad;
    _passwordTextField.secureTextEntry =  YES;
    _passwordTextField.delegate = self;
    _passwordTextField.borderStyle = UITextBorderStyleNone;
    _passwordTextField.placeholder = @"密码";
    [self.view addSubview:_passwordTextField];
    
    
    _forgetBtn = [[UIButton alloc] init];
    [_forgetBtn setTitleColor:kAppMainColor forState:UIControlStateNormal];
    [_forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    _forgetBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_forgetBtn addTarget:self action:@selector(forgetPassWordBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_forgetBtn];
    
    [_forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.passwordTextField.mas_right);
        make.centerY.mas_equalTo(self.passwordTextField.mas_centerY);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    
    UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_passwordTextField.frame), CGRectGetMaxY(_passwordTextField.frame), _passwordTextField.frame.size.width, 1)];
    [self.view addSubview:line];
    line.backgroundColor = [UIColor grayColor];
    
    
    _loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(_passwordTextField.frame), CGRectGetMaxY(_passwordTextField.frame) + 20, _passwordTextField.frame.size.width, 40)];
    _loginBtn.layer.shadowOffset = CGSizeMake(5, 5);
    _loginBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    _loginBtn.layer.shadowOpacity =  0.8;
    [_loginBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _loginBtn.backgroundColor = kAppMainColor;
    [self.view addSubview:_loginBtn];
    [_loginBtn addTarget:self action:@selector(loginEvent) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)loginEvent{
    [self.view endEditing:YES];
    
    [STTextHudTool showWaitText:@"正在登陆..."];
    
    NSString * passwordMD3 = [FYToolClass MD5ForLower32Bate:[FYToolClass MD5ForLower32Bate: [FYToolClass MD5ForLower32Bate:self.passwordTextField.text]]] ;

    [JMSGUser loginWithUsername:self.ID password:passwordMD3 completionHandler:^(id resultObject, NSError *error) {
        if (!error) {
            NSLog(@"Login Success ");
            self.user = resultObject;
            
            [JMSGChatRoom enterChatRoomWithRoomId:@"12580863" completionHandler:^(id resultObject, NSError *error) {
                if (!error) {
                    NSLog(@"成功加入聊天室");
                }else{
                    NSLog(@"%@",error);
                }
            }];
            
            NSString *passwordMD5 = [FYToolClass MD5ForLower32Bate:[FYToolClass MD5ForLower32Bate:passwordMD3]];
            
            [BmobUser loginWithUsernameInBackground:self.ID password:passwordMD5 block:^(BmobUser *user, NSError *error) {
                if (user) {
                    
                    NSDictionary * dataDic = [user valueForKey:@"dataDic"];

                    
                    [STTextHudTool hideSTHud];
                    [STTextHudTool showSuccessText:@"登录成功"];
                    [Config setUserNameWithValue:self.user.username];
                    [Config setUserUidWithValue:[NSString stringWithFormat:@"%lld",(self.user.uid)]];
                    [Config setUserIdWithValue:self.ID];
                    [Config setPhoneNumWithValue:self.phoneNum];
                    [Config setMD5_3WithValue:passwordMD3];
                    [Config setMD5_5WithValue:passwordMD5];
                    [Config setUserObjectIdWithValue:user.objectId];
                    
                    
                    //进入主界面
                    [APP_DELEGATE enterMainView];
                   
                } else {
                    [STTextHudTool hideSTHud];
                    [STTextHudTool showErrorText:@"登录失败"];
                }
            }];
           
        }else{
            
            [STTextHudTool hideSTHud];
           
            if (error.code == 801004) {
                 [FYAlertView showOneAlertWithDetail:@"密码错误"];
            }else{
                [STTextHudTool showErrorText:@"登录失败"];
            }
        }
    }];
}

- (void)forgetPassWordBtn{
    
    RegisterViewController * VC = [[RegisterViewController alloc] init];
    VC.titleStr = @"重置密码";
    [self presentViewController:VC animated:YES completion:nil];
}



- (void)closeView{
    [self dismissViewControllerAnimated:YES completion:nil];
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
