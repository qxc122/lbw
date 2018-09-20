//
//  LiveBroadcastVc.m
//  Core
//
//  Created by heiguohua on 2018/9/14.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "LiveBroadcastVc.h"
#import <IJKMediaFramework/IJKFFMoviePlayerController.h>
#import "LBShowBannerView.h"
#import "zhiboAndWebVc.h"
#import "JCHATConversationViewController.h"
#import "ChatRoom.h"
#import <QuartzCore/QuartzCore.h>
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>

@interface LiveBroadcastVc (){
    UITapGestureRecognizer *_tapGestureRecognizer;
    UITapGestureRecognizer *_doubleTapGestureRecognizer;
    UIPanGestureRecognizer *_panGestureRecognizer;
}
@property(nonatomic,strong)IJKFFMoviePlayerController * player;

@property(nonatomic,strong)UIActivityIndicatorView *indicator;

@property(nonatomic, strong)zhiboAndWebVc *zhiboAndWebVcvc;
@property(nonatomic, strong)JCHATConversationViewController *chatRoom;

@property(nonatomic, strong)JCHATConversationViewController *ChatRecordVcVc;

@property(nonatomic, weak)LBShowBannerView *guangaoView;

@property(nonatomic, strong)UIView *topView;
@property(nonatomic, strong)UILabel *bottomDescLabel;
@property(nonatomic, weak)UIButton *tousu;
@property(nonatomic, weak)UIButton *shareButton;
@property(nonatomic, strong)UIButton *attentionButton;

@property(nonatomic, strong)UIView *bottomView;
@property(nonatomic, weak)UIButton *guanggPng;
@property(nonatomic, weak)UIButton *CPButtom;
@property(nonatomic, weak)UIButton *ChatRoomButton;

@property(nonatomic, strong)UIButton *applauseBtn;
@property(nonatomic, assign)BOOL isAttention;


@property(nonatomic, strong)UIButton *paseButton;

@property (nonatomic,strong) NSTimer *scrollTimer;


@property(nonatomic, assign)BOOL didPromptNotOnLine;
@end

@implementation LiveBroadcastVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = [UIColor blackColor];
    
    [IJKFFMoviePlayerController checkIfFFmpegVersionMatch:YES];
    
    IJKFFOptions *options = [IJKFFOptions optionsByDefault]; //使用默认配置

    NSURL * url = [NSURL URLWithString:self.anchorLiveUrl];
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:url withOptions:options]; //初始化播放器，播放在线视频或直播(RTMP)
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.player.view.frame = self.view.bounds;
    self.player.scalingMode = IJKMPMovieScalingModeAspectFill; //缩放模式
    self.player.shouldAutoplay = YES; //开启自动播放
    
#ifdef DEBUG
    [IJKFFMoviePlayerController setLogReport:YES];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_DEBUG];
    
#else
    [IJKFFMoviePlayerController setLogReport:NO];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_INFO];
