//
//  LeftViewController.m
//  几里
//
//  Created by 泰山金融 on 2018/8/8.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import "LeftViewController.h"
#import "MineViewController.h"
#import "XLSlideMenu.h"
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>

#import "LeftTableViewCell.h"
#define WIDTH screenW * 0.618

@interface LeftViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>
@property (nonatomic,strong) CLLocationManager * locationManager;//定位>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSArray * imageArr;
@property (nonatomic,strong) NSArray * titleArr;

@end

@implementation LeftViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView * backView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenW * 0.618, 170)];
    backView.backgroundColor = kAppMainColor;
    [self.view addSubview:backView];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.cornerRadius = 40;
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    btn.layer.borderWidth = 1;
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backView.mas_left).offset(20);
        make.bottom.mas_equalTo(backView.mas_bottom).offset( - 20);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(80);
    }];
    
    [btn addTarget:self action:@selector(showMineView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * refreshLocation = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshLocation.backgroundColor = [UIColor whiteColor];
    refreshLocation.layer.cornerRadius = 12;
    refreshLocation.layer.borderColor = [UIColor whiteColor].CGColor;
    refreshLocation.layer.borderWidth = 1;
    [refreshLocation  setTitle:@"刷新位置" forState:UIControlStateNormal];
    refreshLocation.titleLabel.font = [UIFont systemFontOfSize:10];
    [refreshLocation setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [refreshLocation setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [backView addSubview:refreshLocation];
    [refreshLocation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(backView.mas_right).offset(- 20);
        make.bottom.mas_equalTo(backView.mas_bottom).offset( - 20);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(24);
    }];
    [refreshLocation addTarget:self action:@selector(startLocation) forControlEvents:UIControlEventTouchUpInside];
    [self createUI];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)createUI{
    
    _titleArr = @[@"我的好友",@"",@"个性标签",@"我的会员",@"我的动态",@"",@"设置"];
    _imageArr = @[@"ic_0",@"",@"ic_2",@"ic_3",@"ic_4",@"",@"ic_6",];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 170, screenW * 0.618, screenH - 170) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate= self;
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"LeftTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 7;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LeftTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    [cell refreshCellWithImage:_imageArr[indexPath.row] andTitle:_titleArr[indexPath.row]];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.xl_sldeMenu showRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leftTabelViewEvent" object:[NSNumber numberWithInteger:indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


- (void)showMineView{
    
    [self.xl_sldeMenu showRootViewControllerAnimated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushPersonCenterView" object:nil];
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
