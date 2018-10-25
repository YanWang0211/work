//
//  FYTabbarViewController.m
//  几里
//
//  Created by 泰山金融 on 2018/7/9.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import "FYTabbarViewController.h"
#import "FYTabbar.h"
#import "FYNavigationViewController.h"
#import "MyFriendViewController.h"
#import "DiscoveryViewController.h"
#import "MineViewController.h"

@interface FYTabbarViewController ()<UITabBarControllerDelegate>
@property (nonatomic,assign) NSInteger * indexFlag;
@end

@implementation FYTabbarViewController

FYSingletonM(instance);

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [self setUpChildViewControllers];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setTranslucent:NO];
    
    FYTabbar * tabBar = [[FYTabbar alloc] init];
    [self setValue:tabBar forKey:@"tabBar"];
    
    // Do any additional setup after loading the view.
}
#pragma mark - 设置子控制器
- (void)setUpChildViewControllers
{

    // 好友
    [self addChildViewController:[[MyFriendViewController alloc] init] image:@"ic_live_tab_live_selected" seletedImage:@"ic_live_tab_live_normal" title:@"好友"];
    // 发现
    [self addChildViewController:[[DiscoveryViewController alloc] init] image:@"ic_live_tab_rank_selected" seletedImage:@"ic_live_tab_rank_normal" title:@"发现"];
    // 我的
    [self addChildViewController:[[MineViewController alloc] init] image:@"ic_live_tab_me_selected"  seletedImage:@"ic_live_tab_me_normal"  title:@"我的"];
    //    // 小视频
    //    [self addChildViewController:[[AccountRechargeVC alloc] init] image:@"ic_live_tab_video_normal" seletedImage:@"ic_live_tab_video_selected" title:@"充值"];

}
#pragma mark - 添加子控制器
- (UIViewController *)addChildViewController:(UIViewController *)childController image:(NSString *)image seletedImage:(NSString *)selectedImage title:(NSString *)title
{
    childController.title = title;
        
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    [normalAttrs setObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
    [childController.tabBarItem setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
        
    NSMutableDictionary *selectedAtrrs = [NSMutableDictionary dictionary];
    [selectedAtrrs setObject:kAppMainColor forKey:NSForegroundColorAttributeName];
    [childController.tabBarItem setTitleTextAttributes:selectedAtrrs forState:UIControlStateSelected];

    // 设置图片
    [childController.tabBarItem setImage:[[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [childController.tabBarItem setSelectedImage:[[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    // 导航条
    FYNavigationViewController *nav = [[FYNavigationViewController alloc] initWithRootViewController:childController];
    [self addChildViewController:nav];
    
    
     childController.navigationItem.backBarButtonItem  = [[UIBarButtonItem  alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    return childController;
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(nonnull UIViewController *)viewController
{
    
    return YES;
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