#endif
    
    
    self.view.autoresizesSubviews = YES;
    [self.view addSubview:self.player.view];
    
    [self addChatRecodVc];
    [self addBottomView];
    [self addindicator];
    [self AddguangaoView];
    [self.guangaoView show];
    [self addTopView];
    [self AddGesture];
    
}
- (void)inputKeyboardWillHide{
        [self setBottom:NO];
}
- (void)inputKeyboardWillShow{
    [self setBottom:YES];
}
- (void)setBottom:(BOOL)hidle{
    self.guanggPng.hidden = hidle;
    self.CPButtom.hidden = hidle;
    self.ChatRoomButton.hidden = hidle;
}
- (void)addTopView{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFullWidth, 80)];
    topView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [self.view addSubview:(self.topView=topView)];
    
    UILabel *bottomDescLabel = [UILabel new];
    self.bottomDescLabel = bottomDescLabel;
    
    LBGetVerCodeModel *data =  [NSKeyedUnarchiver unarchiveObjectWithFile:PATH_base];
    bottomDescLabel.text = data.liveTipMsg;
    bottomDescLabel.font = CustomUIFont(14);
    bottomDescLabel.textColor =[UIColor whiteColor];
    bottomDescLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    [self.view  addSubview:bottomDescLabel];
    bottomDescLabel.numberOfLines = 0;
    bottomDescLabel.textAlignment = NSTextAlignmentCenter;
    bottomDescLabel.numberOfLines = 0;
    [bottomDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.top.equalTo(self.topView.mas_bottom);
    }];
    
    // 返回
    UIButton * backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    backBtn.frame = CGRectMake(0, 30.0f, 40.0f, 40.0f);
    [backBtn setImage:[UIImage imageNamed:@"action_back"] forState:(UIControlStateNormal)];
    [backBtn addTarget:self action:@selector(popSelf) forControlEvents:(UIControlEventTouchUpInside)];
    backBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    backBtn.layer.shadowOffset = CGSizeMake(0, 0);
    backBtn.layer.shadowOpacity = 0.5;
    backBtn.layer.shadowRadius = 1;
    [topView addSubview:backBtn];
    
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(backBtn.right+10, backBtn.top, 40, 40)];
    iconImageView.layer.cornerRadius = iconImageView.width/2;
    iconImageView.clipsToBounds = YES;
    [topView addSubview:iconImageView];
    [iconImageView setImageWithURL:[NSURL URLWithString:self.iconUrl] placeholder:[UIImage imageNamed:@"ys_actor_circle_default_img"]];
    
    
    UILabel *nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconImageView.right+10, iconImageView.top+10, 100, 20)];
    nickNameLabel.text = self.nickname;
    nickNameLabel.font = CustomUIFont(13);
    nickNameLabel.textColor =[UIColor whiteColor];
    [topView  addSubview:nickNameLabel];
    
    
    UIButton *tousu = [UIButton buttonWithType:0];
    self.tousu = tousu;
    [tousu setImage:[UIImage imageNamed:zhibotousu] forState:0];
    [tousu addTarget:self action:@selector(tousuClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:tousu];
    tousu.frame = CGRectMake(kFullWidth-50.0f, 30.0f, 40.0f, 40.0f);
    
    
    UIButton *shareButton = [UIButton buttonWithType:0];
    self.shareButton = shareButton;
    [shareButton setImage:[UIImage imageNamed:@"分享"] forState:0];
    [shareButton addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:shareButton];
    shareButton.frame = CGRectMake(tousu.left-60, 30.0f, 40.0f, 40.0f);
    
    UIButton *attionButton = [UIButton buttonWithType:0];
    self.attentionButton = attionButton;
    [attionButton setImage:[UIImage imageNamed:@"关注"] forState:0];
    [attionButton addTarget:self action:@selector(attionButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:attionButton];
    attionButton.frame = CGRectMake(shareButton.left-60, 30.0f, 40.0f, 40.0f);
    [self setTopBtnEnable:NO];
}
- (void)setTopBtnEnable:(BOOL)enable{
    self.tousu.enabled = enable;
    self.shareButton.enabled = enable;
    self.attentionButton.enabled = enable;
}
#pragma mark 打开聊天室
- (void)ChatRoomButtonClick{
    if (!self.chatRoom) {
        self.chatRoom = [JCHATConversationViewController new];
    }
    [self.navigationController pushViewController:self.chatRoom animated:YES];
}
- (void)addBottomView{
    UIButton *ChatRoomButton = [UIButton buttonWithType:0];
    self.ChatRoomButton= ChatRoomButton;
    ChatRoomButton.imageView.contentMode = UIViewContentModeScaleToFill;
    [ChatRoomButton setBackgroundImage:[UIImage imageNamed:IM_VIEW_swith_WEB] forState:0];
    [ChatRoomButton setBackgroundImage:[UIImage imageNamed:IM_VIEW_swith_WEB] forState:UIControlStateHighlighted];
    [ChatRoomButton addTarget:self action:@selector(ChatRoomButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ChatRoomButton];
    [ChatRoomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-(SCREENWIDTH/5-width_zhibo)*0.5);
        make.bottom.equalTo(self.view).offset(-10-49);
        make.width.equalTo(@(width_zhibo));
        make.height.equalTo(@(width_zhibo));
    }];
    
    
    UIButton *likeButton = [UIButton buttonWithType:0];
    self.CPButtom= likeButton;
    likeButton.imageView.contentMode = UIViewContentModeScaleToFill;
    [likeButton setBackgroundImage:[UIImage imageNamed:zhiboAndWebVcToWeb] forState:0];
    [likeButton setBackgroundImage:[UIImage imageNamed:zhiboAndWebVcToWeb] forState:UIControlStateHighlighted];
    [likeButton addTarget:self action:@selector(likeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:likeButton];
    [likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-(SCREENWIDTH/5-width_zhibo)*0.5);
        make.bottom.equalTo(ChatRoomButton.mas_top).offset(-15);
        make.width.equalTo(@(width_zhibo));
        make.height.equalTo(@(width_zhibo));
    }];
    
    
    
    UIButton *guanggPng = [UIButton buttonWithType:0];
    guanggPng.imageView.contentMode = UIViewContentModeScaleToFill;
    [guanggPng setBackgroundImage:[UIImage imageNamed:zhiboAndWebVcMoney] forState:0];
    [guanggPng setBackgroundImage:[UIImage imageNamed:zhiboAndWebVcMoney] forState:UIControlStateHighlighted];
    [guanggPng addTarget:self action:@selector(guanggPngClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:(self.guanggPng=guanggPng)];
    [guanggPng mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(likeButton);
        make.bottom.equalTo(likeButton.mas_top).offset(-15);
        make.width.equalTo(@(width_zhibo));
        make.height.equalTo(@(width_zhibo));
    }];
}

