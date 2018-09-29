//
//  JCHATSendMessageViewController.m
//  JPush IM
//
//  Created by Apple on 14/12/26.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "JCHATConversationViewController.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "JCHATFileManager.h"
#import "JCHATShowTimeCell.h"
#import "MBProgressHUD+Add.h"
#import "UIImage+ResizeMagick.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <JMessage/JMSGConversation.h>
#import "JCHATStringUtils.h"
#import <UIKit/UIPrintInfo.h>
#import "JCHATLoadMessageTableViewCell.h"
#import "JCHATSendMsgManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "webAddIMVc.h"
#import "ChatRecordCell.h"
#import "mainTableVc.h"
#import "NSString+AES.h"
@interface JCHATConversationViewController ()<ChatToolJMSGMessageDelegate> {
@private
    NSMutableDictionary *_allMessageDic; //缓存所有的message model
    NSMutableArray *_allmessageIdArr; //按序缓存后有的messageId， 于allMessage 一起使用
}
@property(weak, nonatomic) UIButton *btn0;
@property(weak, nonatomic) UIButton *btn1;
@property(weak, nonatomic) UIButton *btn2;

@property(weak, nonatomic) UIButton *maskBtn;

@property(strong, nonatomic) webAddIMVc *CPwebVc;
@end


@implementation JCHATConversationViewController//change name chatcontroller

- (void)customBackButton
{
    if(self.navigationController.childViewControllers.count >1){
        UIImage* image = [[UIImage imageNamed:Navigation_bar_return_button] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem* leftBarutton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(popSelf)];
        self.navigationItem.leftBarButtonItem = leftBarutton;
    }
}
- (void)popSelf{
    if ([self.returnzhibojian isEqualToString:@"1"]) {
        [self.navigationController popViewControllerAnimated:NO];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.sendPng = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _allMessageDic = [NSMutableDictionary dictionary];
    _allmessageIdArr = [NSMutableArray array];

    DDLogDebug(@"Action - viewDidLoad");
    self.title = @"聊天室";
    [self setupComponentView];
    [self addNotification];
    self.moreViewBottomConstrait.constant = IMkTabBarHeight;
    self.view.backgroundColor= [UIColor whiteColor];
    [self addTwoView];
    

    if ([self.zhibojian isEqualToString:@"1"]) {
        [self zhibojianSet];
    }
    if (self.sendPng) {
        [self changePngForaddButton];
    }
    [self TipsInChatRoomConnection];
    
    [ChatTool shareChatTool].delegate = self;
    self.conversation = [ChatTool shareChatTool].conversation;
    self.moreViewContainer.hidden = YES;
}
#pragma  mark 聊天室连接成功之间添加蒙板
- (void)TipsInChatRoomConnection{
    if (!self.maskBtn) {
        UIButton *maskBtn = [UIButton new];
        maskBtn.backgroundColor = [UIColor clearColor];
        self.maskBtn = maskBtn;
        [self.view addSubview:maskBtn];
        [maskBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.toolBarContainer);
            make.right.equalTo(self.toolBarContainer);
            make.top.equalTo(self.toolBarContainer);
            make.bottom.equalTo(self.moreViewContainer);
        }];
        [maskBtn addTarget:self action:@selector(maskBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)maskBtnClick{
    if ([[ChatTool shareChatTool].basicConfig.main_room_forbidden isEqualToString:@"1"]) {
        [MBProgressHUD showPrompt:@"聊天室已经被全局禁言" toView:self.view];
    }else{
        self.maskBtn.tag = 4;
        [MBProgressHUD showPrompt:@"聊天室正在连接中，请稍候～" toView:self.view];
    }
}
- (void)setZhibojian:(NSString *)zhibojian{
    _zhibojian = zhibojian;
    if ([self.zhibojian isEqualToString:@"1"]) {
        [self zhibojianSet];
    }
}
- (void)zhibojianSet{
    self.sendPng = YES;
    self.toolBarContainer.toolbar.zhibojian = self.zhibojian;
    [self.messageTableView registerClass:[ChatRecordCell class] forCellReuseIdentifier:NSStringFromClass([ChatRecordCell class])];
    self.view.backgroundColor = [UIColor clearColor];
    self.messageTableView.backgroundColor = [UIColor clearColor];
    [self.messageTableView reloadData];
    self.btn1.hidden = YES;
    self.btn2.hidden = YES;
    self.toolBarContainer.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    self.toolBarContainer.toolbar.textView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    self.toolBarContainer.toolbar.voiceButton.userInteractionEnabled = NO;
    [self.toolBarContainer.toolbar.voiceButton setImage:[UIImage imageNamed:LIVECHATPNG] forState:UIControlStateNormal];
    [self.toolBarContainer.toolbar.voiceButton setImage:[UIImage imageNamed:LIVECHATPNG] forState:UIControlStateHighlighted];
    [self.toolBarContainer.toolbar.voiceButton setImage:[UIImage imageNamed:LIVECHATPNG] forState:UIControlStateSelected];

    if (self.sendPng) {
        [self changePngForaddButton];
    }
    
    if(self.toolBarContainer.toolbar.textView){
        self.toolBarContainer.toolbar.textView.placeHolder = @"说点什么吧...";
    }
}

- (void)changePngForaddButton{
    [self.toolBarContainer.toolbar.addButton setImage:[UIImage imageNamed:@"ic_send_24px"] forState:UIControlStateNormal];
    [self.toolBarContainer.toolbar.addButton setImage:[UIImage imageNamed:@"ic_send_24px"] forState:UIControlStateHighlighted];
    [self.toolBarContainer.toolbar.addButton setImage:[UIImage imageNamed:@"ic_send_24px"] forState:UIControlStateSelected];
}

- (void)addTwoView{

    
    UIButton *btn1 = [UIButton new];
    [self.view addSubview:btn1];
    self.btn1 = btn1;
    btn1.restorationIdentifier = IM_VIEW_money;
    [btn1 setImage:[UIImage imageNamed:IM_VIEW_money] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [UIButton new];
    self.btn2 = btn2;
    [self.view addSubview:btn2];
    btn2.restorationIdentifier = IM_VIEW_swith;
    [btn2 setImage:[UIImage imageNamed:IM_VIEW_swith] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if (self.gotoZhiBoVc) {
        UIButton *btn0 = [UIButton new];
        [self.view addSubview:btn0];
        self.btn0 = btn0;
        btn0.restorationIdentifier = zhiboAndWebVcPNG;
        [btn0 setImage:[UIImage imageNamed:zhiboAndWebVcPNG] forState:UIControlStateNormal];
        [btn0 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    CGFloat width = 40;
    
    if (self.gotoZhiBoVc) {
        [self.btn0 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view).offset(-15);
            make.bottom.equalTo(self.view).offset(-55-IMkTabBarHeight);
            make.height.equalTo(@(width));
            make.width.equalTo(@(width));
        }];
    }
    
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.gotoZhiBoVc) {
            make.right.equalTo(self.btn0);
            make.bottom.equalTo(self.btn0.mas_top).offset(-15);
        } else {
            make.right.equalTo(self.view).offset(-15);
            make.bottom.equalTo(self.view).offset(-55-IMkTabBarHeight);
        }
        make.height.equalTo(@(width));
        make.width.equalTo(@(width));
    }];
    
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(btn2);
        make.bottom.equalTo(btn2.mas_top).offset(-15);
        make.height.equalTo(@(width));
        make.width.equalTo(@(width));
    }];
}

