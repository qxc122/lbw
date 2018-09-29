//
//  LiveBroadcastVc.m
//  Core
//
//  Created by heiguohua on 2018/9/14.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "LiveBroadcastVc.h"
#import "LBShowBannerView.h"
#import "zhiboAndWebVc.h"
#import "JCHATConversationViewController.h"
#import "ChatRoom.h"
#import <QuartzCore/QuartzCore.h>
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>

@interface LiveBroadcastVc ()<PLPlayerDelegate>

@property (nonatomic, strong) UIVisualEffectView *effectView;

@property (nonatomic, assign) BOOL isDisapper;

@property (nonatomic, strong) PLPlayer      *player;

@property(nonatomic,strong)UIActivityIndicatorView *indicator;
@property(nonatomic, weak)UILabel *indicatorL;


@property(nonatomic,weak)UIButton *NOAnchor;

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

@property(nonatomic, assign)BOOL isAttention;
@property (nonatomic,strong) NSTimer *scrollTimer;

@property (nonatomic,assign) BOOL record;


@property (nonatomic, strong) NSURL *url;
@end

@implementation LiveBroadcastVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.record = NO;
    self.fd_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = [UIColor blackColor];
    
    self.thumbImageView = [[UIImageView alloc] init];
    self.thumbImageView.image = [UIImage imageNamed:@"qn_niu"];
    self.thumbImageView.clipsToBounds = YES;
    self.thumbImageView.contentMode = UIViewContentModeScaleAspectFill;
    if (self.thumbImageURL) {
        [self.thumbImageView sd_setImageWithURL:self.thumbImageURL placeholderImage:self.thumbImageView.image];
    }
    
    [self.view addSubview:self.thumbImageView];
    [self.thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.thumbImageView.hidden = YES;
    
    UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    self.effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    [self.thumbImageView addSubview:_effectView];
    [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.thumbImageView);
    }];
    
    [self setupPlayer];
    
    [self installMovieNotificationObservers];
    [self addChatRecodVc];
    [self addBottomView];
    [self addindicator];
    UIButton *NOAnchor =[UIButton new];
    [self.view addSubview:NOAnchor];
    [NOAnchor setTitle:@"该主播已下线" forState:UIControlStateNormal];
    self.NOAnchor = NOAnchor;
    [self.NOAnchor mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
        make.height.equalTo(@40);
        make.width.equalTo(@130);
    }];
    [NOAnchor addTarget:self action:@selector(popSelf) forControlEvents:UIControlEventTouchUpInside];
    NOAnchor.hidden = YES;
    [self AddguangaoView];
    [self.guangaoView show];
    [self addTopView];
    [self AddGesture];
    NSLog(@"准备链接中");
}
- (void)setIconUrl:(NSString *)iconUrl{
    _iconUrl = iconUrl;
    self.thumbImageURL = [NSURL URLWithString:iconUrl];
}
- (void)setAnchorLiveUrl:(NSString *)anchorLiveUrl{
    _anchorLiveUrl = anchorLiveUrl;
    self.url = [NSURL URLWithString:anchorLiveUrl];
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
    
    bottomDescLabel.text = [ChatTool shareChatTool].basicConfig.liveTipMsg;
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
    
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:self.iconUrl] placeholderImage:[UIImage imageNamed:@"ys_actor_circle_default_img"]];
    
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
//    self.tousu.enabled = enable;
//    self.shareButton.enabled = enable;
//    self.attentionButton.enabled = enable;
}
#pragma mark 打开聊天室
- (void)ChatRoomButtonClick{
    UIViewController *chatRoom;
    for (UIViewController *tmp  in self.navigationController.childViewControllers) {
        if ([tmp isKindOfClass:[JCHATConversationViewController class]]) {
            chatRoom = tmp;
            break;
        }
    }
    if (chatRoom) {
        [self.navigationController popToViewController:chatRoom animated:YES];
    } else {
        if (!self.chatRoom) {
            self.chatRoom = [JCHATConversationViewController new];
            self.chatRoom.gotoZhiBoVc = YES;
        }
        [self.navigationController pushViewController:self.chatRoom animated:YES];
    }
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

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self RemoveKeyboard];
}

#pragma mark Install Movie Notifications

