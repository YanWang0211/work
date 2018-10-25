//
//  ChatMessageModel.m
//  几里
//
//  Created by 泰山金融 on 2018/7/17.
//  Copyright © 2018年 云农公社. All rights reserved.
/*
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
 kJMSGContentTypeVideo = 9,*/

#import "ChatMessageModel.h"

@implementation ChatMessageModel

+ (ChatMessageModel *)createChatMessageModelWithJMesage:(JMSGMessage *)message{
    
    ChatMessageModel *model = [[ChatMessageModel alloc] init];
    
//    model.msgId = [[message.msgId mutableCopy] substringFromIndex:6];
    model.msgId = kToString(message.msgId);
    model.serverMessageId = kToString(message.serverMessageId);
    model.target = kToString(message.target);
    model.targetAppKey = kToString(message.targetAppKey);
    model.fromAppKey = kToString(message.fromAppKey);
    model.fromUser = message.fromUser;
    model.fromType = kToString(message.fromType);
    model.contentType = message.contentType;
    model.content = message.content;
    model.timestamp = message.timestamp;
    model.fromName = kToString(message.fromName);
    model.targetType = message.targetType;
    model.status = message.status;
    model.isReceived = message.isReceived;
    model.flag = message.flag;
    if (message.contentType == kJMSGContentTypeText) {
        NSString *text = [NSString stringWithFormat:@"%@",[message.content valueForKey:@"text"]];
        
        CGFloat height1;
        CGFloat width1 = kScreenW - 70 - 100;
        
        height1 = [text boundingRectWithSize:CGSizeMake(width1, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
        if (height1 < 22) {
            width1 = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 16) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.width+ 10;
        }
        
        height1 += 30;
//        if (height1 < 50) {
//            height1 =  50;
//        }
        model.cellSize = CGSizeMake(width1, height1);
    }else if (message.contentType == kJMSGContentTypeImage){
        JMSGImageContent *imagemessage =(JMSGImageContent *) message.content;
        
        if (imagemessage.imageSize.width < 150) {
            model.cellSize = CGSizeMake(imagemessage.imageSize.width, imagemessage.imageSize.height + 40);
        }else{
            model.cellSize = CGSizeMake(150, imagemessage.imageSize.height * 150 / imagemessage.imageSize.width + 40);
        }
    }else if(message.contentType == kJMSGContentTypeVoice){
        
        JMSGVoiceContent *voicemessage = (JMSGVoiceContent *) message.content;
        
        [voicemessage voiceData:^(NSData *data, NSString *objectId, NSError *error) {
            if (!error) {
                model.netData = [NSData dataWithData:data];
            }
        }];
        model.cellSize = CGSizeMake(100, 50);
    }
    
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"chatRoomModelUnfinedkey =  %@",key);
}

@end