- (void)btnClick:(UIButton *)btn{
    if ([btn.restorationIdentifier isEqualToString:IM_VIEW_money]) {
        NSString *url = [ChatTool shareChatTool].basicConfig.payfor_url;
        url = [url stringByAppendingString:[ChatTool shareChatTool].User.userID];
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
    }else if ([btn.restorationIdentifier isEqualToString:zhiboAndWebVcPNG]) {
        UIViewController *liveVc;
        for (UIViewController *tmp  in self.navigationController.childViewControllers) {
            if ([tmp isKindOfClass:[LiveBroadcastVc class]]) {
                liveVc = tmp;
                break;
            }
        }
        if (liveVc) {
            [self.navigationController popToViewController:liveVc animated:YES];
        } else {
            LBAnchorListModel *model =  [NSKeyedUnarchiver unarchiveObjectWithFile:PATH_OF_ZHUBO];
            if ([[ChatTool shareChatTool].basicConfig.isFree intValue]){
                NSString *expirationDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"expirationDate"];
                NSDateFormatter *format = [[NSDateFormatter alloc] init];
                format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                NSDate *oneData = [format dateFromString:expirationDate];
                NSString *type = [[NSUserDefaults standardUserDefaults] objectForKey:@"type"];
                
                if ([type isEqualToString:@"0"]){
                    [self joinMembership];
                    return;
                }else if([NSDate date].timeIntervalSince1970 >= oneData.timeIntervalSince1970){
                    [self RenewalFee];
                    return;
                }
            }
            NSLog(@"%@\n\n\n\n\n\nhhhhhhhhh",model.anchorLiveUrl);
            LiveBroadcastVc *vc =[LiveBroadcastVc new];
            vc.anchorLiveUrl = model.anchorLiveUrl;
            
            vc.anchorID = model.anchorID;
            vc.livePlatID = model.livePlatID;
            vc.iconUrl = model.anchorThumb;
            vc.nickname = model.anchorName;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    } else {
        if (!self.CPwebVc) {
            self.CPwebVc = [webAddIMVc new];
        }
        [self.navigationController pushViewController:self.CPwebVc animated:NO];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    DDLogDebug(@"Event - viewWillAppear");
    [super viewWillAppear:animated];
    [self.toolBarContainer.toolbar drawRect:self.toolBarContainer.toolbar.frame];
    if ([[ChatTool shareChatTool].basicConfig.main_room_forbidden isEqualToString:@"1"]) {
        self.maskBtn.hidden = NO;
    }else{
       self.maskBtn.hidden = YES;
    }

    if ([ChatTool shareChatTool].list.count) {
        [self cleanMessageCache];
        [self onReceiveChatRoomConversation:[ChatTool shareChatTool].conversation messages:[ChatTool shareChatTool].list];
    }
    [ChatTool shareChatTool].delegate = self;
    self.conversation = [ChatTool shareChatTool].conversation;
}

- (void)ChatToolonSendMessageResponse:(JMSGMessage *)message error:(NSError *)error{
    [self onSendMessageResponse:message error:error];
}

- (void)ChatToolonReceiveChatRoomConversation:(JMSGConversation *)conversation
                                     messages:(NSArray JMSG_GENERIC(__kindof JMSGMessage *)*)messages{
    [self onReceiveChatRoomConversation:conversation messages:messages];
}

- (void)ChatToolkJMSGNetworkSucces{
    self.conversation = [ChatTool shareChatTool].conversation;
    if ([[ChatTool shareChatTool].basicConfig.main_room_forbidden isEqualToString:@"1"]) {
        self.maskBtn.hidden = NO;
    }else{
        self.maskBtn.hidden = YES;
    }
    [self cleanMessageCache];
    [self onReceiveChatRoomConversation:[ChatTool shareChatTool].conversation messages:[ChatTool shareChatTool].list];
}

- (void)RefreshMessage{
    kWEAKSELF
    [_conversation refreshTargetInfoFromServer:^(id resultObject, NSError *error) {
        DDLogDebug(@"refresh nav right button");
        kSTRONGSELF
//        strongSelf.title = [resultObject title];
        [_messageTableView reloadData];
    }];
}

- (void)viewDidLayoutSubviews {
  DDLogDebug(@"Event - viewDidLayoutSubviews");
  [self scrollToBottomAnimated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
  DDLogDebug(@"Event - viewWillDisappear");
  [super viewWillDisappear:animated];
  [[JCHATAudioPlayerHelper shareInstance] stopAudio];

  [[JCHATAudioPlayerHelper shareInstance] setDelegate:nil];
}

#pragma mark --释放内存
- (void)dealloc {
    DDLogDebug(@"Action -- dealloc");
    //  [[NSNotificationCenter defaultCenter] removeObserver:self name:kAlertToSendImage object:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.toolBarContainer.toolbar.textView removeObserver:self forKeyPath:@"contentSize"];
    //remove delegate
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAlertToSendImage object:self];
//    [JMessage removeDelegate:self withConversation:_conversation];
    NSLog(@"dealloc CHatROOM\n\n\n\n\n\n\n\n");
}


- (void)addtoolbar {
  self.toolBarContainer.toolbar.frame = CGRectMake(0, 0, kApplicationWidth, 45);
  [self.toolBarContainer addSubview:self.toolBarContainer.toolbar];
}

- (void)setupComponentView {
  UITapGestureRecognizer *gesture =[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                           action:@selector(tapClick:)];
  [self.view addGestureRecognizer:gesture];
    
  [self.view setBackgroundColor:[UIColor clearColor]];
  _toolBarContainer.toolbar.delegate = self;
  [_toolBarContainer.toolbar setUserInteractionEnabled:YES];
  self.toolBarContainer.toolbar.textView.text = [[JCHATSendMsgManager ins] draftStringWithConversation:_conversation];
  _messageTableView.userInteractionEnabled = YES;
  _messageTableView.showsVerticalScrollIndicator = NO;
  _messageTableView.delegate = self;
  _messageTableView.dataSource = self;
  _messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  _messageTableView.backgroundColor = messageTableColor;
  
  _moreViewContainer.moreView.delegate = self;
//  _moreViewContainer.moreView.backgroundColor = messageTableColor;
}

- (void)isContantMeWithUserArr:(NSMutableArray *)userArr {
  BOOL hideFlag = YES;
  for (NSInteger i =0; i< [userArr count]; i++) {
    JMSGUser *user = [userArr objectAtIndex:i];
    if ([user.username isEqualToString:[JMSGUser myInfo].username]) {
      hideFlag = NO;
      break;
    }
  }
    if (!hideFlag) {
        [self reloadAllCellAvatarImage];
    }
  [self hidenDetailBtn:hideFlag];
}

- (void)hidenDetailBtn:(BOOL)flag {
//    [_rightBtn setHidden:flag];
}

- (void)setTitleWithUser:(JMSGUser *)user {
  self.title = _conversation.title;
}

#pragma mark --JMessageDelegate
- (void)onSendMessageResponse:(JMSGMessage *)message error:(NSError *)error {
  DDLogDebug(@"Event - sendMessageResponse");
  if (message != nil) {
    NSLog(@"发送的 Message:  %@",message);
  }
    [self relayoutTableCellWithMessage:message];
  
  if (error != nil) {
    DDLogDebug(@"Send response error - %@", error);
    [_conversation clearUnreadCount];
    NSString *alert = [JCHATStringUtils errorAlert:error];
    if (alert == nil) {
      alert = [error description];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showMessage:alert view:self.view];
    return;
  }
    [[ChatTool shareChatTool] addArry:@[message]];
  JCHATChatModel *model = _allMessageDic[message.msgId];
  if (!model) {
    return;
  }
}

#pragma mark --聊天室 收到消息
- (void)onReceiveChatRoomConversation:(JMSGConversation *)conversation
                             messages:(NSArray JMSG_GENERIC(__kindof JMSGMessage *)*)messages{
    for (JMSGMessage *message in messages) {
        JCHATChatModel *model = [_allMessageDic objectForKey:message.msgId];
        if (model) {// 说明已经加载，说明可能是同步下来的多媒体消息，下载完成，然后再次收到就去刷新
            model.message = message;
            [self refreshCellMessageMediaWithChatModel:model];
            NSLog(@"说明已经加载，说明可能是同步下来的多媒体消息，下载完成，然后再次收到就去刷新");
        }else{
            
            NSString *firstMsgId = [_allmessageIdArr firstObject];
            JCHATChatModel *firstModel = [_allMessageDic objectForKey:firstMsgId];
            if (message.timestamp < firstModel.message.timestamp) {
                // 比数组中最老的消息时间都小的，无需加入界面显示，下次翻页时会加载
                NSLog(@"比数组中最老的消息时间都小的，无需加入界面显示，下次翻页时会加载");
                return ;
            }
            if (!message) {
                NSLog(@"空的消息");
            }
            model = [[JCHATChatModel alloc] init];
            [model setChatModelWith:message conversationType:_conversation];
            
            [self addmessageShowTimeData:message.timestamp];
            [self addMessage:model];
            
            if (messages.count > 50) {
                NSLog(@"消息总数大于10");
//                [messages removeObjectAtIndex:0];
            }
//            [self chcekReceiveMessageAvatarWithReceiveNewMessage:message];
        }
    }
}


- (void)relayoutTableCellWithMessage:(JMSGMessage *) message{
    DDLogDebug(@"relayoutTableCellWithMessage: msgid:%@",message.msgId);
    if ([message.msgId isEqualToString:@""]) {
        return;
    }
    
    JCHATChatModel *model = _allMessageDic[message.msgId];
    if (model) {
        model.message = message;
        [_allMessageDic setObject:model forKey:message.msgId];
    }
    
    NSInteger index = [_allmessageIdArr indexOfObject:message.msgId];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    JCHATMessageTableViewCell *tableviewcell = [_messageTableView cellForRowAtIndexPath:indexPath];
    if ([tableviewcell isKindOfClass:[JCHATMessageTableViewCell class]]) {
        tableviewcell.model = model;
        [tableviewcell layoutAllView];
    }
    
//    [_messageTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
}
#pragma marks -- UIAlertViewDelegate --
//根据被点击按钮的索引处理点击事件
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == 0) {

  }
}
#pragma mark --获取对应消息的索引
- (NSInteger )getIndexWithMessageId:(NSString *)messageID {
  for (NSInteger i=0; i< [_allmessageIdArr count]; i++) {
    NSString *getMessageID = _allmessageIdArr[i];
    if ([getMessageID isEqualToString:messageID]) {
      return i;
    }
  }
  return 0;
}

