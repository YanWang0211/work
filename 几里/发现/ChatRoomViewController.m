//
//  ChatRoomViewController.m
//  几里
//
//  Created by 王岩 on 2018/7/10.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import "ChatRoomViewController.h"
#import "ChatViewCell.h"
#import "ChatViewCell2.h"
#import "ChatMessageModel.h"
#import "MoreBoard.h"
#import <AVFoundation/AVFoundation.h>
#import <BmobSDK/Bmob.h>
#import "WYSlider.h"
#import "LMUtils.h"
#import "recoderAnimationView.h"
#import "MineViewController.h"
#import "LeftViewController.h"
#import "DongTaiView.h"
#import "MineDongTaiViewController.h"
#define HEIGHT 40
#define NavigationH 60

@interface ChatRoomViewController ()<UITableViewDelegate,UITableViewDataSource,JMSGConversationDelegate,JMessageDelegate,UITextFieldDelegate,LiuqsEmotionKeyBoardDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,AVAudioPlayerDelegate,ChatCell1Delegate,ChatCell1Delegate2>

@property (nonatomic,strong) UIView * movebackview;//输入框 发送按钮 superview
@property (nonatomic,strong)UITextField * messageTextField;//输入框
@property (nonatomic,strong) MoreBoard * moreView;//更多界面
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *messageArray;
@property (nonatomic,strong) LiuqsEmoticonKeyBoard * keyboard;//
@property (nonatomic,strong) UILabel * recordBtn;//录音按钮
@property (nonatomic,strong) AVAudioRecorder * recorder;//录音对象
@property (nonatomic,strong) AVAudioSession *session;
@property (nonatomic,strong) AVAudioPlayer * player;//播放器
@property (nonatomic,strong) NSString * recordPath;//录音地址
@property (nonatomic,strong) UIButton * centerBtn;//距离
@property (nonatomic,strong) recoderAnimationView * recoderLoadvidw;//
@property (nonatomic,strong) UIScrollView * scrollView;
@property (nonatomic,strong) UIButton * friendBtn;
@property (nonatomic,strong) UIButton * dongtaiBtn;



@property (nonatomic,assign) BOOL isKeyBoardShow;//
@end

@implementation ChatRoomViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [JMessage addDelegate:self withConversation:nil];
    
#pragma mark -键盘弹出添加监听事件
    // 键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    // 键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHiden:) name:UIKeyboardWillHideNotification object:nil];
    
    _isKeyBoardShow = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushPersonCenterView) name:@"pushPersonCenterView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftViewEvent:) name:@"leftTabelViewEvent" object:nil];

    
    [self setUI];

    [self loadData];
  
//    self.keyboard = [LiuqsEmoticonKeyBoard showKeyBoardInView:self.view];
//    self.keyboard.KeyBoardNeedMoveUp = YES;
//    self.keyboard.delegate = self;
    
    // Do any additional setup after loading the view.
}
- (void)loadData{
    
    [JMSGChatRoom getChatRoomInfosWithRoomIds:@[@"12580863"]   completionHandler:^(id resultObject, NSError *error) {
        
        NSArray * arr = resultObject;
        ChatRoomModel *model = [ChatRoomModel createModelWithDic:[arr firstObject]];
        self.chatRoomModel = model;
        [JMSGChatRoom leaveChatRoomWithRoomId:@"12580863" completionHandler:^(id resultObject, NSError *error) {
            if (!error) {
                NSLog(@"退出成功");
                [JMSGChatRoom enterChatRoomWithRoomId:@"12580863" completionHandler:^(id resultObject, NSError *error) {
                    if (!error) {
                        NSLog(@"成功加入聊天室");
                        
//                        [BmobUser loginWithUsernameInBackground:[Config getUserId] password:[Config getMD5_5] block:^(BmobUser *user, NSError *error) {
//                            if (user) {
//                                
//                                [STTextHudTool hideSTHud];
//                                [STTextHudTool showSuccessText:@"登录成功"];
//
//                                
//                            } else {
//                                [STTextHudTool hideSTHud];
//                                [STTextHudTool showErrorText:@"登录失败"];
//                            }
//                        }];
                        
                    }else{
                        NSLog(@"%@",error);
                    }
                }];
            }else{
                NSLog(@"%@",error);
            }
        }];
    }];
}

