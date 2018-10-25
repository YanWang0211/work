//
//  ChatMessageModel.h
//  几里
//
//  Created by 泰山金融 on 2018/7/17.
//  Copyright © 2018年 云农公社. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatMessageModel : NSObject

/*!
 * 消息ID：这个ID是本地存数据库生成的ID，不是服务器端下发时的ID。
 */
@property(nonatomic, strong) NSString *msgId;

/*!
 * @abstract 服务器端下发的消息ID.
 * @discussion 一般用于与服务器端跟踪消息.
 */
@property(nonatomic, strong) NSString * JMSG_NULLABLE serverMessageId;

/*!
 * @abstract 消息发送目标
 *
 * @discussion 与 [fromUser] 属性相对应. 根据消息方向不同:
 *
 * - 收到的消息，target 就是我自己。
 * - 发送的消息，target 是我的聊天对象。
 *      单聊是对方用户;
 *      群聊是聊天群组, 也与当前会话的目标一致 [JMSGConversation target]
 */
@property(nonatomic, strong) id target;

/*!
 * @abstract 消息发送目标应用
 *
 * @discussion 这是为了支持跨应用聊天, 而新增的字段.
 *
 * 单聊时目标是 username. 当该用户为默认 appKey 时, 则不填此字段.
 * 群聊时目标是 groupId, 不填写此字段.
 *
 * @since 2.1.0
 */
@property(nonatomic, strong) NSString *targetAppKey;

/*!
 * @abstract 消息来源用户 Appkey
 *
 * @discussion 这是为了支持跨应用聊天, 而新增的字段.
 *
 * 不管群聊还是单聊, from_id 都是发送消息的 username. 当该用户是默认 appKey 时, 则不填写此字段.
 *
 * @since 2.1.0
 */
@property(nonatomic, strong) NSString *fromAppKey;

/*!
 * @abstract 消息来源用户
 *
 * @discussion 与 [target] 属性相对应. 根据消息方向不同:
 *
 * - 收到的消息, fromUser 是发出消息的对方.
 *      单聊是聊天对象, 也与当前会话目标用户一致 [JMSGConversation target],
 *      群聊是该条消息的发送用户.
 * - 发出的消息: fromUser 是我自己.
 */
@property(nonatomic, strong) JMSGUser *fromUser;

/*!
 * @abstract 消息来源类型
 * @discussion 默认的用户之间互发消息，其值是 "user"。如果是 App 管理员下发的消息，是 "admin"
 */
@property(nonatomic, strong) NSString *fromType;

/*!
 * @abstract 消息的内容类型
 */
@property(nonatomic, assign) JMSGContentType contentType;

/*!
 * @abstract 消息内容对象
 * @discussion 使用时应通过 contentType 先获取到具体的消息类型，然后转型到相应的具体类。
 */
@property(nonatomic, strong) JMSGAbstractContent * JMSG_NULLABLE content;

/*!
 * @abstract 消息发出的时间戳
 * @discussion 这是服务器端下发消息时的真实时间戳，单位为毫秒
 */
@property(nonatomic, strong) NSNumber *timestamp;

/*!
 * @abstract 消息中的fromName
 * @discussion 消息的发送方展示名称
 */
@property(nonatomic, strong) NSString *fromName;


///----------------------------------------------------
/// @name Message addOn fields 消息附加属性
///----------------------------------------------------

/*!
 * @abstract 聊天类型。当前支持的类型：单聊，群聊
 */
@property(nonatomic, assign) JMSGConversationType targetType;

/*!
 * @abstract 消息状态
 * @discussion 一条发出的消息，或者收到的消息，有多个状态会下。具体定义参考 JMSGMessageStatus 的定义。
 */
@property(nonatomic, assign) JMSGMessageStatus status;

/*!
 * @abstract 当前的消息是不是收到的。
 *
 * @discussion 是收到的，则是别人发给我的。UI 上一般展示在左侧。
 * 如果不是收到侧的，则是发送侧的，是我对外发送的。
 *
 * 主要是在聊天界面展示消息列表时，需要使用此方法，来确认展示消息的方式与位置。
 * 展示时需要发送方消息，不管是收到侧还是发送侧，都可以使用 fromUser 对象。
 */
@property(nonatomic, assign) BOOL isReceived;

/*!
 * @abstract 消息标志
 *
 * @discussion 这是一个用于表示消息状态的标识字段, App 可自由使用, SDK 不做变更.
 * 默认值为 0, App 有需要时可更新此状态.
 *
 * 使用场景:
 *
 * 1. 语音消息有一个未听标志. 默认 0 表示未读, 已读时 App 更新为 1 或者其他.
 * 2. 某些 App 需要对一条消息做送达, 已读标志, 可借用这个字段.
 */
@property(nonatomic, strong) NSNumber *flag;

/*!
 * @abstract 是否已读(只针对接收的消息)
 *
 * @discussion 该属性与实例方法 [-(void)setMessageHaveRead:] 是对应的。
 *
 * 注意：只有发送方调用 [+sendMessage:optionalContent:] 方法设置 message 需要已读回执，此属性才有意义。
 */
@property(nonatomic, assign) BOOL isHaveRead;

@property  CGSize cellSize;//cell尺寸

@property(nonatomic,strong) NSData *netData;

+ (ChatMessageModel *)createChatMessageModelWithJMesage:(JMSGMessage *)message;

@end