- (bool)checkDevice:(NSString *)name {
  NSString *deviceType = [UIDevice currentDevice].model;
  DDLogDebug(@"deviceType = %@", deviceType);
  NSRange range = [deviceType rangeOfString:name];
  return range.location != NSNotFound;
}

#pragma mark -- 清空消息缓存
- (void)cleanMessageCache {
  [_allMessageDic removeAllObjects];
  [_allmessageIdArr removeAllObjects];
  [self.messageTableView reloadData];
}

#pragma mark --添加message
- (void)addMessage:(JCHATChatModel *)model {
  if (model.isTime) {
    [_allMessageDic setObject:model forKey:model.timeId];
    [_allmessageIdArr addObject:model.timeId];
    [self addCellToTabel];
    return;
  }
    [_allMessageDic setObject:model forKey:model.message.msgId];
    [_allmessageIdArr addObject:model.message.msgId];
    [self addCellToTabel];
}

NSInteger sortMessageType(id object1,id object2,void *cha) {
  JMSGMessage *message1 = (JMSGMessage *)object1;
  JMSGMessage *message2 = (JMSGMessage *)object2;
  if([message1.timestamp integerValue] > [message2.timestamp integerValue]) {
    return NSOrderedDescending;
  } else if([message1.timestamp integerValue] < [message2.timestamp integerValue]) {
    return NSOrderedAscending;
  }
  return NSOrderedSame;
}

- (void)AlertToSendImage:(NSNotification *)notification {
  UIImage *img = notification.object;
  [self prepareImageMessage:img];
}

#pragma mark --排序conversation
- (NSMutableArray *)sortMessage:(NSMutableArray *)messageArr {
  NSArray *sortResultArr = [messageArr sortedArrayUsingFunction:sortMessageType context:nil];
  return [NSMutableArray arrayWithArray:sortResultArr];
}

- (XHVoiceRecordHelper *)voiceRecordHelper {
  if (!_voiceRecordHelper) {
    WEAKSELF
    _voiceRecordHelper = [[XHVoiceRecordHelper alloc] init];
    
    _voiceRecordHelper.maxTimeStopRecorderCompletion = ^{
      DDLogDebug(@"已经达到最大限制时间了，进入下一步的提示");
      __strong __typeof(weakSelf)strongSelf = weakSelf;
      [strongSelf finishRecorded];
    };
    
    _voiceRecordHelper.peakPowerForChannel = ^(float peakPowerForChannel) {
      __strong __typeof(weakSelf)strongSelf = weakSelf;
      strongSelf.voiceRecordHUD.peakPower = peakPowerForChannel;
    };
    
    _voiceRecordHelper.maxRecordTime = kVoiceRecorderTotalTime;
  }
  return _voiceRecordHelper;
}

- (XHVoiceRecordHUD *)voiceRecordHUD {
  if (!_voiceRecordHUD) {
    _voiceRecordHUD = [[XHVoiceRecordHUD alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
  }
  return _voiceRecordHUD;
}

- (void)backClick {
  if ([[JCHATAudioPlayerHelper shareInstance] isPlaying]) {
    [[JCHATAudioPlayerHelper shareInstance] stopAudio];
  }
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)pressVoiceBtnToHideKeyBoard {///!!!
  [self.toolBarContainer.toolbar.textView resignFirstResponder];
  _toolBarHeightConstrait.constant = 45;
  [self dropToolBar];
}

- (void)switchToTextInputMode {
//  UITextField *inputview = self.toolBarContainer.toolbar.textView;
//  [inputview becomeFirstResponder];
//  [self layoutAndAnimateMessageInputTextView:inputview];
}

#pragma mark -调用相册
- (void)photoClick {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"chat_image_open"] isEqualToString:@"1"]) {
        ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
        [lib enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            JCHATPhotoPickerViewController *photoPickerVC = [[JCHATPhotoPickerViewController alloc] init];
            photoPickerVC.photoDelegate = self;
            [self presentViewController:photoPickerVC animated:YES completion:NULL];
        } failureBlock:^(NSError *error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"没有相册权限" message:@"请到设置页面获取相册权限" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }];
    } else {
        [MBProgressHUD showError:@"您暂时没有权限发图" toView:self.view];
    }
}