- (void)setUI{
    
    [self createHeaderView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenW, 40, kScreenW, kScreenH - HEIGHT - 100) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.backgroundColor = kChatRoomBackViewColor;
    _tableView.dataSource = self;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 150;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectZero];
    [_tableView registerClass:[ChatViewCell class] forCellReuseIdentifier:@"cellme"];
    [_tableView registerClass:[ChatViewCell2 class] forCellReuseIdentifier:@"cellothers"];
    [_scrollView addSubview:_tableView];
    
    //键盘隐藏手势
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewTouchInSide)];
    tableViewGesture.numberOfTapsRequired = 1;//几个手指点击
    tableViewGesture.cancelsTouchesInView = NO;//是否取消点击处的其他action
    [_tableView addGestureRecognizer:tableViewGesture];
    
    
    _movebackview = [[UIView alloc] initWithFrame:CGRectMake(kScreenW, kScreenH -  HEIGHT - NavigationH, kScreenW, HEIGHT)];
    _movebackview.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_movebackview];
    
    //表情按钮
    UIButton * emojiBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenW - HEIGHT * 2 -5, 2.5, HEIGHT - 5, HEIGHT - 5)];
    [emojiBtn setImage:[UIImage imageNamed: @"chatroom_emoji"] forState:UIControlStateNormal];
    [emojiBtn addTarget:self action:@selector(showEmojiKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    [_movebackview addSubview:emojiBtn];
    
    //更多按钮
    UIButton * moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenW - HEIGHT -5, 2.5, HEIGHT - 5, HEIGHT -5)];
    [moreBtn setImage:[UIImage imageNamed:@"chatroom_more"] forState:UIControlStateNormal];
    [moreBtn addTarget:self  action:@selector(showMoreBtnView) forControlEvents:UIControlEventTouchUpInside];
    [_movebackview addSubview:moreBtn];
    
    //语音按钮
    UIButton *voiceBtn = [[UIButton alloc] initWithFrame:CGRectMake( 5, 2.5, HEIGHT - 5, HEIGHT - 5)];
    [voiceBtn setImage:[UIImage imageNamed:@"chatroom_voice"] forState:UIControlStateNormal];
    [voiceBtn setImage:[UIImage imageNamed:@"chatroom_keyboard"] forState:UIControlStateSelected];
    [voiceBtn addTarget:self action:@selector(showVoiceRecord:) forControlEvents:UIControlEventTouchUpInside];
    [_movebackview addSubview:voiceBtn];
    
    _messageTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(voiceBtn.frame) + 10, 5, kScreenW - 70 - HEIGHT - 30 , HEIGHT - 10)];
    _messageTextField.placeholder = @"请输入消息";
//    _messageTextField.keyboardType = UIKeyboardTypeDefault;
    _messageTextField.returnKeyType = UIReturnKeySend;
    _messageTextField.delegate = self;
    _messageTextField.borderStyle = UITextBorderStyleRoundedRect;
    _messageTextField.font = [UIFont systemFontOfSize:13];
    [_movebackview addSubview:_messageTextField];
    
    _recordBtn = [[UILabel alloc] initWithFrame:_messageTextField.frame];
    _recordBtn.backgroundColor = [UIColor whiteColor];
    _recordBtn.text = @"长按录音";
//    [_recordBtn setTitle:@"长按 录音" forState:UIControlStateNormal];
//    [_recordBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _recordBtn.layer.cornerRadius = 3;
    _recordBtn.layer.masksToBounds = YES;
    _recordBtn.layer.borderWidth = 0.5;
    _recordBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_movebackview addSubview:_recordBtn];
    _recordBtn.textAlignment = NSTextAlignmentCenter;
    _recordBtn.userInteractionEnabled = YES;
    _recordBtn.hidden = YES;
