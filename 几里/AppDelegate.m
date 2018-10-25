//
//  AppDelegate.m
//  几里
//
//  Created by 泰山金融 on 2018/7/9.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
#import "FYTabbarViewController.h"
#import "LoginViewController.h"
#import <BmobSDK/Bmob.h>
#import "XLSlideMenu.h"
#import "ChatRoomViewController.h"
#import "LeftViewController.h"
@interface AppDelegate ()<JMessageDelegate,JMSGConversationDelegate,CLLocationManagerDelegate>
@property (nonatomic,strong) CLLocationManager * locationManager;//定位

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [Bmob registerWithAppKey:@"2db82ebdcebb2013be90e3cc7966bef5"];
    
     self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    /// Required - 添加 JMessage SDK 监听。这个动作放在启动前
    [JMessage addDelegate:self withConversation:nil];

    // Required - 启动 JMessage SDK
    [JMessage setupJMessage:launchOptions appKey:JiGuangAppKey channel:@"App Store" apsForProduction:NO category:nil messageRoaming:YES];
    // Required - 注册 APNs 通知
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JMessage registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                      UIUserNotificationTypeSound |
                                                      UIUserNotificationTypeAlert)
                                          categories:nil];
    } else {
        //categories 必须为nil
        [JMessage registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                      UIRemoteNotificationTypeSound |
                                                      UIRemoteNotificationTypeAlert)
                                          categories:nil];
    };
    
   
    if ([Config getUserName].length) {
        
        [self userLogin];
        [self enterMainView];
        
    }else{
        LoginViewController *loginView = [[LoginViewController alloc] init];
        self.window.rootViewController = loginView;
        [self.window makeKeyAndVisible];
    }

    return YES;
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required - 注册token
    [JMessage registerDeviceToken:deviceToken];
}

#pragma mark - 用户登录
- (void)userLogin{
    NSString *ID = [Config getUserId];
    NSString *passworrd = [Config getMD5_3];
    
    [JMSGUser loginWithUsername:ID password:passworrd completionHandler:^(id resultObject, NSError *error) {
        if (!error) {
            NSLog(@"Login Success ");
            //            self.user = resultObject;
            [BmobUser loginWithUsernameInBackground:[Config getUserId] password:[Config getMD5_5] block:^(BmobUser *user, NSError *error) {
                if (user) {
                    [STTextHudTool hideSTHud];
                   
                } else {
                    [STTextHudTool showErrorText:@"登录失败"];
                    [STTextHudTool hideSTHud];
                }
            }];
        }else{
            NSLog(@"Login Fail -> %@",error.description);
            [STTextHudTool hideSTHud];
            [FYAlertView showOneAlertWithDetail:@"登录失败了☹️"];
        };
    }];
}

#pragma mark - 进入主界面
- (void)enterMainView{
    
//    FYTabbarViewController *tabbar = [[FYTabbarViewController alloc] init];
//    self.window.rootViewController = tabbar;
//    [self.window makeKeyAndVisible];
 
    //启动定位
    [self startLocation];
    
    LeftViewController * leftvc = [[LeftViewController alloc] init];
    
    ChatRoomViewController * chatVC = [[ChatRoomViewController alloc] init];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:chatVC];
    
    XLSlideMenu * slideVC = [[XLSlideMenu alloc] initWithRootViewController:nav];
    slideVC.leftViewController = leftvc;
    self.window.rootViewController = slideVC;
    
    [self.window makeKeyWindow];
    chatVC.block = ^() {
    
        [slideVC showLeftViewControllerAnimated:YES];
        
    };
}


//MARK:开启定位功能
- (void)startLocation{
    _locationManager =[[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 5;
    _locationManager.pausesLocationUpdatesAutomatically = YES;
    
    //确定用户的位置服务是否启用,位置服务在设置中是否被禁用
    BOOL enable      =[CLLocationManager locationServicesEnabled];
    NSInteger status =[CLLocationManager authorizationStatus];
    if(  !enable || status< 2){
        //尚未授权位置权限
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8)
        {
            //系统位置授权弹窗
//            [_locationManager requestAlwaysAuthorization];
            [_locationManager requestWhenInUseAuthorization];
            [_locationManager startUpdatingLocation];

        }
    }else{
        if (status == kCLAuthorizationStatusDenied) {
            //用户在设置中关闭定位功能，或者用户明确的在弹框之后选择禁止定位
            UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"地点功能需要开启位置授权" delegate:self cancelButtonTitle:@"暂不设置" otherButtonTitles:@"现在去设置", nil];
            [alterView show];
        }else if(status == kCLAuthorizationStatusRestricted){
            //定位服务授权状态受限制，可能由于活动限制了定位服务，并且用户不能改变当前的权限，这个状态有可能不是用户拒绝的，但是也有可能是用户拒绝的
            
        }else if(status ==  kCLAuthorizationStatusNotDetermined){
            //用户没有选择是否要使用定位服务（弹框没选择，或者根本没有弹框
            
        }else if (status == kCLAuthorizationStatusAuthorized || status ==kCLAuthorizationStatusAuthorizedWhenInUse || status ==  kCLAuthorizationStatusAuthorizedAlways ){
            //允许定位
            [_locationManager startUpdatingLocation];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    // 停止实时定位
    [_locationManager stopUpdatingLocation];
    
    CLLocation * newLocation = [locations lastObject];
    
    //  取得经纬度
    CLLocationCoordinate2D coord2D = newLocation.coordinate;
    double latitude = coord2D.latitude;//纬度
    double longitude = coord2D.longitude;//经度
    NSLog(@"纬度 = %f  经度 = %f",latitude,longitude);
    
    //  取得精度
    CLLocationAccuracy horizontal = newLocation.horizontalAccuracy;
    CLLocationAccuracy vertical   = newLocation.verticalAccuracy;
    NSLog(@"水平方 = %f 垂直方 = %f",horizontal,vertical);
    
    //  取得高度
    CLLocationDistance altitude = newLocation.altitude;
    NSLog(@"%f",altitude);
    
    //  取得此时时刻
    NSDate *timestamp = [newLocation timestamp];
    //  实例化一个NSDateFormatter对象
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    //  设定时间格式
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss a"];
    [dateFormat setAMSymbol:@"上午"];         //  显示中文, 改成"上午"
    [dateFormat setPMSymbol:@"下午"];
    //  求出当天的时间字符串，当更改时间格式时，时间字符串也能随之改变
    NSString *dateString = [dateFormat stringFromDate:timestamp];
    NSLog(@"此时此刻时间 = %@",dateString);
    
    //  -----------------------------------------位置反编码--------------------------------------------
    CLGeocoder * geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        for (CLPlacemark * place in placemarks) {
            
            NSLog(@"name = %@",place.name);                                    //  位置名
            NSLog(@"thoroughfare = %@",place.thoroughfare);                    //  街道
            NSLog(@"locality = %@",place.locality);                            //  市
            NSLog(@"subLocality = %@",place.subLocality);                      //  区
            NSLog(@"省 = %@",place.administrativeArea);

        }
    }];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    NSLog(@"定位失败");
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