#pragma mark --调用相机
- (void)cameraClick {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"chat_image_open"] isEqualToString:@"1"]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            NSString *requiredMediaType = ( NSString *)kUTTypeImage;
            NSArray *arrMediaTypes=[NSArray arrayWithObjects:requiredMediaType,nil];
            [picker setMediaTypes:arrMediaTypes];
            picker.showsCameraControls = YES;
            picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            picker.editing = YES;
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:nil];
        }
    } else {
        [MBProgressHUD showError:@"您暂时没有权限发图" toView:self.view];
    }
}

#pragma mark - ZYQAssetPickerController Delegate
//-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
//  for (int i=0; i<assets.count; i++) {
//    ALAsset *asset=assets[i];
//    UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
//    [self prepareImageMessage:tempImg];
//    [self dropToolBarNoAnimate];
//  }
//}
#pragma mark - HMPhotoPickerViewController Delegate
- (void)JCHATPhotoPickerViewController:(JCHATPhotoSelectViewController *)PhotoPickerVC selectedPhotoArray:(NSArray *)selected_photo_array {
  for (UIImage *image in selected_photo_array) {
    [self prepareImageMessage:image];
  }
  [self dropToolBarNoAnimate];
}
#pragma mark - UIImagePickerController Delegate
//相机,相册Finish的代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
  
  if ([mediaType isEqualToString:@"public.movie"]) {
    [self dismissViewControllerAnimated:YES completion:nil];
    [MBProgressHUD showMessage:@"不支持视频发送" view:self.view];
    return;
  }
  UIImage *image;
  image = [info objectForKey:UIImagePickerControllerOriginalImage];
  [self prepareImageMessage:image];
  [self dropToolBarNoAnimate];
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --发送图片
//- (void)prepareImageMessage:(UIImage *)img {
//  DDLogDebug(@"Action - prepareImageMessage");
//  img = [img resizedImageByWidth:upLoadImgWidth];
//
//  JMSGMessage* message = nil;
//  JCHATChatModel *model = [[JCHATChatModel alloc] init];
//  JMSGImageContent *imageContent = [[JMSGImageContent alloc] initWithImageData:UIImagePNGRepresentation(img)];
//  if (imageContent) {
//    message = [_conversation createMessageWithContent:imageContent];
//    [[JCHATSendMsgManager ins] addMessage:message withConversation:_conversation];
//    [self addmessageShowTimeData:message.timestamp];
//    [model setChatModelWith:message conversationType:_conversation];
//    [_imgDataArr addObject:model];
//    model.photoIndex = [_imgDataArr count] - 1;
//    [model setupImageSize];
//    [self addMessage:model];
//  }
//}

#pragma mark --
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
  [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --加载通知
- (void)addNotification{
  //给键盘注册通知
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(inputKeyboardWillShow:)
   
                                               name:UIKeyboardWillShowNotification
                                             object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(inputKeyboardWillHide:)
                                               name:UIKeyboardWillHideNotification
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(cleanMessageCache)
                                               name:kDeleteAllMessage
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(AlertToSendImage:)
                                               name:kAlertToSendImage
                                             object:nil];


  [self.toolBarContainer.toolbar.textView addObserver:self
                                           forKeyPath:@"contentSize"
                                              options:NSKeyValueObservingOptionNew
                                              context:nil];
  self.toolBarContainer.toolbar.textView.delegate = self;
}

- (void)inputKeyboardWillShow:(NSNotification *)notification{
  _barBottomFlag=NO;
  CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
  CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
  
  [UIView animateWithDuration:animationTime animations:^{
      if ([self.zhibojian isEqualToString:@"1"]) {
          _moreViewHeight.constant = keyBoardFrame.size.height-kTabBarHeight-30;
      } else {
          _moreViewHeight.constant = keyBoardFrame.size.height-kTabBarHeight;
      }
    [self.view layoutIfNeeded];
  }];
  [self scrollToEnd];//!
    
    if([self.zhibojian isEqualToString:@"1"]){
        self.toolBarContainer.toolbar.textView.placeHolderTextColor = [UIColor whiteColor];
        self.toolBarContainer.toolbar.textView.placeHolder = nil;
    }
}

- (void)inputKeyboardWillHide:(NSNotification *)notification {
    
    
    
  CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    kWEAKSELF
  [UIView animateWithDuration:animationTime animations:^{
    _moreViewHeight.constant = 0;
    [weakSelf.view layoutIfNeeded];
  }];
  [self scrollToBottomAnimated:NO];
    if([self.zhibojian isEqualToString:@"1"]){

        
        self.toolBarContainer.toolbar.textView.placeHolderTextColor = [UIColor whiteColor];
        self.toolBarContainer.toolbar.textView.placeHolder = @"说点什么吧...";
    }
}
#pragma mark --发送文本
- (void)sendText:(NSString *)text {
    if ([[ChatTool shareChatTool].basicConfig.main_room_forbidden isEqualToString:@"0"]) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"chat_forbidden"] isEqualToString:@"0"]) {
            [self prepareTextMessage:text];
        } else {
            [MBProgressHUD showError:@"您已经被禁言！" toView:self.view];
        }
    }else{
        [MBProgressHUD showError:@"聊天室已经被全局禁言！" toView:self.view];
    }
    if ([self.zhibojian isEqualToString:@"1"]) {
        [self.toolBarContainer.toolbar.textView resignFirstResponder];
    }
}

- (void)perform {
  _moreViewHeight.constant = 0;
  _toolBarToBottomConstrait.constant = 0;
}

#pragma mark --返回下面的位置
- (void)dropToolBar {
  _barBottomFlag =YES;
  _previousTextViewContentHeight = 31;
  _toolBarContainer.toolbar.addButton.selected = NO;
  [_messageTableView reloadData];
  [UIView animateWithDuration:0.3 animations:^{
    _toolBarToBottomConstrait.constant = 0;
    _moreViewHeight.constant = 0;
  }];
}

- (void)dropToolBarNoAnimate {
  _barBottomFlag =YES;
  _previousTextViewContentHeight = 31;
  _toolBarContainer.toolbar.addButton.selected = NO;
  [_messageTableView reloadData];
  _toolBarToBottomConstrait.constant = 0;
  _moreViewHeight.constant = 0;
}

#pragma mark --按下功能响应
- (void)pressMoreBtnClick:(UIButton *)btn {
    if (self.sendPng) {
        if (self.toolBarContainer.toolbar.textView.text) {
            [self sendText:self.toolBarContainer.toolbar.textView.text];
            self.toolBarContainer.toolbar.textView.text = nil;
        }
    } else {
        _barBottomFlag=NO;
        [_toolBarContainer.toolbar.textView resignFirstResponder];
        
        _toolBarToBottomConstrait.constant = 0;
        _moreViewHeight.constant = 227*0.5;
        [_messageTableView setNeedsDisplay];
        [_moreViewContainer setNeedsLayout];
        [_toolBarContainer setNeedsLayout];
        [UIView animateWithDuration:0.25 animations:^{
            _toolBarToBottomConstrait.constant = 0;
            _moreViewHeight.constant = 227*0.5;
            [_messageTableView layoutIfNeeded];
            [_toolBarContainer layoutIfNeeded];
            [_moreViewContainer layoutIfNeeded];
        }];
        [_toolBarContainer.toolbar switchToolbarToTextMode];
        [self scrollToBottomAnimated:NO];
    }
}

- (void)noPressmoreBtnClick:(UIButton *)btn {
  [_toolBarContainer.toolbar.textView becomeFirstResponder];
}

