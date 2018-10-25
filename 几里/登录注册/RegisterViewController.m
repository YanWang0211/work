//
//  RegisterViewController.m
//  几里
//
//  Created by 泰山金融 on 2018/8/3.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import "RegisterViewController.h"
#import <BmobSDK/Bmob.h>
#import "GBEncodeTool.h"
#import <SMS_SDK/SMSSDK.h>
#import "NSString+AES256.h"
@interface RegisterViewController ()<UITextFieldDelegate>
@property (nonatomic,strong) UILabel * titleLabel;//
@property (nonatomic,strong) UITextField * codeTextField;//
@property (nonatomic,strong) UITextField * passWordField;//
@property (nonatomic,strong) UIButton * getCode;//忘记密码
@property (nonatomic,strong) UIButton * loginBtn;//完成btn
@property (nonatomic,strong) NSString * ID;//
@property (nonatomic,assign) int result;//结果
@property (nonatomic,strong) NSString * md5PassWord3;
@property (nonatomic,strong) NSString * md5PassWord5;

@property (nonatomic,strong) JMSGUser *user;
@end

@implementation RegisterViewController

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
    _titleLabel.text = self.titleStr;
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:_titleLabel];
    
    _codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(_titleLabel.frame), CGRectGetMaxY(_titleLabel.frame) + 10, kScreenW - 80, 30)];
    _codeTextField.font = [UIFont systemFontOfSize:17];
    _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    _codeTextField.delegate = self;
    _codeTextField.borderStyle = UITextBorderStyleNone;
    _codeTextField.placeholder = @"验证码";
    [self.view addSubview:_codeTextField];
    
    _getCode = [[UIButton alloc] init];
    [_getCode setTitleColor:kAppMainColor forState:UIControlStateNormal];
    [_getCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    _getCode.titleLabel.font = [UIFont systemFontOfSize:15];
    [_getCode addTarget:self action:@selector(getCodeBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_getCode];
    
    [_getCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.codeTextField.mas_right);
        make.centerY.mas_equalTo(self.codeTextField.mas_centerY);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    
    UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_codeTextField.frame), CGRectGetMaxY(_codeTextField.frame), _codeTextField.frame.size.width, 1)];
    [self.view addSubview:line];
    line.backgroundColor = [UIColor grayColor];
    
    _passWordField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(_titleLabel.frame), CGRectGetMaxY(line.frame) + 30, kScreenW - 80, 30)];
    _passWordField.font = [UIFont systemFontOfSize:17];
    _passWordField.keyboardType = UIKeyboardTypeNumberPad;
    _passWordField.delegate = self;
    _passWordField.borderStyle = UITextBorderStyleNone;
    _passWordField.placeholder = @"密码";
    [self.view addSubview:_passWordField];
    
    UILabel * line2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_passWordField.frame), CGRectGetMaxY(_passWordField.frame), _passWordField.frame.size.width, 1)];
    [self.view addSubview:line2];
    line2.backgroundColor = [UIColor grayColor];
    
    _loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(_passWordField.frame), CGRectGetMaxY(_passWordField.frame) + 20, _passWordField.frame.size.width, 40)];
    _loginBtn.layer.shadowOffset = CGSizeMake(5, 5);
    _loginBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    _loginBtn.layer.shadowOpacity =  0.8;
    [_loginBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _loginBtn.backgroundColor = kAppMainColor;
    [self.view addSubview:_loginBtn];
    [_loginBtn addTarget:self action:@selector(clickBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    
}


//先验证短信验证码
- (void)clickBtnEvent{
    
    //验证
    [SMSSDK commitVerificationCode:self.codeTextField.text phoneNumber:self.phoneNum zone:@"86" result:^(NSError *error) {
        
        if (!error)
        {
    
            NSLog(@"%@",@"验证成功，可执行用户请求的操作");
            if ([self.titleStr isEqualToString:@"注册"]) {
                
                [self resignUser];
                
            }else {
                
            }
        }
        else
        {
            NSLog(@"%@",error);
            [FYAlertView showOneAlertWithDetail:@"验证码输入错误"];
        }
    }];
    
}

- (void)resignUser{
    
    [STTextHudTool showWaitText:@"注册中..."];
    
    NSMutableString * time = [[self getNowTimeTimestamp3] mutableCopy];
    int msecTime = [[time substringWithRange:NSMakeRange(time.length- 3, 3)] intValue];
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"_User"];
    [bquery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            self.ID  = [NSString stringWithFormat:@"%d%d%d",number + 1,arc4random()%10,msecTime];
            [self startJMResign];
        }
    }];
}
- (void)startJMResign
{
    
    _md5PassWord3 = [GBEncodeTool getMd5_32Bit_String:self.passWordField.text isUppercase:NO];
    for (int i = 0; i < 2;  i++) {
        _md5PassWord3 = [GBEncodeTool getMd5_32Bit_String:_md5PassWord3 isUppercase:NO];
    };
    
    [JMSGUser registerWithUsername:self.ID password:_md5PassWord3 userInfo:nil completionHandler:^(id resultObject, NSError *error) {
        if (!error) {
            //注册成功
            [self startBobmResign];
            //JM登录
            [JMSGUser loginWithUsername:self.ID password:self.md5PassWord3 completionHandler:^(id resultObject, NSError *error) {
                if (!error) {
                    NSLog(@"Login Success ");
                    self.user = resultObject;
                    
                }else{
                    NSLog(@"Login Fail -> %@",error.description);
                }
            }];
        } else {
            //注册失败
             NSLog(@"极光注册失败 %@",error);
            [FYAlertView showOneAlertWithDetail:@"注册失败"];
            [STTextHudTool hideSTHud];
//            [STTextHudTool showErrorText:@"注册失败"];
            return ;
        }
    }];
}