//    [_recordBtn addTarget:self action:@selector(startRecordVoice:) forControlEvents:UIControlEventTouchUpInside];
    
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureEvent:)];
//    longGesture.numberOfTouchesRequired = 1;
//    longGesture.numberOfTapsRequired =1;
    longGesture.minimumPressDuration = 0.2;
    [_recordBtn addGestureRecognizer:longGesture];
    
}

- (void)createHeaderView{
    
    UIView * backview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenW, NavigationH)];
    backview.backgroundColor = kAppMainColor;
    [self.view addSubview:backview];
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 25, 30, 30)];
    [btn setImage:[UIImage imageNamed:@"chatroom_menu"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    [backview addSubview:btn];
    
    UIButton * moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(screenW - 40, 25, 30, 30)];
    [moreBtn setImage:[UIImage imageNamed:@"chatroom_more-1"] forState:UIControlStateNormal];
    [backview addSubview:moreBtn];
    
    
    _centerBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 25, 100, 30)];
    _centerBtn.center = CGPointMake(screenW/2, 40);
    [_centerBtn setTitle: @"5.0km" forState:UIControlStateNormal];
    [_centerBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_centerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    _centerBtn.selected = YES;
    _centerBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    _centerBtn.tag = 322;
    [backview addSubview:_centerBtn];
    [_centerBtn addTarget:self action:@selector(headerBtnEvent:) forControlEvents:UIControlEventTouchUpInside];

    _friendBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(_centerBtn.frame) - 40, 25, 30, 30)];
    [_friendBtn setImage:[UIImage imageNamed:@"chatroom_left"] forState:UIControlStateNormal];
    [_friendBtn setImage:[UIImage imageNamed:@"chatroom_left_seleted"] forState:UIControlStateSelected];
    _friendBtn.selected = NO;
    [backview addSubview:_friendBtn];
    _friendBtn.tag =  321;
    [_friendBtn addTarget:self action:@selector(headerBtnEvent:) forControlEvents:UIControlEventTouchUpInside];

    
    _dongtaiBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_centerBtn.frame) + 10, 25, 30, 30)];
    [_dongtaiBtn setImage:[UIImage imageNamed:@"chatroom_right"] forState:UIControlStateNormal];
    [_dongtaiBtn setImage:[UIImage imageNamed:@"chatroom_right_selected"] forState:UIControlStateSelected];
    _dongtaiBtn.selected = NO;
    [backview addSubview:_dongtaiBtn];
    _dongtaiBtn.tag = 323;
    [_dongtaiBtn addTarget:self action:@selector(headerBtnEvent:) forControlEvents:UIControlEventTouchUpInside];

    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 60, screenW, screenH - NavigationH)];
    _scrollView.delegate = self;
    _scrollView.contentOffset = CGPointMake(screenW, 0);
    _scrollView.pagingEnabled  = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(screenW * 3, screenH - NavigationH);
    [self.view addSubview:_scrollView];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(screenW, 0, screenW, 40)];
    view.backgroundColor = kAppMainColor;
    [_scrollView addSubview:view];
    
    
    WYSlider * slider = [[WYSlider alloc] initWithFrame:CGRectMake(10, 10, screenW - 20, 10)];
    slider.minimumTrackTintColor = [UIColor whiteColor];
    slider.maximumTrackTintColor = [UIColor blackColor];
    slider.thumbTintColor = kAppMainColor;
    slider.minimumValue = 0;//设置最小值
    slider.maximumValue = 10;//设置最大值