#pragma mark ----发送文本消息
- (void)prepareTextMessage:(NSString *)text {
    
    DDLogDebug(@"Action - prepareTextMessage");
    if ([text isEqualToString:@""] || text == nil) {
        return;
    }
    
    text = [text aci_encryptWithAES];
    
    [[JCHATSendMsgManager ins] updateConversation:_conversation withDraft:@""];
    JMSGMessage *message = nil;
    JMSGTextContent *textContent = [[JMSGTextContent alloc] initWithText:text];
    JCHATChatModel *model = [[JCHATChatModel alloc] init];
    
    message = [_conversation createMessageWithContent:textContent];//!
    
    [_conversation sendMessage:message];
    
    [self addmessageShowTimeData:message.timestamp];
    [model setChatModelWith:message conversationType:_conversation];
    [self addMessage:model];
}

#pragma mark -- 刷新对应的
- (void)addCellToTabel {
  NSIndexPath *path = [NSIndexPath indexPathForRow:[_allmessageIdArr count]-1 inSection:0];
  [_messageTableView beginUpdates];
  [_messageTableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
  [_messageTableView endUpdates];
  [self scrollToEnd];
}

#pragma mark ---比较和上一条消息时间超过5分钟之内增加时间model
- (void)addmessageShowTimeData:(NSNumber *)timeNumber{
  NSString *messageId = [_allmessageIdArr lastObject];
  JCHATChatModel *lastModel = _allMessageDic[messageId];
  NSTimeInterval timeInterVal = [timeNumber longLongValue];
    
  if ([_allmessageIdArr count] > 0 && lastModel.isTime == NO) {
      
    NSDate* lastdate = [NSDate dateWithTimeIntervalSince1970:[lastModel.messageTime longLongValue]/1000];
    NSDate* currentDate = [NSDate dateWithTimeIntervalSince1970:timeInterVal/1000];
    NSTimeInterval timeBetween = [currentDate timeIntervalSinceDate:lastdate];
    if (fabs(timeBetween) > interval) {
      [self addTimeData:timeInterVal];
    }
  } else if ([_allmessageIdArr count] == 0) {//首条消息显示时间
    [self addTimeData:timeInterVal];
  } else {
    DDLogDebug(@"不用显示时间");
  }
}

#pragma mark ---比较和上一条消息时间超过5分钟之内增加时间model
- (void)dataMessageShowTime:(NSNumber *)timeNumber{
  NSString *messageId = [_allmessageIdArr lastObject];
  JCHATChatModel *lastModel = _allMessageDic[messageId];
  NSTimeInterval timeInterVal = [timeNumber longLongValue];
    
  if ([_allmessageIdArr count]>0 && lastModel.isTime == NO) {
    NSDate* lastdate = [NSDate dateWithTimeIntervalSince1970:[lastModel.messageTime longLongValue]/1000];
    NSDate* currentDate = [NSDate dateWithTimeIntervalSince1970:timeInterVal/1000];
    NSTimeInterval timeBetween = [currentDate timeIntervalSinceDate:lastdate];
    if (fabs(timeBetween) > interval) {
      JCHATChatModel *timeModel =[[JCHATChatModel alloc] init];
      timeModel.timeId = [self getTimeId];
      timeModel.isTime = YES;
      timeModel.messageTime = @(timeInterVal);
      timeModel.contentHeight = [timeModel getTextHeight];//!
      [_allMessageDic setObject:timeModel forKey:timeModel.timeId];
      [_allmessageIdArr addObject:timeModel.timeId];
    }
  } else if ([_allmessageIdArr count] ==0) {//首条消息显示时间
    JCHATChatModel *timeModel =[[JCHATChatModel alloc] init];
    timeModel.timeId = [self getTimeId];
    timeModel.isTime = YES;
    timeModel.messageTime = @(timeInterVal);
    timeModel.contentHeight = [timeModel getTextHeight];//!
    [_allMessageDic setObject:timeModel forKey:timeModel.timeId];
    [_allmessageIdArr addObject:timeModel.timeId];
  } else {
    DDLogDebug(@"不用显示时间");
  }
}

- (void)dataMessageShowTimeToTop:(NSNumber *)timeNumber{
  NSString *messageId = [_allmessageIdArr lastObject];
  JCHATChatModel *lastModel = _allMessageDic[messageId];
  NSTimeInterval timeInterVal = [timeNumber longLongValue];
  if ([_allmessageIdArr count]>0 && lastModel.isTime == NO) {
    NSDate* lastdate = [NSDate dateWithTimeIntervalSince1970:[lastModel.messageTime doubleValue]];
    NSDate* currentDate = [NSDate dateWithTimeIntervalSince1970:timeInterVal];
    NSTimeInterval timeBetween = [currentDate timeIntervalSinceDate:lastdate];
    if (fabs(timeBetween) > interval) {
      JCHATChatModel *timeModel =[[JCHATChatModel alloc] init];
      timeModel.timeId = [self getTimeId];
      timeModel.isTime = YES;
      timeModel.messageTime = @(timeInterVal);
      timeModel.contentHeight = [timeModel getTextHeight];
      [_allMessageDic setObject:timeModel forKey:timeModel.timeId];
      [_allmessageIdArr insertObject:timeModel.timeId atIndex:1];
    }
  } else if ([_allmessageIdArr count] ==0) {//首条消息显示时间
    JCHATChatModel *timeModel =[[JCHATChatModel alloc] init];
    timeModel.timeId = [self getTimeId];
    timeModel.isTime = YES;
    timeModel.messageTime = @(timeInterVal);
    timeModel.contentHeight = [timeModel getTextHeight];
    [_allMessageDic setObject:timeModel forKey:timeModel.timeId];
    [_allmessageIdArr insertObject:timeModel.timeId atIndex:1];
  } else {
    DDLogDebug(@"不用显示时间");
  }
}

- (void)addTimeData:(NSTimeInterval)timeInterVal {
  JCHATChatModel *timeModel =[[JCHATChatModel alloc] init];
  timeModel.timeId = [self getTimeId];
  timeModel.isTime = YES;
  timeModel.messageTime = @(timeInterVal);
  timeModel.contentHeight = [timeModel getTextHeight];//!
  [self addMessage:timeModel];
}

- (NSString *)getTimeId {
  NSString *timeId = [NSString stringWithFormat:@"%d",arc4random()%1000000];
  return timeId;
}


- (void)tapClick:(UIGestureRecognizer *)gesture {
    [self.toolBarContainer.toolbar.textView resignFirstResponder];
    [self dropToolBar];
}

#pragma mark --滑动至尾端
- (void)scrollToEnd {
  if ([_allmessageIdArr count] != 0) {
    [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_allmessageIdArr count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
  }
}

#pragma mark - tableView datasoce
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.zhibojian isEqualToString:@"1"]) {
        NSString *messageId = _allmessageIdArr[indexPath.row];
        JCHATChatModel *model = _allMessageDic[messageId];
        if(!model.isTime && model.message.contentType == kJMSGContentTypeText){
            return 25.0f;
        }else{
            return 0.0;
        }
    } else {
        if (indexPath.row >= _allmessageIdArr.count) {
            DDLogDebug(@"1.index %ld beyond bounds %ld",indexPath.row,_allmessageIdArr.count);
            return 40;
        }
        NSString *messageId = _allmessageIdArr[indexPath.row];
        JCHATChatModel *model = _allMessageDic[messageId];
        if (model.isTime == YES) {
            return 31;
        }
        
        if (model.message.contentType == kJMSGContentTypeEventNotification) {
            return model.contentHeight + 17;
        }
        
        if (model.message.contentType == kJMSGContentTypeText) {
            if (model.message.isReceived) {
                return model.contentHeight + 17 + heightUserName;
            } else {
                return model.contentHeight + 17;
            }
        } else if (model.message.contentType == kJMSGContentTypeImage ||
                   model.message.contentType == kJMSGContentTypeFile ||
                   model.message.contentType == kJMSGContentTypeLocation) {
            if (model.imageSize.height == 0) {
                [model setupImageSize];
            }
            if (model.message.isReceived) {
                return model.imageSize.height < 44?59+heightUserName:model.imageSize.height + 14 + heightUserName;
            } else {
                return model.imageSize.height < 44?59:model.imageSize.height + 14;
            }
        } else if (model.message.contentType == kJMSGContentTypeVoice) {
            return 69;
        }
//        else if (model.message.contentType == kJMSGContentTypeUnknown) {
//            return 0.0;
//        }
        else {
            return 49;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [ChatTool shareChatTool].TotalMessages;
  return [_allmessageIdArr count];
}
- (void)configureChatRecordCell:(ChatRecordCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= _allmessageIdArr.count) {
        DDLogDebug(@"2.index %ld beyond bounds %ld",indexPath.row,_allmessageIdArr.count);
        return ;
    }
    NSString *messageId = _allmessageIdArr[indexPath.row];
    if (!messageId) {
        DDLogDebug(@"messageId is nil%@",messageId);
        return ;
    }
    
    JCHATChatModel *model = _allMessageDic[messageId];
    if (!model) {
        DDLogDebug(@"JCHATChatModel is nil%@", messageId);
        return ;
    }
    cell.oneMsg = model.message;
    cell.model = model;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.zhibojian isEqualToString:@"1"]) {
        NSString *messageId = _allmessageIdArr[indexPath.row];
        JCHATChatModel *model = _allMessageDic[messageId];
//        if(!model.isTime && model.message.contentType == kJMSGContentTypeText){
            ChatRecordCell *cell = [ChatRecordCell returnCellWith:tableView];
            [self configureChatRecordCell:cell atIndexPath:indexPath];
            return  cell;
            
//        }else{
//            static NSString *cellIdentifier = @"UITableViewCell";
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//            if (cell == nil) {
//                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//            }
//            return cell;
//        }
    } else {
        if (indexPath.row >= _allmessageIdArr.count) {
            DDLogDebug(@"2.index %ld beyond bounds %ld",indexPath.row,_allmessageIdArr.count);
            return nil;
        }
        NSString *messageId = _allmessageIdArr[indexPath.row];
        if (!messageId) {
            DDLogDebug(@"messageId is nil%@",messageId);
            return nil;
        }
        
        JCHATChatModel *model = _allMessageDic[messageId];
        if (!model) {
            DDLogDebug(@"JCHATChatModel is nil%@", messageId);
            return nil;
        }
        
        if (model.isTime == YES || model.message.contentType == kJMSGContentTypeEventNotification || model.isErrorMessage) {
            static NSString *cellIdentifier = @"timeCell";
            JCHATShowTimeCell *cell = (JCHATShowTimeCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"JCHATShowTimeCell" owner:nil options:nil] lastObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            if (model.isErrorMessage) {
                cell.messageTimeLabel.text = [NSString stringWithFormat:@"%@ 错误码:%ld",st_receiveErrorMessageDes,model.messageError.code];
                return cell;
            }
            
            if (model.message.contentType == kJMSGContentTypeEventNotification) {
                cell.messageTimeLabel.text = [((JMSGEventContent *)model.message.content) showEventNotification];
            } else {
                cell.messageTimeLabel.text = [JCHATStringUtils getFriendlyDateString:[model.messageTime longLongValue]];
            }
            return cell;
        }
//        else if (model.message.contentType == kJMSGContentTypeUnknown) {
//            static NSString *cellIdentifier = @"UITableViewCell";
//            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//            if (cell == nil) {
//                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//            }
//            return cell;
//        }
        else {
            static NSString *cellIdentifier = @"MessageCell";
            JCHATMessageTableViewCell *cell = (JCHATMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (cell == nil) {
                cell = [[JCHATMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                cell.conversation = _conversation;
            }
            
            [cell setCellData:model delegate:self indexPath:indexPath];
            
//            kWEAKSELF
//            cell.messageTableViewCellRefreshMediaMessage = ^(JCHATChatModel *cellModel,BOOL isShouldRefresh){
//                if (isShouldRefresh) {
//                    [weakSelf refreshCellMessageMediaWithChatModel:cellModel];
//                }
//            };
            return cell;
        }
    }
}

#pragma mark - 检查并刷新消息图片图片
- (void)refreshCellMessageMediaWithChatModel:(JCHATChatModel *)model {
    DDLogDebug(@"Action - refreshCellMessageMediaWithChatModel:");
    
    if (!model) {
        return ;
    }
    if (!model.message || ![self.conversation isMessageForThisConversation:model.message]) {
        return ;
    }
    NSString *msgId = model.message.msgId;
    JMSGMessage *db_message = [self.conversation messageWithMessageId:msgId];
    if (!db_message || !db_message.msgId) {
        return ;
    }
    
    model.message = db_message;
    [_allMessageDic setObject:model forKey:model.message.msgId];
}
#pragma mark - 检查并刷新头像
- (void)chcekReceiveMessageAvatarWithReceiveNewMessage:(JMSGMessage *)message {
    DDLogDebug(@"chcekReceiveMessageAvatarWithReceiveNewMessage:%@",message.serverMessageId);
    if (!message || !message.fromUser) {
        return ;
    }
    
    JMSGMessage *lastMessage = message;
    JMSGUser *fromUser = lastMessage.fromUser;
    [fromUser thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
        if (error == nil && [objectId isEqualToString:fromUser.username]) {
            if (data != nil) {
                NSUInteger lenght = data.length;
                [self refreshVisibleRowsAvatarWithNewMessage:lastMessage avatarDataLength:lenght];
            }
        }
    }];
}

- (void)refreshVisibleRowsAvatarWithNewMessage:(JMSGMessage *)message avatarDataLength:(NSUInteger)length {
    
    DDLogDebug(@"refreshVisibleRowsAvatarWithNewMessage::%@",message.serverMessageId);
    
    NSString *username_appkey = [NSString stringWithFormat:@"%@_%@",message.fromUser.username,message.fromUser.appKey];
    NSString *msgId = message.msgId;
    
    NSArray *indexPaths = [[_messageTableView indexPathsForVisibleRows] mutableCopy];
    NSMutableArray *reloadIndexPaths = [NSMutableArray array];
    for (int i = 0; i < indexPaths.count; i++) {
        NSIndexPath *indexPath = indexPaths[i];
        JCHATChatModel *cellModel;
        if ([self.zhibojian isEqualToString:@"1"]) {
            ChatRecordCell *cell = [_messageTableView cellForRowAtIndexPath:indexPath];
            if ([cell isKindOfClass:[ChatRecordCell class]]) {
                cellModel = cell.model;
            }
        } else {
            JCHATMessageTableViewCell *cell = [_messageTableView cellForRowAtIndexPath:indexPath];
            if([cell isKindOfClass:[JCHATMessageTableViewCell class]]){
                cellModel = cell.model;
            }
        }
        JMSGUser *cellUser = cellModel.message.fromUser;
        NSString *key = [NSString stringWithFormat:@"%@_%@",cellUser.username,cellUser.appKey];
        
        if (![username_appkey isEqualToString:key]) {
            continue ;
        }
        if (cellModel.avatarDataLength != length) {
            JMSGMessage *dbMessage = [self.conversation messageWithMessageId:msgId];
            JCHATChatModel *model = [_allMessageDic objectForKey:msgId];
            model.message = dbMessage;
            [_allMessageDic setObject:model forKey:msgId];
            [reloadIndexPaths addObject:indexPath];
        }
    }
    
    if (reloadIndexPaths.count > 0) {
        [_messageTableView reloadRowsAtIndexPaths:reloadIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)reloadAllCellAvatarImage {
    DDLogDebug(@"Action -reloadAllCellAvatarImage");
    
    for (int i = 0; i < _allmessageIdArr.count; i++) {
        NSString *msgid = [_allmessageIdArr objectAtIndex:i];
        JCHATChatModel *model = [_allMessageDic objectForKey:msgid];
        if (model.message.isReceived && !model.message.fromUser.avatar) {
            JMSGMessage *message = [self.conversation messageWithMessageId:msgid];
            model.message = message;
            [_allMessageDic setObject:model forKey:msgid];
        }
    }
    
    NSArray *cellArray = [_messageTableView visibleCells];
    for (id temp in cellArray) {
        if ([temp isKindOfClass:[JCHATMessageTableViewCell class]]) {
            JCHATMessageTableViewCell *cell = (JCHATMessageTableViewCell *)temp;
            if (cell.model.message.isReceived) {
                [cell reloadAvatarImage];
            }
        }
    }
}

#pragma mark -PlayVoiceDelegate

- (void)successionalPlayVoice:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
  if ([_allmessageIdArr count] - 1 > indexPath.row) {
    NSString *messageId = _allmessageIdArr[indexPath.row + 1];
    JCHATChatModel *model = _allMessageDic[ messageId];
    
    if (model.message.contentType == kJMSGContentTypeVoice && model.message.flag) {
      JCHATMessageTableViewCell *voiceCell =(JCHATMessageTableViewCell *)[self.messageTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
      [voiceCell playVoice];
    }
  }
}

- (void)setMessageIDWithMessage:(JMSGMessage *)message chatModel:(JCHATChatModel * __strong *)chatModel index:(NSInteger)index {
  [_allMessageDic removeObjectForKey:(*chatModel).message.msgId];
  [_allMessageDic setObject:*chatModel forKey:message.msgId];
  
  if ([_allmessageIdArr count] > index) {
    [_allmessageIdArr removeObjectAtIndex:index];
    [_allmessageIdArr insertObject:message.msgId atIndex:index];
  }
}


#pragma mark -连续播放语音
- (void)getContinuePlay:(UITableViewCell *)cell
              indexPath:(NSIndexPath *)indexPath {
  JCHATMessageTableViewCell *tempCell = (JCHATMessageTableViewCell *) cell;
  if ([_allmessageIdArr count] - 1 > indexPath.row) {
    NSString *messageId = _allmessageIdArr[indexPath.row + 1];
    JCHATChatModel *model = _allMessageDic[ messageId];
    if (model.message.contentType == kJMSGContentTypeVoice && [model.message.flag isEqualToNumber:@(0)] && [model.message isReceived]) {
      if ([[JCHATAudioPlayerHelper shareInstance] isPlaying]) {
        tempCell.continuePlayer = YES;
      }else {
        tempCell.continuePlayer = NO;
      }
    }
  }
}

#pragma mark 预览图片 PictureDelegate
//PictureDelegate
//- (void)tapPicture:(NSIndexPath *)index tapView:(UIImageView *)tapView tableViewCell:(UITableViewCell *)tableViewCell {
//  [self.toolBarContainer.toolbar.textView resignFirstResponder];
//  JCHATMessageTableViewCell *cell =(JCHATMessageTableViewCell *)tableViewCell;
//  NSInteger count = _imgDataArr.count;
//  NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
//  for (int i = 0; i<count; i++) {
//    JCHATChatModel *messageObject = [_imgDataArr objectAtIndex:i];
//    MJPhoto *photo = [[MJPhoto alloc] init];
//    photo.message = messageObject;
//    photo.srcImageView = tapView; // 来源于哪个UIImageView
//    [photos addObject:photo];
//  }
//  MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
//  browser.currentPhotoIndex = [_imgDataArr indexOfObject:cell.model];
////  browser.currentPhotoIndex = cell.model.photoIndex; // 弹出相册时显示的第一张图片是？
//  browser.photos = photos; // 设置所有的图片
//  browser.conversation =_conversation;
//  [browser show];
//}

#pragma mark --获取所有发送消息图片
- (NSArray *)getAllMessagePhotoImg {
  NSMutableArray *urlArr =[NSMutableArray array];
  for (NSInteger i=0; i<[_allmessageIdArr count]; i++) {
    NSString *messageId = _allmessageIdArr[i];
    JCHATChatModel *model = _allMessageDic[messageId];
    if (model.message.contentType == kJMSGContentTypeImage) {
      [urlArr addObject:((JMSGImageContent *)model.message.content)];
    }
  }
  return urlArr;
}
#pragma mark SendMessageDelegate

- (void)didStartRecordingVoiceAction {
    if ([self.zhibojian isEqualToString:@"1"]) {
        
    } else {
        DDLogVerbose(@"Action - didStartRecordingVoice");
        [self startRecord];
    }
}

- (void)didCancelRecordingVoiceAction {
  DDLogVerbose(@"Action - didCancelRecordingVoice");
  [self cancelRecord];
}

- (void)didFinishRecordingVoiceAction {
  DDLogVerbose(@"Action - didFinishRecordingVoiceAction");
  [self finishRecorded];
}

- (void)didDragOutsideAction {
  DDLogVerbose(@"Action - didDragOutsideAction");
  [self resumeRecord];
}

- (void)didDragInsideAction {
  DDLogVerbose(@"Action - didDragInsideAction");
  [self pauseRecord];
}

- (void)pauseRecord {
  [self.voiceRecordHUD pauseRecord];
}

- (void)resumeRecord {
  [self.voiceRecordHUD resaueRecord];
}

- (void)cancelRecord {
  WEAKSELF
  [self.voiceRecordHUD cancelRecordCompled:^(BOOL fnished) {
    __strong __typeof(weakSelf)strongSelf = weakSelf;
    strongSelf.voiceRecordHUD = nil;
  }];
  [self.voiceRecordHelper cancelledDeleteWithCompletion:^{
    
  }];
}

#pragma mark - Voice Recording Helper Method
- (void)startRecord {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"chat_forbidden"] isEqualToString:@"0"]) {
        DDLogDebug(@"Action - startRecord");
        [self.voiceRecordHUD startRecordingHUDAtView:self.view];
        [self.voiceRecordHelper startRecordingWithPath:[self getRecorderPath] StartRecorderCompletion:^{
        }];
    } else {
        [MBProgressHUD showError:@"您已经被禁言！" toView:self.view];
    }
}