- (void)addChatRecodVc{
    if (!self.ChatRecordVcVc) {
        JCHATConversationViewController *ChatRecordVcVc = [[JCHATConversationViewController alloc]init];
        self.ChatRecordVcVc = ChatRecordVcVc;
        [self addChildViewController:ChatRecordVcVc];
        ChatRecordVcVc.zhibojian = @"1";
        ChatRecordVcVc.view.frame = CGRectMake(0, SCREENHEIGHT - 220, SCREENWIDTH , 220);
        [self.view addSubview:ChatRecordVcVc.view];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!self.scrollTimer) {
        [self installMovieNotificationObservers];
        if (self.player.isPreparedToPlay) {
            if (!self.player.isPlaying) {
                [self.player play];
            }
        } else {
            if (!self.player.isPlaying) {
                [self startAnimating];
                [self.player prepareToPlay];
            }
        }
        [self creatTimer];
        [[UIApplication sharedApplication] addObserver:self forKeyPath:@"idleTimerDisabled" options:NSKeyValueObservingOptionNew context:nil];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self RemoveKeyboard];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.scrollTimer) {
        [self stopAnimating];
        if ([self.navigationController.childViewControllers containsObject:self]) {
            if (self.player.isPlaying) {
                [self.player pause];
            }
        } else {
            [self.player shutdown];
        }
        [self removeMovieNotificationObservers];
        [self removeTimer];
        [[UIApplication sharedApplication] removeObserver:self forKeyPath:@"idleTimerDisabled"];
    }
}
- (void)loadStateDidChange:(NSNotification*)notification
{
    //    MPMovieLoadStateUnknown        = 0,
    //    MPMovieLoadStatePlayable       = 1 << 0,
    //    MPMovieLoadStatePlaythroughOK  = 1 << 1, // Playback will be automatically started in this state when shouldAutoplay is YES
    //    MPMovieLoadStateStalled        = 1 << 2, // Playback will be automatically paused in this state, if started
    
    IJKMPMovieLoadState loadState = _player.loadState;
    
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStatePlaythroughOK: %d\n", (int)loadState);
    } else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        [self startAnimating];
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}