//    slider.continuous = NO;
    slider.value = 5;
    [slider addTarget:self action:@selector(sliderEvent:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:slider];
    
    
    UILabel * minLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(slider.frame), 30, 20)];
    minLabel.text = @"0m";
    minLabel.textColor = [UIColor grayColor];
    minLabel.font = [UIFont systemFontOfSize:11];
    [view addSubview:minLabel];
    
    UILabel * maxLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenW -  40, CGRectGetMaxY(slider.frame), 30, 20)];
    maxLabel.text = @"10km";
    maxLabel.textAlignment = NSTextAlignmentRight;
    maxLabel.textColor = [UIColor grayColor];
    maxLabel.font = [UIFont systemFontOfSize:11];
    [view addSubview:maxLabel];
    
    DongTaiView * dongtai = [[DongTaiView alloc] initWithFrame:CGRectMake(screenW * 2, 0, screenW, screenH - NavigationH)];
    [_scrollView addSubview:dongtai];
    
    UIButton * pushBtn = [[UIButton alloc] initWithFrame:CGRectMake(screenW * 3 - 80, screenH - 80 - NavigationH, 50, 50)];
    pushBtn.backgroundColor = kAppMainColor;
    pushBtn.layer.cornerRadius= 25;
    [pushBtn setImage:[UIImage imageNamed:@"ic_publish"] forState:UIControlStateNormal];
    [_scrollView addSubview:pushBtn];
    
}

#pragma mark - tableviewdelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messageArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChatMessageModel * message = self.messageArray[indexPath.row];
    NSString *uid = [NSString stringWithFormat:@"%lld",message.fromUser.uid];
    
    if ([uid isEqualToString:[Config getUserUid]]) {
        ChatViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellme" forIndexPath:indexPath];
        cell.delegate = self;
        [cell refreshCellWithMessage:message];
        return cell;
    }else{
        ChatViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"cellothers" forIndexPath:indexPath];
        [cell refreshCellWithMessage:message];
        cell.delegate = self;
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    ChatMessageModel * message = self.messageArray[indexPath.row];
    return message.cellSize.height + 10;
}


#pragma mark - 发送消息
- (void)clickSendMessageButton{
    
    if (_messageTextField.text == nil || _messageTextField.text.length == 0) {
        [FYAlertView showOneAlertWithDetail:@"🐷,还没输入聊天内容呢"];
        return;
    }
    
    JMSGTextContent * content = [[JMSGTextContent alloc] initWithText:_messageTextField.text];
    JMSGMessage *message = [JMSGMessage createChatRoomMessageWithContent:content chatRoomId:self.chatRoomModel.roomID];
    
    _messageTextField.text = nil;
    
    [self sendMessageWithJMSMessage:message];
    
}

