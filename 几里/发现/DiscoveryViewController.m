//
//  DiscoveryViewController.m
//  几里
//
//  Created by 泰山金融 on 2018/7/10.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import "DiscoveryViewController.h"
#import "ChatRoomModel.h"
#import "ChatRoomViewController.h"
@interface DiscoveryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * tableview;//
@property (nonatomic,strong) NSMutableArray * chatRoomArray;//聊天室数组


@end

@implementation DiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [JMSGChatRoom getMyChatRoomListCompletionHandler:^(id resultObject, NSError *error) {
        if (!error) {
            
            NSArray *array = resultObject;
            for (int i = 0 ; i < array.count; i ++) {
                ChatRoomModel *model = [ChatRoomModel createModelWithDic:array[i]];
                [self.chatRoomArray addObject:model];
            }
            [self.tableview reloadData];
            
        }else{
            [FYAlertView showOneAlertWithDetail:@"聊天室列表获取失败"];
        }
    }];
    
    
    [self setUI];
    
    // Do any additional setup after loading the view.
}
- (void)setUI{
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStylePlain];
    _tableview.delegate  =  self;
    _tableview.dataSource = self;
    _tableview.backgroundColor = [UIColor whiteColor];
    _tableview.tableFooterView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableview];

}

#pragma tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.chatRoomArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    ChatRoomModel *model = self.chatRoomArray[indexPath.row];
    cell.textLabel.text = model.name;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChatRoomModel *model = (ChatRoomModel *)self.chatRoomArray[indexPath.row];
    ChatRoomViewController *room = [[ChatRoomViewController alloc] init];
    room.chatRoomModel = model;
    room.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:room animated:YES];
    
}



#pragma 懒加载
- (NSMutableArray *)chatRoomArray{
    if (!_chatRoomArray) {
        _chatRoomArray = [[NSMutableArray alloc] init];
    }
    return _chatRoomArray;
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
