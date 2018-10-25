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
    
    NSArray * titleArr = @[@"头像",@"背景",@"昵称",@"年龄",@"性别",@"地址"];
    
    self.navigationItem.title = [titleArr objectAtIndex:_sign];
    
    [self createUI];
    
    // Do any additional setup after loading the view.
}


- (void)createUI{
    
    _textfield = [[UITextField alloc] initWithFrame:CGRectMake(screenW * 0.1, 0, screenW * 0.8, 40)];
    _textfield.borderStyle = 3;
    [self.view addSubview:_textfield];
    
    
    
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
