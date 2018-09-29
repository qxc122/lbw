//
//  ChatTool.h
//  Core
//
//  Created by heiguohua on 2018/9/22.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JMessage/JMSGConversation.h>



@protocol ChatToolJMSGMessageDelegate <NSObject>
@required
- (void)ChatToolonReceiveChatRoomConversation:(JMSGConversation *)conversation
                                     messages:(NSArray JMSG_GENERIC(__kindof JMSGMessage *)*)messages;
@required
- (void)ChatToolkJMSGNetworkSucces;
@optional
- (void)ChatToolonSendMessageResponse:(JMSGMessage *)message error:(NSError *)error;
//@optional
//- (void)ChatToolonReceiveMessageDownloadFailed:(JMSGMessage *)message;
//@optional
//- (void)ChatToolonSyncOfflineMessageConversation:(JMSGConversation *)conversation
//                         offlineMessages:(NSArray JMSG_GENERIC(__kindof JMSGMessage *)*)offlineMessages;
//@optional
//- (void)ChatToolonSyncRoamingMessageConversation:(JMSGConversation *)conversation;


@end


NS_ASSUME_NONNULL_BEGIN

@interface ChatTool : NSObject
- (void)addArry:(NSArray *)arry;
@property(assign, nonatomic) NSInteger TotalMessages;
@property(strong, nonatomic) LBGetMyInfoModel *User;
@property(strong, nonatomic) LBGetVerCodeModel *basicConfig;

#pragma mark 下载用户头像并更新IM用户信息
- (void)updateUserInfo;

singleH(ChatTool);
- (void)StartWork;
- (void)StopWork;
- (void)IMLogin;
@property (strong, nonatomic) NSMutableArray *list;
@property(strong, nonatomic) JMSGConversation *conversation;
@property (nonatomic, weak, nullable) id <ChatToolJMSGMessageDelegate> delegate;
@end

NS_ASSUME_NONNULL_END