- (void)sendMessageWithJMSMessage:(JMSGMessage *)message{
    [JMSGMessage sendMessage:message];
    ChatMessageModel * model = [ChatMessageModel createChatMessageModelWithJMesage:message];
    [self.messageArray addObject:model];
    [_tableView reloadData];
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma JMessageDelegate
- (void)onReceiveChatRoomConversation:(JMSGConversation *)conversation messages:(NSArray<__kindof JMSGMessage *> *)messages {
    if (conversation.conversationType == kJMSGConversationTypeChatRoom) {
        if ([[(JMSGChatRoom *)conversation.target roomID] isEqualToString:self.chatRoomModel.roomID]) {
            NSArray *array = messages;
            for (int i = 0 ; i < array.count; i ++) {
                JMSGMessage *message = [array objectAtIndex:i];
                ChatMessageModel * model = [ChatMessageModel createChatMessageModelWithJMesage:message];
                [self.messageArray addObject:model];
            }
            [_tableView reloadData];
            if (self.messageArray.count) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        }
    }
}
- (void)onSendMessageResponse:(JMSGMessage *)message error:(NSError *)error{
    if (!error) {
        if (message.targetType == kJMSGConversationTypeChatRoom) {
            if ([[(JMSGChatRoom *)message.target roomID] isEqualToString:self.chatRoomModel.roomID]) {
                NSLog(@"消息发送成功");
                ChatMessageModel * model = [ChatMessageModel createChatMessageModelWithJMesage:message];

                for (ChatMessageModel * message in self.messageArray) {
                    
                    if ([message.msgId isEqualToString:model.msgId]) {
                       
                        NSInteger inter = [self.messageArray indexOfObject:message];
                        [self.messageArray replaceObjectAtIndex:inter withObject:model];
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:inter inSection:0];
                        //                ChatViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    }
                }
            }
        }
    } else {
        [FYAlertView showOneAlertWithDetail:@"消息发送失败"];
    }
}

- (void)sliderEvent:(WYSlider *)slider{
    [_centerBtn setTitle:[NSString stringWithFormat:@"%.1fkm",slider.value] forState:UIControlStateNormal];
}

#pragma mark - 打开菜单
- (void)showMenu{
    self.block();
}

#pragma mark - 弹出更多面板
- (void)showMoreBtnView{
    [_messageTextField resignFirstResponder];
    if (!_moreView) {
        _moreView = [[MoreBoard alloc] initWithFrame:CGRectMake(kScreenW, kScreenH, kScreenW , 200)];
        [_scrollView addSubview:_moreView];
        WS(weakSelf);
        _moreView.moreBoarkBlock = ^(int type) {
            if (type == 1) {//
                [FYToolClass checkCameraWithSuperView:weakSelf];
            }
            if (type == 2) {
                [FYToolClass checkPhotoWithSuperView:weakSelf];
            }
            if (type == 3) {
                
            }
            if (type == 4) {
                
            }
        };
        [UIView animateWithDuration:0.2 animations:^{
            self.moreView.frame = CGRectMake(kScreenW, kScreenH - 200 - NavigationH, kScreenW , 200);
            self.movebackview.frame = CGRectMake(kScreenW, kScreenH -  200 - HEIGHT - NavigationH, kScreenW, HEIGHT);
            self.tableView.frame = CGRectMake(kScreenW, 40 , kScreenW , kScreenH -  200 - HEIGHT - 40);
            if (self.messageArray.count) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        }];
    }
}

#pragma mark - 表情面板
- (void)showEmojiKeyBoard{
    
  
}

#pragma mark - 头像点击事件
- (void)headImageClickEvent:(ChatMessageModel *)model{
    
    MineViewController * mine = [[MineViewController alloc] init];
    [self.navigationController pushViewController:mine animated:YES];
}
- (void)headImageClickEvent2:(ChatMessageModel *)model{
    
    MineViewController * mine = [[MineViewController alloc] init];
    [self.navigationController pushViewController:mine animated:YES];
}

- (void)pushPersonCenterView{
    MineViewController * mine = [[MineViewController alloc] init];
    [self.navigationController pushViewController:mine animated:YES];
}

#pragma mark - 语音录制
- (void)showVoiceRecord:(UIButton *)btn{
    btn.selected = !btn.selected;
    _recordBtn.hidden = !btn.selected;
    if (btn.selected) {
        [_messageTextField resignFirstResponder];
        _messageTextField.enabled = NO;
    }else{
        [_messageTextField becomeFirstResponder];
        _messageTextField.enabled = YES;
    }
}

#pragma mark - 长按手势事件
-(void)longPressGestureEvent:(UILongPressGestureRecognizer *)longPressGest{
    
    if (!_session) {
        _session = [AVAudioSession sharedInstance];
        [_session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [_session setActive: YES error: nil];
    }
    
    if (!_recoderLoadvidw) {
        _recoderLoadvidw = [[recoderAnimationView alloc] initWithFrame:CGRectMake(0, 0, 150, 170) withTitle:@"松开发送..." withImage:@"chatroom_voice-1"];
        _recoderLoadvidw.center = CGPointMake(self.view.center.x, self.view.center.y);
        [self.view addSubview:_recoderLoadvidw];
        _recoderLoadvidw.hidden = YES;
    }
    
    if (longPressGest.state==UIGestureRecognizerStateBegan) {
        self.recoderLoadvidw.hidden = NO;
        NSLog(@"长按手势开启");
        _recordBtn.text = @"松开发送";
         [self deleteOldRecordFile];
         [self.recorder record];
//        [STTextHudTool showWaitText:@"松开发送"];
        
        __block NSInteger time = 60; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(time <= 0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //停止录音
                    [self stopRecorder];
                    dispatch_cancel(_timer);
                  
                });
            }else{
                time--;
            }
        });
        dispatch_resume(_timer);
    } else if(longPressGest.state == UIGestureRecognizerStateEnded) {
        NSLog(@"长按手势结束");
        [self stopRecorder];
    }
}