/* Register observers for the various movie object notifications. */
-(void)installMovieNotificationObservers
{
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
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)addindicator{
    _indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _indicator.hidesWhenStopped = NO;
    //设置显示位置
    _indicator.frame = CGRectMake(SCREENWIDTH*0.5-13, SCREENHEIGHT*0.5-13, 26, 26);
    //将这个控件加到父容器中。
    [self.view addSubview:_indicator];
    
    
    UILabel *indicatorL = [UILabel new];
    indicatorL.text = @"玩命加载中...";
    indicatorL.font = CustomUIFont(12);
    indicatorL.textColor =[UIColor whiteColor];
    [self.view  addSubview:indicatorL];
    self.indicatorL = indicatorL;
    [indicatorL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.indicator.mas_bottom);
    }];
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
    [self showTheApplauseInView:self.view belowView:self.guanggPng];
}


- (void)guanggPngClick{
    self.guangaoView.isNeedDaoJiShi = @"1";
    [self.guangaoView show];
}
- (void)attionButtonClick{
    WeakSelf
    [MBProgressHUD showLoadingMessage:@"提交中..." toView:self.view];
    NSMutableDictionary *paramDict =[NSMutableDictionary dictionary];
    paramDict[@"token"] = TOKEN;
    paramDict[@"anchorID"] = self.anchorID;
    paramDict[@"livePlatID"] = self.livePlatID;
    paramDict[@"sign"] = [[LBToolModel sharedInstance]getSign:paramDict];
    [VBHttpsTool postWithURL:@"focusOn" params:paramDict success:^(id json) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
        if ([json[@"result"] intValue]==1){
            if (weakSelf.isAttention){
                [MBProgressHUD showPrompt:@"取消关注成功" toView:weakSelf.view];
                [weakSelf.attentionButton setImage:[UIImage imageNamed:@"关注"] forState:0];
            }else{
                [MBProgressHUD showPrompt:@"关注成功" toView:weakSelf.view];
                [weakSelf.attentionButton setImage:[UIImage imageNamed:@"关注-select"] forState:0];
            }
            weakSelf.isAttention =!weakSelf.isAttention;
        }else{
            [MBProgressHUD showPrompt:json[@"info"] toView:weakSelf.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
        [MBProgressHUD showPrompt:@"请重试" toView:weakSelf.view];
    }];
}


- (void)shareButtonClick{
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [self  shareWebPageToPlatformType:platformType];
    }];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.nickname descr:[ChatTool shareChatTool].basicConfig.shareMsg thumImage:self.iconUrl];
    //设置网页地址
    shareObject.webpageUrl = [ChatTool shareChatTool].basicConfig.shareVcode;
    
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
    [self showTheApplauseInView:self.view belowView:self.guanggPng];
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
    [self removeMovieNotificationObservers];
    NSLog(@"销毁了。dealloc");
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

- (void)recordPlayWithanchorID{
    if (!self.record) {
        self.record = YES;
        [[ToolHelper shareToolHelper]recordPlayWithanchorID:self.anchorID livePlatID:self.livePlatID success:^(id dataDict, NSString *msg, NSInteger code) {
            NSLog(@"记录成功");
        } failure:^(NSInteger errorCode, NSString *msg) {
            NSLog(@"记录失败");
        }];
    }
}

- (void)setThumbImageURL:(NSURL *)thumbImageURL {
    _thumbImageURL = thumbImageURL;
    [self.thumbImageView sd_setImageWithURL:thumbImageURL placeholderImage:self.thumbImageView.image];
}

- (void)setUrl:(NSURL *)url {
    if ([_url.absoluteString isEqualToString:url.absoluteString]) return;
    _url = url;
    
    if (self.player) {
        [self stop];
        [self setupPlayer];
        [self.player play];
    }
}

