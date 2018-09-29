//
//  ChatTool.m
//  Core
//
//  Created by heiguohua on 2018/9/22.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ChatTool.h"


@interface ChatTool ()<JMessageDelegate>
{
    LBGetMyInfoModel *_User;
    LBGetVerCodeModel *_basicConfig;
}
@end



@implementation ChatTool
singleM(ChatTool);

- (LBGetVerCodeModel *)basicConfig{
    if (!_basicConfig) {
        _basicConfig = [NSKeyedUnarchiver unarchiveObjectWithFile:PATH_base];
    }
    return  _basicConfig;
}

- (void)setBasicConfig:(LBGetVerCodeModel *)basicConfig{
    _basicConfig = basicConfig;
    [NSKeyedArchiver archiveRootObject:basicConfig toFile:PATH_base];
}

- (LBGetMyInfoModel *)User{
    if (!_User) {
        _User = [NSKeyedUnarchiver unarchiveObjectWithFile:PATH_UESRINFO];
    }
    return  _User;
}
- (void)setUser:(LBGetMyInfoModel *)User{
    _User = User;
    [NSKeyedArchiver archiveRootObject:User toFile:PATH_UESRINFO];
}
- (void)StopWork{
    self.conversation = nil;
//    [self.conversation deleteChatRoomConversationWithRoomId:[ChatTool shareChatTool].basicConfig.main_room_id];
    [self.list removeAllObjects];
    [JMessage removeAllDelegates];
    [self LogOutChatRoomOnly];
    self.TotalMessages = 0;
}
- (void)StartWork{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(kJMSGNetworkSucces)
                                                 name:kJMSGNetworkDidLoginNotification
                                               object:nil];
}
#pragma mark --聊天室链接成功
- (void)kJMSGNetworkSucces{
    NSLog(@"IM 连接成功 开始登陆等工作");
    if (ISLOGIN) {
        if (!self.conversation) {
            [self IMLogin];
        }
    }
}

#pragma mark --聊天室 收到消息
- (void)onReceiveChatRoomConversation:(JMSGConversation *)conversation
                             messages:(NSArray JMSG_GENERIC(__kindof JMSGMessage *)*)messages{
    [self addArry:messages];
//    [[ChatToolSQL shareChatToolSQL] insertDataFormArry:messages];
//    self.TotalMessages += messages.count;
    NSLog(@"收到消息%ld",messages.count);
    if (self.delegate) {
        [self.delegate ChatToolonReceiveChatRoomConversation:conversation messages:messages];
    }
}

- (void)onSendMessageResponse:(JMSGMessage *)message error:(NSError *)error {
    if (self.delegate) {
        [self.delegate ChatToolonSendMessageResponse:message error:error];
    }
}
//- (void)onReceiveMessageDownloadFailed:(JMSGMessage *)message {
//    if (self.delegate) {
//        [self.delegate ChatToolonReceiveMessageDownloadFailed:message];
//    }
//}
//- (void)onSyncOfflineMessageConversation:(JMSGConversation *)conversation
//                         offlineMessages:(NSArray JMSG_GENERIC(__kindof JMSGMessage *)*)offlineMessages{
//    if (self.delegate) {
//        [self.delegate ChatToolonSyncOfflineMessageConversation:conversation offlineMessages:offlineMessages];
//    }
//}
//- (void)onSyncRoamingMessageConversation:(JMSGConversation *)conversation{
//    if (self.delegate) {
//        [self.delegate ChatToolonSyncRoamingMessageConversation:conversation];
//    }
//}
- (void)addArry:(NSArray *)arry{
    if (!self.list) {
        self.list = [NSMutableArray array];
    }
    if (arry) {
        [self.list addObjectsFromArray:arry];
    }
    if (self.list.count>50) {
        self.list = [[self.list subarrayWithRange:NSMakeRange(self.list.count-50, 50)] mutableCopy];
    }
    NSLog(@"存入消息 %ld",self.list.count);
}

- (void)setConversation:(JMSGConversation *)conversation{
    _conversation = conversation;
//    _conversation = [JMSGConversation groupConversationWithGroupId:self.basicConfig.main_room_id];
    [self addDelegate];
    if (self.delegate) {
        [self.delegate ChatToolkJMSGNetworkSucces];
    }
}

#pragma mark --add Delegate
- (void)addDelegate {
    [JMessage addDelegate:self withConversation:self.conversation];
}

- (void)IMLogin{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"chat_username"];
    NSString *passWord = [[NSUserDefaults standardUserDefaults] objectForKey:@"chat_password"];
    kWeakSelf(self);
    [JMSGUser loginWithUsername:userName password:passWord completionHandler:^(id resultObject, NSError *error) {
        if (!error) {
            //登录成功
            NSLog(@"IM 登陆成功");
            [weakself updateUserInfo];
            [weakself getMyChatRoomListCompletionHandler];
        } else {
            //登录失败
            NSLog(@"IM 登陆失败");
            [weakself performSelector:@selector(IMLogin) withObject:nil afterDelay:0.3];
        }
    }];
}