- (void)finishRecorded {
  DDLogDebug(@"Action - finishRecorded");
  WEAKSELF
  [self.voiceRecordHUD stopRecordCompled:^(BOOL fnished) {
    __strong __typeof(weakSelf)strongSelf = weakSelf;
    strongSelf.voiceRecordHUD = nil;
  }];
  [self.voiceRecordHelper stopRecordingWithStopRecorderCompletion:^{
    __strong __typeof(weakSelf)strongSelf = weakSelf;
    [strongSelf SendMessageWithVoice:strongSelf.voiceRecordHelper.recordPath
                       voiceDuration:strongSelf.voiceRecordHelper.recordDuration];
  }];
}

#pragma mark - Message Send helper Method
#pragma mark --发送语音
- (void)SendMessageWithVoice:(NSString *)voicePath
               voiceDuration:(NSString*)voiceDuration {
  DDLogDebug(@"Action - SendMessageWithVoice");
  
  if ([voiceDuration integerValue]<0.5 || [voiceDuration integerValue]>60) {
    if ([voiceDuration integerValue]<0.5) {
      DDLogDebug(@"录音时长小于 0.5s");
    } else {
      DDLogDebug(@"录音时长大于 60s");
    }
    return;
  }
  
  JMSGMessage *voiceMessage = nil;
  JCHATChatModel *model =[[JCHATChatModel alloc] init];
  JMSGVoiceContent *voiceContent = [[JMSGVoiceContent alloc] initWithVoiceData:[NSData dataWithContentsOfFile:voicePath]
                                                                 voiceDuration:[NSNumber numberWithInteger:[voiceDuration integerValue]]];
  
  voiceMessage = [_conversation createMessageWithContent:voiceContent];
  [_conversation sendMessage:voiceMessage];
  [model setChatModelWith:voiceMessage conversationType:_conversation];
  [JCHATFileManager deleteFile:voicePath];
  [self addMessage:model];
}

