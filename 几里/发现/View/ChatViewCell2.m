//
//  ChatViewCell2.m
//  几里
//
//  Created by 泰山金融 on 2018/8/9.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import "ChatViewCell2.h"
#import "chatcellbackview.h"
#import <AVFoundation/AVFoundation.h>

@interface ChatViewCell2()<AVAudioPlayerDelegate>
@property (nonatomic,strong) UIImageView * headImage;//头像
@property (nonatomic,strong) UILabel  * userName;//用户名
@property (nonatomic,strong) UILabel * content;//消息详情
@property (nonatomic,strong) chatcellbackview * backImage;//气泡
@property (nonatomic,strong) UIImageView * imageMessage;//图片消息
@property (nonatomic,strong) ChatMessageModel * chatModel;
@property (nonatomic,strong) UIButton * voiceBtn;//音频消息
@property (nonatomic,strong) AVAudioPlayer * player;//播放器

@end

@implementation ChatViewCell2
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createUI];
        self.contentView.backgroundColor = kChatRoomBackViewColor;
    }
    return self;
}


- (void)createUI{
    
    self.layer.cornerRadius = 5;
    
    _backImage = [[chatcellbackview alloc] init];
    _backImage.type = 1;
    //shadowColor阴影颜色
    _backImage.layer.shadowColor = [UIColor blackColor].CGColor;
    //shadowOffset阴影偏移,+x向右偏移，+y向下偏移，默认(0, -3),跟shadowRadius配合使用
    _backImage.layer.shadowOffset = CGSizeMake(0,0);
    //阴影透明度，默认0
    _backImage.layer.shadowOpacity = 0.1;
    //阴影半径，默认3
    _backImage.layer.shadowRadius = 4;
    _backImage.layer.masksToBounds = YES;
    [self.contentView addSubview:_backImage];
    
    _headImage = [[UIImageView alloc] init];
    _headImage.layer.cornerRadius = 20;
    _headImage.layer.masksToBounds = YES;
    _headImage.userInteractionEnabled = YES;
    [self.contentView addSubview:_headImage];
    
    UITapGestureRecognizer *tapRecognize = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap)];
    tapRecognize.numberOfTapsRequired = 1;
    tapRecognize.numberOfTouchesRequired = 1;
    [_headImage addGestureRecognizer:tapRecognize];
    
    _userName = [[UILabel alloc] init];
    _userName.backgroundColor = [UIColor clearColor];
    _userName.font = [UIFont systemFontOfSize:10];
    _userName.textColor = [UIColor darkGrayColor];
    [self.contentView  addSubview:_userName];
    
    _content = [[UILabel alloc] init];
    _content.font = [UIFont systemFontOfSize:14];
    _content.textColor = [UIColor blackColor];
    _content.numberOfLines = 0;
    _content.backgroundColor = [UIColor clearColor];
    //    _content.backgroundColor = RGBOF(0xd5d5d5);
    [self.contentView addSubview:_content];
    
    _imageMessage = [[UIImageView alloc] init];
    _imageMessage.layer.cornerRadius = 7;
    _imageMessage.layer.masksToBounds = YES;
    [self.contentView addSubview:_imageMessage];
    
    _voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_voiceBtn setImage:[UIImage imageNamed:@"chatroom_voice-1"] forState:UIControlStateNormal];
    _voiceBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_voiceBtn];
    [_voiceBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _voiceBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_voiceBtn setTitle:@"0\"" forState:UIControlStateNormal];
    [_voiceBtn addTarget:self action:@selector(playerVoice) forControlEvents:UIControlEventTouchUpInside];
    _voiceBtn.hidden=YES;
    [_voiceBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -25, 0, +25)];
    [_voiceBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, +15, 0, -15)];
}
/*typedef NS_ENUM(NSInteger, JMSGContentType) {
 /// 不知道类型的消息
 kJMSGContentTypeUnknown = 0,
 /// 文本消息
 kJMSGContentTypeText = 1,
 /// 图片消息
 kJMSGContentTypeImage = 2,
 /// 语音消息
 kJMSGContentTypeVoice = 3,
 /// 自定义消息
 kJMSGContentTypeCustom = 4,
 /// 事件通知消息。服务器端下发的事件通知，本地展示为这个类型的消息展示出来
 kJMSGContentTypeEventNotification = 5,
 /// 文件消息
 kJMSGContentTypeFile = 6,
 /// 地理位置消息
 kJMSGContentTypeLocation = 7,
 /// 提示性消息
 kJMSGContentTypePrompt = 8,
 /// 视频消息
 kJMSGContentTypeVideo = 9,
 };*/