#pragma mark 下载用户头像并更新IM用户信息
- (void)updateUserInfo{
    if (self.User.avatar) {
        kWeakSelf(self);
        SDWebImageDownloader *manager = [SDWebImageDownloader sharedDownloader];
        [manager downloadImageWithURL:[NSURL URLWithString:self.User.avatar] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            if (image) {
                [weakself updateUserInfoEnd:image];
            }
        }];
    }
}
#pragma mark 上传用户头像，名字
- (void)updateUserInfoEnd:(UIImage *)image{
    // do something with image
    JMSGUserInfo *userInfo = [[JMSGUserInfo alloc] init];
    userInfo.nickname = self.User.name?self.User.name:self.User.surname;
    userInfo.address = self.User.address;
    userInfo.avatarData = UIImagePNGRepresentation(image);
    [JMSGUser updateMyInfoWithUserInfo:userInfo completionHandler:^(id resultObject, NSError *error) {
        if (!error) {
            NSLog(@"IM  信息 更新成功");
        } else {
            NSLog(@"IM 信息 更新失败");
        }
    }];
}


- (void)getMyChatRoomListCompletionHandler{
    kWeakSelf(self);
    [JMSGChatRoom getMyChatRoomListCompletionHandler:^(id resultObject, NSError *error) {
        if (!error) {
            if ([resultObject isKindOfClass:[NSArray class]]) {
                NSArray *ttmp = resultObject;
                NSLog(@"聊天室 获取成功");
                if (ttmp.count) {
                    NSLog(@"已经加入了聊天室");
                    if(self.list.count > 0){
                        JMSGChatRoom *tmp = ttmp.firstObject;
                        weakself.conversation = [JMSGConversation chatRoomConversationWithRoomId:tmp.roomID];
                        NSLog(@"有了历史记录");
                    }else{
                        NSLog(@"还没有历史记录 退出重新加入聊天室");
                        [weakself LogOutChatRoom];
                    }
                }else{
                    //去加入聊天室
                    NSLog(@" 还没有加入任何聊天室 去加入聊天室");
                    [weakself addChatRoom];
                }
            }
        }else{
            [weakself performSelector:@selector(getMyChatRoomListCompletionHandler) withObject:nil afterDelay:0.3];
            NSLog(@"聊天室 获取失败 %@",error.description);
        }
    }];
}
- (void)LogOutChatRoom{
    kWeakSelf(self);
    NSLog(@"推出 聊天室 中");
    LBGetVerCodeModel *data =  [NSKeyedUnarchiver unarchiveObjectWithFile:PATH_base];
    [JMSGChatRoom leaveChatRoomWithRoomId:data.main_room_id completionHandler:^(id resultObject, NSError *error) {
        if (!error) {
            NSLog(@"推出 聊天室成功");
            [weakself addChatRoom];
        }else{
            NSLog(@"推出 聊天室失败 %@",error.description);
            [weakself performSelector:@selector(LogOutChatRoom) withObject:nil afterDelay:0.1];
        }
    }];
}
- (void)addChatRoom{
    LBGetVerCodeModel *data =  [NSKeyedUnarchiver unarchiveObjectWithFile:PATH_base];
    kWeakSelf(self);
    
    
    [JMSGChatRoom enterChatRoomWithRoomId:data.main_room_id completionHandler:^(id resultObject, NSError *error) {
        if (!error) {
            NSLog(@"加入聊天室成功");
            weakself.conversation = resultObject;
        }else{
            NSLog(@"加入聊天室失败 %@",error.description);
            [weakself performSelector:@selector(addChatRoom) withObject:nil afterDelay:0.3];
        }
    }];
}

- (void)IMlogOut{
    //退出当前登录的用户
    kWeakSelf(self);
    [JMSGUser logout:^(id resultObject, NSError *error) {
        if (!error) {
            //退出登录成功
            NSLog(@"退出成功");
        } else {
            //退出登录失败
            [weakself performSelector:@selector(IMlogOut) withObject:nil afterDelay:0.3];
        }
    }];
}

- (void)LogOutChatRoomOnly{
    kWeakSelf(self);
    NSLog(@"推出 聊天室 中");
    [JMSGChatRoom leaveChatRoomWithRoomId:[ChatTool shareChatTool].basicConfig.main_room_id completionHandler:^(id resultObject, NSError *error) {
        if (!error) {
            NSLog(@"推出 聊天室成功");
            [self IMlogOut];
        }else{
            NSLog(@"推出 聊天室失败 %@",error.description);
            [weakself performSelector:@selector(LogOutChatRoomOnly) withObject:nil afterDelay:0.1];
        }
    }];
}



@end