- (void)moviePlayBackDidFinish:(NSNotification*)notification
{
    //    MPMovieFinishReasonPlaybackEnded,
    //    MPMovieFinishReasonPlaybackError,
    //    MPMovieFinishReasonUserExited
    int reason = [[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    
    switch (reason)
    {
        case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            [self TheAnchorIsNot];
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
            break;
            
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification
{
    NSLog(@"mediaIsPreparedToPlayDidChange\n");
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification
{
    //    MPMoviePlaybackStateStopped,
    //    MPMoviePlaybackStatePlaying,
    //    MPMoviePlaybackStatePaused,
    //    MPMoviePlaybackStateInterrupted,
    //    MPMoviePlaybackStateSeekingForward,
    //    MPMoviePlaybackStateSeekingBackward
    
    switch (_player.playbackState)
    {
        case IJKMPMoviePlaybackStateStopped: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStatePlaying: {
            [self stopAnimating];
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStatePaused: {
            [self startAnimating];
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateInterrupted: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
            break;
        }
        default: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
            break;
        }
    }
}

#pragma mark Install Movie Notifications

/* Register observers for the various movie object notifications. */
-(void)installMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputKeyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputKeyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

#pragma mark Remove Movie Notification Handlers

/* Remove the movie notification observers from the movie object. */
-(void)removeMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:_player];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)TheAnchorIsNot{
    if (self.guangaoView.num>0) {
        [self performSelector:@selector(TheAnchorIsNot) withObject:nil afterDelay:self.guangaoView.num];
    }else{
        [self PromptThatTheAnchorHasBeenOffline];
    }
}
- (void)PromptThatTheAnchorHasBeenOffline{
    if(!self.didPromptNotOnLine){
        self.didPromptNotOnLine = YES;
        [MBProgressHUD showPrompt:@"该主播已下线"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)addindicator{
    _indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _indicator.hidesWhenStopped = NO;
    //设置显示位置
    _indicator.frame = CGRectMake(SCREENWIDTH*0.5-13, SCREENHEIGHT*0.5-13, 26, 26);
    //将这个控件加到父容器中。
    [self.view addSubview:_indicator];
}
- (void)startAnimating{
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
}
- (void)stopAnimating{
    [self setTopBtnEnable:YES];
    self.indicator.hidden = YES;
    [self.indicator stopAnimating];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (![UIApplication sharedApplication].idleTimerDisabled) {
        [UIApplication sharedApplication].idleTimerDisabled = YES;
    }
}
- (void)isFocusOn{
    WeakSelf
    NSMutableDictionary *paramDict =[NSMutableDictionary dictionary];
    paramDict[@"token"] = TOKEN;
    paramDict[@"anchorID"] = self.anchorID;
    paramDict[@"sign"] = [[LBToolModel sharedInstance]getSign:paramDict];
    [VBHttpsTool postWithURL:@"isFocusOn" params:paramDict success:^(id json) {
        if ([json[@"result"] intValue]==1){
            if ([json[@"data"][@"focusType"] intValue] ==1){
                [weakSelf.attentionButton setImage:[UIImage imageNamed:@"关注-select"] forState:0];
                weakSelf.isAttention = YES;
            }else{
                [weakSelf.attentionButton setImage:[UIImage imageNamed:@"关注"] forState:0];
                weakSelf.isAttention = NO;
                
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)tousuClickload{
    kWeakSelf(self);
    [MBProgressHUD showLoadingMessage:@"提交中..." toView:self.view];
    [[ToolHelper shareToolHelper]complaintsanchorID:self.anchorID type:[NSNumber numberWithInt:0] memo:@"我要投诉此主播是广告！" success:^(id dataDict, NSString *msg, NSInteger code) {
        [MBProgressHUD hideHUDForView:weakself.view];
        [MBProgressHUD showPrompt:msg];
    } failure:^(NSInteger errorCode, NSString *msg) {
        [MBProgressHUD hideHUDForView:weakself.view];
        [MBProgressHUD showPrompt:msg];
    }];
}
- (void)tousuClick{
    kWeakSelf(self);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"赚钱APP" message:@"我要投诉此主播是广告！" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定投诉" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakself tousuClickload];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消投诉" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)likeBtnClick{
    if (!self.zhiboAndWebVcvc) {
        self.zhiboAndWebVcvc =[zhiboAndWebVc new];
    }
    [self.navigationController pushViewController:self.zhiboAndWebVcvc animated:NO];
}


- (void)likeButtonClick{
    [self showTheApplauseInView:self.view belowView:self.applauseBtn];
}


- (void)guanggPngClick{
    self.guangaoView.isNeedDaoJiShi = @"1";
    [self.guangaoView show];
}
- (void)attionButtonClick{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    WeakSelf
    NSMutableDictionary *paramDict =[NSMutableDictionary dictionary];
    paramDict[@"token"] = TOKEN;
    paramDict[@"anchorID"] = self.anchorID;
    paramDict[@"livePlatID"] = self.livePlatID;
    paramDict[@"sign"] = [[LBToolModel sharedInstance]getSign:paramDict];
    [VBHttpsTool postWithURL:@"focusOn" params:paramDict success:^(id json) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if ([json[@"result"] intValue]==1){
            if (weakSelf.isAttention){
                [MBProgressHUD showMessage:@"取消关注成功" finishBlock:nil];
                [weakSelf.attentionButton setImage:[UIImage imageNamed:@"关注"] forState:0];
            }else{
                [MBProgressHUD showMessage:@"关注成功" finishBlock:nil];
                [weakSelf.attentionButton setImage:[UIImage imageNamed:@"关注-select"] forState:0];
            }
            weakSelf.isAttention =!weakSelf.isAttention;
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
}


- (void)shareButtonClick{
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [self  shareWebPageToPlatformType:platformType];
    }];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    LBGetVerCodeModel *data =  [NSKeyedUnarchiver unarchiveObjectWithFile:PATH_base];
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.nickname descr:data.shareMsg thumImage:self.iconUrl];
    //设置网页地址
    shareObject.webpageUrl = data.shareVcode;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        //        [self alertWithError:error];
    }];
}
//鼓掌动画
- (void)showTheApplauseInView:(UIView *)view belowView:(UIButton *)v{
    NSInteger index = arc4random_uniform(7); //取随机图片
    NSString *image = [NSString stringWithFormat:@"ic_praise_sm%zd",index];
    UIImageView *applauseView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-15-50, self.view.frame.size.height - 150, 40, 40)];//增大y值可隐藏弹出动画
    [view insertSubview:applauseView belowSubview:v];
    applauseView.image = [UIImage imageNamed:image];
    
    CGFloat AnimH = 350; //动画路径高度,
    applauseView.transform = CGAffineTransformMakeScale(0, 0);
    applauseView.alpha = 0;
    
    //弹出动画
    [UIView animateWithDuration:0.2 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
        applauseView.transform = CGAffineTransformIdentity;
        applauseView.alpha = 0.9;
    } completion:NULL];
    
    //随机偏转角度
    NSInteger i = arc4random_uniform(2);
    NSInteger rotationDirection = 1- (2*i);// -1 OR 1,随机方向
    NSInteger rotationFraction = arc4random_uniform(10); //随机角度
    //图片在上升过程中旋转
    [UIView animateWithDuration:4 animations:^{
        applauseView.transform = CGAffineTransformMakeRotation(rotationDirection * M_PI/(4 + rotationFraction*0.2));
    } completion:NULL];
    
    //动画路径
    UIBezierPath *heartTravelPath = [UIBezierPath bezierPath];
    [heartTravelPath moveToPoint:applauseView.center];
    
    //随机终点
    CGFloat ViewX = applauseView.center.x;
    CGFloat ViewY = applauseView.center.y;
    CGPoint endPoint = CGPointMake(ViewX + rotationDirection*10, ViewY - AnimH);
    
    //随机control点
    NSInteger j = arc4random_uniform(2);
    NSInteger travelDirection = 1- (2*j);//随机放向 -1 OR 1
    
    NSInteger m1 = ViewX + travelDirection*(arc4random_uniform(20) + 50);
    NSInteger n1 = ViewY - 60 + travelDirection*arc4random_uniform(20);
    NSInteger m2 = ViewX - travelDirection*(arc4random_uniform(20) + 50);
    NSInteger n2 = ViewY - 90 + travelDirection*arc4random_uniform(20);
    CGPoint controlPoint1 = CGPointMake(m1, n1);//control根据自己动画想要的效果做灵活的调整
    CGPoint controlPoint2 = CGPointMake(m2, n2);
    //根据贝塞尔曲线添加动画
    [heartTravelPath addCurveToPoint:endPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
    
    //关键帧动画,实现整体图片位移
    CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyFrameAnimation.path = heartTravelPath.CGPath;
    keyFrameAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    keyFrameAnimation.duration = 3 ;//往上飘动画时长,可控制速度
    [applauseView.layer addAnimation:keyFrameAnimation forKey:@"positionOnPath"];
    //消失动画
    [UIView animateWithDuration:3 animations:^{
        applauseView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [applauseView removeFromSuperview];
    }];
}

#pragma mark添加手势
- (void)AddGesture{
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap:)];
    singleTapGesture.numberOfTapsRequired =1;
    singleTapGesture.numberOfTouchesRequired  =1;
    [self.view addGestureRecognizer:singleTapGesture];
    
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTapGesture.numberOfTapsRequired =2;
    doubleTapGesture.numberOfTouchesRequired =1;
    [self.view addGestureRecognizer:doubleTapGesture];
    //只有当doubleTapGesture识别失败的时候(即识别出这不是双击操作)，singleTapGesture才能开始识别
    [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
}


-(void)handleSingleTap:(UIGestureRecognizer *)sender{
    [self RemoveKeyboard];
}

-(void)handleDoubleTap:(UIGestureRecognizer *)sender{
    [self RemoveKeyboard];
}
#pragma mark----移除键盘
- (void)RemoveKeyboard{
    if ([self.ChatRecordVcVc.toolBarContainer.toolbar.textView isFirstResponder]) {
        [self.ChatRecordVcVc.toolBarContainer.toolbar.textView resignFirstResponder];
    }
}
#pragma mark----创建定时器
-(void)creatTimer
{
    _scrollTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(daojishiRunning) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_scrollTimer forMode:NSRunLoopCommonModes];
}
#pragma mark----倒计时
-(void)daojishiRunning{
    [self showTheApplauseInView:self.view belowView:self.applauseBtn];
}
#pragma mark----移除定时器
-(void)removeTimer
{
    if (_scrollTimer) {
        [_scrollTimer invalidate];
        _scrollTimer = nil;
    }
}

- (void)dealloc{
    [self removeTimer];
}

- (void )AddguangaoView{
    LBShowBannerView *guangaoView =[LBShowBannerView new];
//    kWeakSelf(self);
//    guangaoView.doneSomething = ^{
//        [weakself setTopBtnEnable:YES];
//    };
    self.guangaoView = guangaoView;
    [self.view addSubview:guangaoView];
    [guangaoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}
@end