#pragma mark - RecorderPath Helper Method
- (NSString *)getRecorderPath {
  NSString *recorderPath = nil;
  NSDate *now = [NSDate date];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat = @"yy-MMMM-dd";
  recorderPath = [[NSString alloc] initWithFormat:@"%@/Documents/", NSHomeDirectory()];
  dateFormatter.dateFormat = @"yyyy-MM-dd-hh-mm-ss";
  recorderPath = [recorderPath stringByAppendingFormat:@"%@-MySound.ilbc", [dateFormatter stringFromDate:now]];
  return recorderPath;
}

#pragma mark - Key-value Observing
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
  if (self.barBottomFlag) {
    return;
  }
  if (object == self.toolBarContainer.toolbar.textView && [keyPath isEqualToString:@"contentSize"]) {
    [self layoutAndAnimateMessageInputTextView:object];
  }
}


#pragma mark - UITextView Helper Method
- (CGFloat)getTextViewContentH:(UITextView *)textView {
  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
    return ceilf([textView sizeThatFits:textView.frame.size].height);
  } else {
    return textView.contentSize.height;
  }
}

#pragma mark - Layout Message Input View Helper Method

//计算input textfield 的高度
- (void)layoutAndAnimateMessageInputTextView:(UITextView *)textView {
  CGFloat maxHeight = [JCHATToolBar maxHeight];
  
  CGFloat contentH = [self getTextViewContentH:textView];
  
  BOOL isShrinking = contentH < _previousTextViewContentHeight;
  CGFloat changeInHeight = contentH - _previousTextViewContentHeight;
  
  if (!isShrinking && (_previousTextViewContentHeight == maxHeight || textView.text.length == 0)) {
    changeInHeight = 0;
  }
  else {
    changeInHeight = MIN(changeInHeight, maxHeight - _previousTextViewContentHeight);
  }
  if (changeInHeight != 0.0f) {
      kWEAKSELF
    [UIView animateWithDuration:0.25f
                     animations:^{
                       [weakSelf setTableViewInsetsWithBottomValue:_messageTableView.contentInset.bottom + changeInHeight];
                       
                       [weakSelf scrollToBottomAnimated:NO];
                       
                       if (isShrinking) {
                         if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                           _previousTextViewContentHeight = MIN(contentH, maxHeight);
                         }
                         // if shrinking the view, animate text view frame BEFORE input view frame
                         [_toolBarContainer.toolbar adjustTextViewHeightBy:changeInHeight];
                       }
                       
                       if (!isShrinking) {
                         if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                           weakSelf.previousTextViewContentHeight = MIN(contentH, maxHeight);
                         }
                         // growing the view, animate the text view frame AFTER input view frame
                         [weakSelf.toolBarContainer.toolbar adjustTextViewHeightBy:changeInHeight];
                       }
                     }
                     completion:^(BOOL finished) {
                     }];
    JCHATMessageTextView *textview =_toolBarContainer.toolbar.textView;
    CGSize textSize = [JCHATStringUtils stringSizeWithWidthString:textview.text withWidthLimit:textView.frame.size.width withFont:[UIFont systemFontOfSize:st_toolBarTextSize]];
    CGFloat textHeight = textSize.height > maxHeight?maxHeight:textSize.height;
    _toolBarHeightConstrait.constant = textHeight + 16;//!
    self.previousTextViewContentHeight = MIN(contentH, maxHeight);
  }
  
  // Once we reached the max height, we have to consider the bottom offset for the text view.
  // To make visible the last line, again we have to set the content offset.
  if (self.previousTextViewContentHeight == maxHeight) {
    double delayInSeconds = 0.01;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime,
                   dispatch_get_main_queue(),
                   ^(void) {
                     CGPoint bottomOffset = CGPointMake(0.0f, contentH - textView.bounds.size.height);
                     [textView setContentOffset:bottomOffset animated:YES];
                   });
  }
}