- (void)stopRecorder{
//    [STTextHudTool hideSTHud];
    self.recordBtn.text = @"长按录音";
    if ([self.recorder isRecording]) {
        NSTimeInterval timeInterval = self.recorder.currentTime;
        NSLog(@"录音时长: %f",timeInterval);
        [self.recorder stop];
        NSData *voiceData = [NSData dataWithContentsOfFile:self.recordPath];
        JMSGVoiceContent *content = [[JMSGVoiceContent alloc] initWithVoiceData:voiceData voiceDuration:@(timeInterval)];
        JMSGMessage *message = [JMSGMessage createChatRoomMessageWithContent:content chatRoomId:self.chatRoomModel.roomID];
        [self sendMessageWithJMSMessage:message];
         _recoderLoadvidw.hidden = YES;
        if (_recoderLoadvidw) {
            [_recoderLoadvidw removeFromSuperview];
            _recoderLoadvidw = nil;
        }
    }
}

#pragma mark -键盘监听方法
- (void)keyboardWasShown:(NSNotification *)notification
{
    // 获取键盘的高度
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = frame.size.height;
     [UIView animateWithDuration:0.2 animations:^{
        self.movebackview.frame = CGRectMake(kScreenW, kScreenH -  HEIGHT -NavigationH - height, kScreenW, HEIGHT);
        self.tableView.frame = CGRectMake(kScreenW, 100 - NavigationH , kScreenW , kScreenH - HEIGHT  - height - 100);
         self.moreView.frame = CGRectMake(kScreenW, kScreenH, kScreenW , 200);
         if (self.messageArray.count) {
              [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
         }
    }];
    self.moreView = nil;
    _isKeyBoardShow = YES;
    
}
- (void)keyboardWillBeHiden:(NSNotification *)notification
{
    [UIView animateWithDuration:0.2 animations:^{
        self.movebackview.frame = CGRectMake(kScreenW, kScreenH - NavigationH - HEIGHT, kScreenW, HEIGHT);
        self.tableView.frame = CGRectMake(kScreenW, 40 , kScreenW, kScreenH - HEIGHT  - 100);
        if (self.messageArray.count) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }];
    
      _isKeyBoardShow = NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [self clickSendMessageButton];
    return YES;
}

- (void)tableViewTouchInSide{
 
    if (  _isKeyBoardShow || (_moreView.frame.origin.y != kScreenH && _moreView)) {
        [self.messageTextField resignFirstResponder];
        [self.view endEditing:YES];
        [UIView animateWithDuration:0.2 animations:^{
            self.moreView.frame = CGRectMake(kScreenW, kScreenH, kScreenW , 200);
            self.movebackview.frame = CGRectMake(kScreenW, kScreenH -  HEIGHT - NavigationH , kScreenW, HEIGHT);
            self.tableView.frame = CGRectMake(kScreenW, 40, kScreenW, kScreenH - HEIGHT- 100);
            if (self.messageArray.count) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        } completion:^(BOOL finished) {
            [self.moreView removeFromSuperview];
            self.moreView = nil;
        }];
    }
}

#pragma mark - imagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSLog(@"info = = %@",info);
    NSString *mediaType = [info objectForKey:@"UIImagePickerControllerMediaType"];
    
    if ([mediaType isEqualToString:@"public.image"]) {
        UIImage *originalImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *imageData = UIImageJPEGRepresentation(originalImage, 0.5);
        JMSGImageContent *content = [[JMSGImageContent alloc] initWithImageData:imageData];
        JMSGMessage *message = [JMSGMessage createChatRoomMessageWithContent:content chatRoomId:self.chatRoomModel.roomID];
        [self sendMessageWithJMSMessage:message];
    }else if([mediaType isEqualToString:@"public.movie"]){
        NSURL *URL = info[UIImagePickerControllerMediaURL];
        NSData *movieFile = [NSData dataWithContentsOfURL:URL];
    }
     [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    // 退出当前界面
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (flag) {
        [_player stop];
    }
}


-(NSMutableArray *)messageArray
{
    if (!_messageArray) {
        _messageArray = [[NSMutableArray alloc] init];
    }
    return _messageArray;
}


- (AVAudioRecorder *)recorder{
  
    if (!_recorder) {
        
        NSString *string=[NSString stringWithFormat:@"count.caf"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);//获得存储路径，
        NSString *documentDirectory = [paths objectAtIndex:0];//获得路径的第0个元素
        NSFileManager *fileManage = [NSFileManager defaultManager];
        NSString *myDirectory = [documentDirectory stringByAppendingPathComponent:@"text"];
        [fileManage createDirectoryAtPath:myDirectory withIntermediateDirectories:NO attributes:nil error:nil];
        _recordPath = [documentDirectory stringByAppendingPathComponent:string];//在第0个元素中添加txt文本
        NSLog(@"recordurl = %@",_recordPath);
        NSURL *url = [NSURL URLWithString:_recordPath];
        // 0.2 创建录音设置
        NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        //设置录音格式
        [dic setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
        //设置录音采样率 8000shi 电话采样率 对于一般录音已经够了
        [dic setObject:@(44100) forKey:AVSampleRateKey];
        //设置通道，这里采用单通道
        [dic setObject:@(1) forKey:AVNumberOfChannelsKey];
        //每个采样点位数 分别为 8 16 24 32
        [dic setObject:@(8) forKey:AVLinearPCMBitDepthKey];
        //是否采用浮点数采样
        [dic setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
        
        // 1. 创建录音对象
        _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:nil];
        // 2. 准备录音(系统会分配一些录音资源)
        [_recorder prepareToRecord];
    }
    return _recorder;
}
//删除旧录音缓存
-(void)deleteOldRecordFile{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:self.recordPath];
    if (!blHave) {
        //        NSLog(@"不存在");
        return ;
    }else {
        //        NSLog(@"存在");
        BOOL blDele= [fileManager removeItemAtPath:self.recordPath error:nil];
        if (blDele) {
            //            NSLog(@"删除成功");
        }else {
            //            NSLog(@"删除失败");
        }
    }
}

- (void)leftViewEvent:(NSNotification *)noti{
    
    NSNumber *num =(NSNumber *) noti.object;
    
    long a = [num longValue];
    if (a == 0) {//我的好友
        
    }else if (a == 2){//个性标签
       
        
    }else if (a == 3){//我的会员
       
    }else if (a == 4){//我的动态
        MineDongTaiViewController * mine = [[MineDongTaiViewController alloc] init];
        [self.navigationController pushViewController:mine animated:YES];
    }else if (a == 6){//设置
        
    }
    
}

- (void)headerBtnEvent:(UIButton *)btn{
    
    if (btn.tag == 321) {
        _friendBtn.selected = YES;
        _centerBtn.selected = NO;
        _dongtaiBtn.selected = NO;
    }else if (btn.tag == 322){
        _friendBtn.selected = NO;
        _centerBtn.selected = YES;
        _dongtaiBtn.selected = NO;
        
    }else{
        _friendBtn.selected = NO;
        _centerBtn.selected = NO;
        _dongtaiBtn.selected = YES;
    }
    
    [UIView animateWithDuration:0.4 animations:^{
        self.scrollView.contentOffset = CGPointMake((btn.tag - 321) * screenW, 0);
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.x < screenW / 2) {
        _friendBtn.selected = YES;
        _centerBtn.selected = NO;
        _dongtaiBtn.selected = NO;
    }else if (scrollView.contentOffset.x > screenW / 2* 3){
        _friendBtn.selected = NO;
        _centerBtn.selected = NO;
        _dongtaiBtn.selected = YES;
    }else{
        _friendBtn.selected = NO;
        _centerBtn.selected = YES;
        _dongtaiBtn.selected = NO;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushPersonCenterView" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"leftTabelViewEvent" object:nil];
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