- (void)refreshCellWithMessage:(ChatMessageModel *)message{
    
    self.chatModel = message;
    _userName.text = message.fromUser.username;
    [_headImage sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"headImage_place"]];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _userName.textAlignment = NSTextAlignmentLeft;
    [_headImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
        make.centerY.mas_equalTo(self.contentView.mas_top).offset(30);
        make.centerX.mas_equalTo(self.contentView.mas_left).offset(30);
    }];
    
    [_userName  mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenW - 100);
        make.height.mas_equalTo(15);
        make.left.mas_equalTo(self.headImage.mas_right).offset(10);
        make.top.mas_equalTo(self.headImage.mas_top);
    }];
    
    [_content mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.chatModel.cellSize.width);
        make.height.mas_equalTo(self.chatModel.cellSize.height  - 30);
        make.left.mas_equalTo(self.userName.mas_left).offset(10);
        make.top.mas_equalTo(self.userName.mas_bottom).offset(5);
    }];
    [_backImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.content.mas_right).offset(5);
        make.left.equalTo(self.content.mas_left).offset(-5);
        make.top.equalTo(self.content.mas_top).offset(-5);
        make.bottom.equalTo(self.content.mas_bottom).offset(5);
    }];
    [_imageMessage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.content.mas_right);
        make.top.mas_equalTo(self.content.mas_top);
        make.bottom.mas_equalTo(self.content.mas_bottom);
        make.left.mas_equalTo(self.content.mas_left);
    }];
    [_voiceBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.content.mas_right);
        make.top.mas_equalTo(self.content.mas_top);
        make.bottom.mas_equalTo(self.content.mas_bottom);
        make.left.mas_equalTo(self.content.mas_left);
    }];
    if (_chatModel.contentType == kJMSGContentTypeText) {
        _imageMessage.hidden = YES;
        _content.hidden = NO;
        _voiceBtn.hidden = YES;
        _content.text = [NSString stringWithFormat:@"%@",[_chatModel.content valueForKey:@"text"]];
    }
      WS(weakSelf);
    if (_chatModel.contentType == kJMSGContentTypeImage) {
        _imageMessage.hidden = NO;
        _content.hidden = YES;
        _voiceBtn.hidden = YES;
        JMSGImageContent *imagemessage =(JMSGImageContent *) _chatModel.content;
        [imagemessage thumbImageData:^(NSData *data, NSString *objectId, NSError *error) {
            if (error) {
                //放一个失败的图片
            }else{
                UIImage * image = [UIImage imageWithData:data];
                weakSelf.imageMessage.image = image;
            }
        }];
        
    }
    if (_chatModel.contentType == kJMSGContentTypeVoice) {
        _imageMessage.hidden = YES;
        _content.hidden = YES;
        _voiceBtn.hidden = NO;
        JMSGVoiceContent *voicemessage = (JMSGVoiceContent *) _chatModel.content;
        NSString *dur = [NSString stringWithFormat:@"%.1f",[voicemessage.duration floatValue]];
        [_voiceBtn setTitle:[NSString stringWithFormat:@"%@\"",dur] forState:UIControlStateNormal];
    }
    if (_chatModel.contentType == kJMSGContentTypeVideo) {
        
    }
    if (_chatModel.contentType == kJMSGContentTypeLocation) {
        
    }
      [_backImage setNeedsDisplay];
}
- (void)playerVoice{
    NSLog(@"播放录音");
    
    NSMutableData * voicedata = [[NSMutableData alloc] init];
    JMSGVoiceContent *voicemessage = (JMSGVoiceContent *) _chatModel.content;
    [voicemessage voiceData:^(NSData *data, NSString *objectId, NSError *error) {
        if (error) {
            NSLog(@"error = %@",error);
        }else{
            [voicedata appendData:data];
        }
    }];
    
    //缩放动画
    CABasicAnimation *anima2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    anima2.fromValue = [NSNumber numberWithFloat:1.0f];
    anima2.toValue = [NSNumber numberWithFloat:0.7f];
    anima2.duration = 0.7;
    anima2.autoreverses = YES;
    anima2.repeatCount = MAXFLOAT;
    [_voiceBtn.imageView.layer addAnimation:anima2 forKey:@"play"];
    NSError *error = nil;
      _player = [[AVAudioPlayer alloc] initWithData:voicedata  error:&error];
    if (error) {
        NSLog(@"error = %@",error);
    }
  
    [_player prepareToPlay];
    _player.delegate = self;
    [_player play];
    
    
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (flag) {
        [_player stop];
        
        [_voiceBtn.imageView.layer removeAllAnimations];
    }
}

- (void)handleTap{
    [self.delegate headImageClickEvent2:self.chatModel];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