- (void) setupPlayer {
    
    NSLog(@"播放地址: %@", _url.absoluteString);
    
    PLPlayerOption *option = [PLPlayerOption defaultOption];
    PLPlayFormat format = kPLPLAY_FORMAT_UnKnown;
    NSString *urlString = _url.absoluteString.lowercaseString;
    if ([urlString hasSuffix:@"mp4"]) {
        format = kPLPLAY_FORMAT_MP4;
    } else if ([urlString hasPrefix:@"rtmp:"]) {
        format = kPLPLAY_FORMAT_FLV;
    } else if ([urlString hasSuffix:@".mp3"]) {
        format = kPLPLAY_FORMAT_MP3;
    } else if ([urlString hasSuffix:@".m3u8"]) {
        format = kPLPLAY_FORMAT_M3U8;
    }
    [option setOptionValue:@(format) forKey:PLPlayerOptionKeyVideoPreferFormat];
    [option setOptionValue:@(kPLLogNone) forKey:PLPlayerOptionKeyLogLevel];
    
    self.player = [PLPlayer playerWithURL:_url option:option];
    [self.view insertSubview:self.player.playerView atIndex:0];
    [self.player.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.player.delegateQueue = dispatch_get_main_queue();
    self.player.playerView.contentMode = UIViewContentModeScaleAspectFill;
    self.player.delegate = self;
    self.player.loopPlay = YES;
}

- (void)clickCloseButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    self.isDisapper = YES;
    [self stop];
    [super viewDidDisappear:animated];
    if (self.scrollTimer) {
        [self removeMovieNotificationObservers];
        [self removeTimer];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.isDisapper = NO;
    if (![self.player isPlaying]) {
        [self.player play];
    }
    if (!self.scrollTimer) {
        [self installMovieNotificationObservers];
        [self creatTimer];
    }
}

- (void)stop {
    [self.player stop];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)showWaiting{
    NSLog(@"开始动画");
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
    self.indicatorL.hidden = NO;
}

- (void)hideWaiting{
    NSLog(@"结束动画");
    [self.indicator stopAnimating];
    self.indicator.hidden = YES;
    self.indicatorL.hidden = YES;
}

#pragma mark - PLPlayerDelegate
- (void)playerWillBeginBackgroundTask:(PLPlayer *)player {
    self.isDisapper = YES;
    [self stop];
    if (self.scrollTimer) {
        [self removeMovieNotificationObservers];
        [self removeTimer];
    }
}

- (void)playerWillEndBackgroundTask:(PLPlayer *)player {
    if ([self.navigationController.topViewController isEqual:self]) {
        self.isDisapper = NO;
        if (![self.player isPlaying]) {
            [self.player play];
        }
        if (!self.scrollTimer) {
            [self installMovieNotificationObservers];
            [self creatTimer];
        }
    }
}

- (void)player:(PLPlayer *)player statusDidChange:(PLPlayerStatus)state
{
    NSLog(@"state=%ld",(long)state);
    if (self.isDisapper) {
        [self stop];
        [self hideWaiting];
        return;
    }
    
    if (state == PLPlayerStatusPlaying ) {
        [self hideWaiting];
    }else if(state == PLPlayerStatusPaused ||
             state == PLPlayerStatusStopped ||
             state == PLPlayerStatusError ||
             state == PLPlayerStatusUnknow ||
             state == PLPlayerStatusCompleted){
        [self hideWaiting];
    }else if (state == PLPlayerStatusPreparing ||
               state == PLPlayerStatusReady ||
               state == PLPlayerStatusCaching) {
        [self showWaiting];
    } else if (state == PLPlayerStateAutoReconnecting) {
        [self showWaiting];
    }
}

- (void)player:(PLPlayer *)player stoppedWithError:(NSError *)error
{
    NSLog(@"stoppedWithError");
    [self hideWaiting];
    self.NOAnchor.hidden = NO;
}

- (void)player:(nonnull PLPlayer *)player willRenderFrame:(nullable CVPixelBufferRef)frame pts:(int64_t)pts sarNumerator:(int)sarNumerator sarDenominator:(int)sarDenominator {
    dispatch_main_async_safe(^{
        if (![UIApplication sharedApplication].isIdleTimerDisabled) {
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        }
    });
//    NSLog(@"willRenderFrame");
}

- (AudioBufferList *)player:(PLPlayer *)player willAudioRenderBuffer:(AudioBufferList *)audioBufferList asbd:(AudioStreamBasicDescription)audioStreamDescription pts:(int64_t)pts sampleFormat:(PLPlayerAVSampleFormat)sampleFormat{
//    NSLog(@"willAudioRenderBuffer");
    return audioBufferList;
}
- (void)player:(nonnull PLPlayer *)player firstRender:(PLPlayerFirstRenderType)firstRenderType {
    if (PLPlayerFirstRenderTypeVideo == firstRenderType) {
        self.thumbImageView.hidden = YES;
    }
    NSLog(@"firstRender");
}

- (void)player:(nonnull PLPlayer *)player SEIData:(nullable NSData *)SEIData {
    NSLog(@"SEIData");
}

- (void)player:(PLPlayer *)player codecError:(NSError *)error {
    [self hideWaiting];
    NSLog(@"codecError");
}
@end