- (void)inputTextViewDidChange:(JCHATMessageTextView *)messageInputTextView {
  [[JCHATSendMsgManager ins] updateConversation:_conversation withDraft:messageInputTextView.text];
}

- (void)scrollToBottomAnimated:(BOOL)animated {
  if (![self shouldAllowScroll]) return;
  
  NSInteger rows = [self.messageTableView numberOfRowsInSection:0];
  
  if (rows > 0) {
    [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_allmessageIdArr count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
  }
}

#pragma mark - Previte Method

- (BOOL)shouldAllowScroll {
  //      if (self.isUserScrolling) {
  //          if ([self.delegate respondsToSelector:@selector(shouldPreventScrollToBottomWhileUserScrolling)]
  //              && [self.delegate shouldPreventScrollToBottomWhileUserScrolling]) {
  //              return NO;
  //          }
  //      }
  
  return YES;
}

#pragma mark - Scroll Message TableView Helper Method

- (void)setTableViewInsetsWithBottomValue:(CGFloat)bottom {
  //    UIEdgeInsets insets = [self tableViewInsetsWithBottomValue:bottom];
  //    self.messageTableView.contentInset = insets;
  //    self.messageTableView.scrollIndicatorInsets = insets;
}

- (UIEdgeInsets)tableViewInsetsWithBottomValue:(CGFloat)bottom {
  UIEdgeInsets insets = UIEdgeInsetsZero;
  if ([self respondsToSelector:@selector(topLayoutGuide)]) {
    insets.top = 64;
  }
  insets.bottom = bottom;
  return insets;
}

#pragma mark - XHMessageInputView Delegate

- (void)inputTextViewWillBeginEditing:(JCHATMessageTextView *)messageInputTextView {
  _textViewInputViewType = JPIMInputViewTypeText;
}

- (void)inputTextViewDidBeginEditing:(JCHATMessageTextView *)messageInputTextView {
  if (!_previousTextViewContentHeight)
    _previousTextViewContentHeight = [self getTextViewContentH:messageInputTextView];
}

- (void)inputTextViewDidEndEditing:(JCHATMessageTextView *)messageInputTextView;
{
  if (!_previousTextViewContentHeight)
    _previousTextViewContentHeight = [self getTextViewContentH:messageInputTextView];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

// ---------------------------------- Private methods

@end
