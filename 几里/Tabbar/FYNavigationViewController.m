//
//  FYNavigationViewController.m
//  几里
//
//  Created by 泰山金融 on 2018/7/9.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import "FYNavigationViewController.h"

@interface FYNavigationViewController ()

@end

@implementation FYNavigationViewController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    if (self = [super initWithRootViewController:rootViewController])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarAppearance];
    // Do any additional setup after loading the view.
}
- (void)setNavigationBarAppearance
{
    [[UINavigationBar appearance] setBarTintColor:kAppMainColor];
    [[UINavigationBar appearance] setTranslucent:NO];
//    [[UINavigationBar appearance] setBackgroundImage:[FWUtils imageWithColor:kNavBarThemeColor]  forBarMetrics:UIBarMetricsDefault];
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];     // 设置item颜色
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:16];  // 统一设置item字体大小
    [UINavigationBar appearance].titleTextAttributes = textAttrs;
    
    
    self.navigationItem.backBarButtonItem  = [[UIBarButtonItem  alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationBar.tintColor = [UIColor blackColor];

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