- (void)startBobmResign{
    
    _md5PassWord5 = [GBEncodeTool getMd5_32Bit_String:[GBEncodeTool getMd5_32Bit_String:_md5PassWord3 isUppercase:NO] isUppercase:NO] ;
    
    BmobUser *bUser = [[BmobUser alloc] init];
    [bUser setUsername:self.ID];
    [bUser setPassword:_md5PassWord5];
    [bUser setObject:self.phoneNum forKey:@"mobilePhoneNumber"];
    [bUser signUpInBackgroundWithBlock:^ (BOOL isSuccessful, NSError *error){
        if (isSuccessful){
            NSLog(@"Sign up successfully");
            [STTextHudTool hideSTHud];
            [BmobUser loginWithUsernameInBackground:self.ID password:self.md5PassWord5];
            [FYAlertView showOneAlertWithDetail:@"注册成功"];
            
            [Config setUserUidWithValue:[NSString stringWithFormat:@"%lld",(self.user.uid)]];
            [Config setUserNameWithValue:self.user.username];
            [Config setUserIdWithValue:self.ID];
            [Config setPhoneNumWithValue:self.phoneNum];
            [Config setMD5_3WithValue:self.md5PassWord3];
            [Config setMD5_5WithValue:self.md5PassWord5];
            
            //在GameScore创建一条数据，如果当前没GameScore表，则会创建GameScore表
            BmobObject  *jimScore = [BmobObject objectWithClassName:@"Jim"];
            [jimScore setObject:self.ID forKey:@"id"];
            [jimScore setObject:[self.md5PassWord3 aes256_encrypt:AES_KEY] forKey:@"jimpass"];
            [jimScore saveInBackground];
            
            [self closeView];
            
        } else {
            NSLog(@"Bmob 注册失败%@",error);
            [STTextHudTool hideSTHud];
//            [STTextHudTool showErrorText:@"注册失败"];
            [FYAlertView showOneAlertWithDetail:@"注册失败"];
        }
    }];
}

- (NSString *)getNowTimeTimestamp3{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone systemTimeZone];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];//现在时间
    NSString *str = [formatter stringFromDate:datenow];
    return str;
}


//MARK:获取验证码
- (void)getCodeBtn{
    //请求验证码
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phoneNum zone:@"86"  result:^(NSError *error) {
        
        if (!error)
        {
            // 请求成功
            [FYAlertView showOneAlertWithDetail:@"验证码发送成功"];
            [self openCountdown];
        }
        else
        {
            // error
             NSLog(@"%@",error);
        }
    }];
   
}
// 开启倒计时效果
-(void)openCountdown{
    
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [self.getCode setTitle:@"重新发送" forState:UIControlStateNormal];
                [self.getCode setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                self.getCode.userInteractionEnabled = YES;
                dispatch_cancel(_timer);
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [self.getCode setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
                [self.getCode setTitleColor:[UIColor blackColor]  forState:UIControlStateNormal];
                self.getCode.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
    
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
