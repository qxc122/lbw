//
//  LBWMainVc.m
//  Core
//
//  Created by heiguohua on 2018/9/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "LBWMainVc.h"
#import "JXCategoryView.h"
#import "zhuboVc.h"
#import "SDCycleScrollView.h"
#import "PlatformListVc.h"
#import "MyLoveListVc.h"
#import "LBSearchViewController.h"
#import "LBShowRemendView.h"
#import "LBLoginViewController.h"
#import <JhtMarquee/JhtVerticalMarquee.h>
#import <JhtMarquee/JhtHorizontalMarquee.h>
#import "passAll.h"
#import "WHC_GestureUnlockScreenVC.h"
#import "JCHATConversationViewController.h"
#import "Masonry.h"
#import "HeaderBase.h"
#import "LBShowRemendView.h"
#import "LBLoginViewController.h"
#import "JCHATConversationViewController.h"
#import "ChatRoom.h"
#import "LBShowBannerView.h"
#import "zhiboAndWebVc.h"


#define WindowsSize [UIScreen mainScreen].bounds.size


@interface LBWMainVc () <JXCategoryViewDelegate,SDCycleScrollViewDelegate>
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property(nonatomic, strong)SDCycleScrollView *SDscrollView;
@property (nonatomic, strong) NSArray *titles;
@property(nonatomic, assign)NSInteger selectIndex;

@property (nonatomic, strong) NSMutableArray *dataloop;

@property (nonatomic, weak) JhtHorizontalMarquee *horizontalMarquee;


@property (nonatomic, strong) passAll *passwordView;

@property (nonatomic, weak) UIButton *live_off_btn;
@property (nonatomic, weak) UIImageView *live_off_PNG;

@property (nonatomic, assign) BOOL isDisplayed;  //公告是否显示过
@property (nonatomic, assign) NSInteger indexMsg;  //将要显示第几个公告

@property(nonatomic, weak)UIButton *CPButtom;
@property(nonatomic, weak)UIButton *ChatRoomButton;
@property(nonatomic, strong)zhiboAndWebVc *zhiboAndWebVcvc;
@property(nonatomic, strong)JCHATConversationViewController *chatRoom;

@end


@implementation LBWMainVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.indexMsg = 0;
    self.title = @"VIP俱乐";
    self.titles = @[@"推荐主播", @"直播平台", @"我的关注"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.dataloop = [NSMutableArray array];
    SDCycleScrollView *SDscrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kFullWidth, adjuctFloat(150)) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [self.view addSubview:(self.SDscrollView=SDscrollView)];
    LBGetAdvListModelAll *data =  [NSKeyedUnarchiver unarchiveObjectWithFile:PATH_guanggao];
    [self setGetAdvListArr:data];
    [self getAdvList];
    
    UIImageView *hornImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, self.SDscrollView.frame.size.height, 20, 20)];
    hornImageView.image = [UIImage imageNamed:@"喇叭"];
    [self.view addSubview:hornImageView];
    
    if ([ChatTool shareChatTool].basicConfig) {
        [self setPaoMaDeng];
    }else{
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(setPaoMaDeng)
                                                     name:@"getBaseConfigSuccess"
                                                   object:nil];
    }
    
    CGFloat naviHeight = 64;
    CGFloat ToolBarHeight = 49;
    if (@available(iOS 11.0, *)) {
        if (WindowsSize.height >= 812) {
            naviHeight = [UIApplication sharedApplication].keyWindow.safeAreaInsets.top + 44;
            ToolBarHeight = 83;
        }
    }
    
    NSUInteger count = [self preferredListViewCount];
    CGFloat categoryViewHeight = [self preferredCategoryViewHeight];
    CGFloat width = WindowsSize.width;
    CGFloat height = WindowsSize.height - naviHeight - categoryViewHeight - 20 - adjuctFloat(150)- ToolBarHeight;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, categoryViewHeight+20+adjuctFloat(150), width, height)];
    self.scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(width*count, height);
    self.scrollView.bounces = NO;
    [self.view addSubview:self.scrollView];
    
//    if (@available(iOS 11.0, *)) {
//        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    }
    
    for (int i = 0; i < count; i ++) {
        [self configListViewController:nil index:i];
    }
    
    self.categoryView.frame = CGRectMake(0, categoryViewHeight+20+adjuctFloat(150)-categoryViewHeight, WindowsSize.width, categoryViewHeight);
    self.categoryView.delegate = self;
    self.categoryView.contentScrollView = self.scrollView;
    [self.view addSubview:self.categoryView];

    self.categoryView.titles = self.titles;

    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorLineWidth = 20;
    lineView.indicatorLineViewColor = MainColor;
    lineView.lineStyle = JXCategoryIndicatorLineStyle_IQIYI;
    self.categoryView.indicators = @[lineView];
    self.categoryView.tintColor = [UIColor lightTextColor];
    self.categoryView.titleSelectedColor = MainColor;
    
//    UIView *line = [UIView new];
//    [self.view addSubview:line];
//    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.categoryView);
//        make.right.equalTo(self.categoryView);
//        make.bottom.equalTo(self.categoryView);
//        make.height.equalTo(@0.5);
//    }];
//    line.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *reloadButton = [UIButton buttonWithType:0];
    reloadButton.size = CGSizeMake(20, 20);
    [reloadButton setImage:[UIImage imageNamed:@"action_refresh"] forState:0];
    [reloadButton addTarget:self action:@selector(reloadButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:reloadButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *searchButton = [UIButton buttonWithType:0];
    searchButton.size = CGSizeMake(20, 20);
    [searchButton setImage:[UIImage imageNamed:@"搜索"] forState:0];
    [searchButton addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *signButton = [UIButton buttonWithType:0];
    signButton.size = CGSizeMake(40, 20);
    [signButton setTitle:@"签到" forState:0];
    signButton.titleLabel.font = CustomUIFont(14);
    [signButton setTitleColor:[UIColor whiteColor] forState:0];
    [signButton addTarget:self action:@selector(signButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:signButton],[[UIBarButtonItem alloc] initWithCustomView:searchButton]];
    
    [self setpassWord];
    
    
    UIImageView *live_off_PNG = [[UIImageView alloc]initWithFrame:self.scrollView.frame];
    self.live_off_PNG = live_off_PNG;
    [self.view addSubview:live_off_PNG];
    
    UIButton *live_off_btn = [[UIButton alloc]initWithFrame:self.scrollView.frame];
    self.live_off_btn = live_off_btn;
    [self.view addSubview:live_off_btn];
    [live_off_btn addTarget:self action:@selector(live_off_btnClick) forControlEvents:UIControlEventTouchUpInside];
    if ([[ChatTool shareChatTool].basicConfig.live_of isEqualToString:@"1"]) { //关
        [self setlive_off_btn];
    } else {
        self.live_off_btn.hidden = YES;
        self.live_off_PNG.hidden = YES;
    }
    [self addBottomView];
}
- (void)live_off_btnClick{
    JCHATConversationViewController *vc = [JCHATConversationViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (Class)preferredCategoryViewClass {
    return [JXCategoryTitleView class];
}

- (NSUInteger)preferredListViewCount {
    return self.titles.count;
}

- (CGFloat)preferredCategoryViewHeight {
    return 35;
}

- (Class)preferredListViewControllerClass {
    return [zhuboVc class];
}

- (void)configListViewController:(UIViewController *)controller index:(NSUInteger)index {
    UIViewController *listVC;
    if (index == 0) {
        listVC =[[zhuboVc alloc]init];
    } else if (index == 1) {
        listVC =[[PlatformListVc alloc]init];
    } else if (index == 2) {
        listVC =[[MyLoveListVc alloc]init];
    }
    [self addChildViewController:listVC];
    listVC.view.frame = CGRectMake(index*_scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
    [self.scrollView addSubview:listVC.view];
}

- (JXCategoryTitleView *)categoryView {
    if (_categoryView == nil) {
        _categoryView = [[[self preferredCategoryViewClass] alloc] init];
    }
    return _categoryView;
}


#pragma mark 获取广告列表
- (void)getAdvList{
    WeakSelf
    [[ToolHelper shareToolHelper] getAdvListSuccess:^(id json, NSString *msg, NSInteger code) {
        LBGetAdvListModelAll *tmp = [LBGetAdvListModelAll mj_objectWithKeyValues:json];
        [NSKeyedArchiver archiveRootObject:tmp toFile:PATH_guanggao];
        if (!weakSelf.SDscrollView.imageURLStringsGroup.count) {
            [weakSelf setGetAdvListArr:tmp];
        }
    } failure:^(NSInteger errorCode, NSString *msg) {
        if (!weakSelf.SDscrollView.imageURLStringsGroup.count) {
            [weakSelf performSelector:@selector(getAdvList) withObject:nil afterDelay:0.2];
        }
    }];
}
#pragma mark 设置轮播广告
-(void)setGetAdvListArr:(LBGetAdvListModelAll *)getAdvListArr{
    NSMutableArray *SDArry = [NSMutableArray array];
    for (LBGetAdvListModel *model in getAdvListArr.arry) {
        if ([model.advImageUrl rangeOfString:@"http"].location ==NSNotFound){
            model.advImageUrl = [NSString stringWithFormat:@"%@%@",ImageHead,model.advImageUrl];
        }
        if([model.advType isEqualToString:@"1"]){
            [SDArry addObject:model.advImageUrl];
            [self.dataloop addObject:model];
        }
    }
    self.SDscrollView.imageURLStringsGroup = SDArry;
}


#pragma mark 搜素主播
- (void)searchButtonClick{
    if (!ISLOGIN){
        [self login];
        return;
    }
    LBSearchViewController *VC = [LBSearchViewController new];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark  签到
- (void)signButtonClick{
    [self basicVcsignButtonClick];
}


- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index{
    [self didSelectedItemAtIndex:index];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index{
    [self didSelectedItemAtIndex:index];
}

- (void)didSelectedItemAtIndex:(NSInteger)index{
    if (!ISLOGIN && index == 2){
        [self login];
    }
    self.selectIndex = index;
}
- (void)reloadButtonClick{
    if (self.selectIndex == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"one" object:nil];
    } else  if (self.selectIndex == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"two" object:nil];
    } else  if (self.selectIndex == 2) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"three" object:nil];
    }
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    LBGetAdvListModel *model = self.dataloop[index];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:model.linkUrl]]) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:model.linkUrl]];
    }
}

#pragma mark 设置跑马灯
- (void)setPaoMaDeng{
    if (!self.horizontalMarquee) {
        JhtHorizontalMarquee * horizontalMarquee = [[JhtHorizontalMarquee alloc] initWithFrame:CGRectMake(30, self.SDscrollView.frame.size.height, SCREENWIDTH-30, 20) withSingleScrollDuration:[ChatTool shareChatTool].basicConfig.msg.length*0.15];
        self.horizontalMarquee = horizontalMarquee;
        horizontalMarquee.textColor = MainColor;
        horizontalMarquee.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:horizontalMarquee];
        self.horizontalMarquee.text = [ChatTool shareChatTool].basicConfig.msg;
    }
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.passwordView && ![[NSUserDefaults standardUserDefaults] objectForKey:@"ConfigurationKey"]) {
        [MBProgressHUD showPrompt:@"请先设置密码" toView:self.view];
    }
    if ([ChatTool shareChatTool].basicConfig.notice_msg.count) {
        [self DisplayedMsg];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 开启跑马灯
    [_horizontalMarquee marqueeOfSettingWithState:MarqueeStart_H];
    
//    [self createChatRoomConversation];
    [self getBaseConfig];
}

- (void)getBaseConfig{
    kWeakSelf(self);
    [[ToolHelper shareToolHelper]getBaseConfigSuccess:^(id dataDict, NSString *msg, NSInteger code) {
        NSLog(@"在我的页面 基础信息获取成功");
        LBGetVerCodeModel *model = [LBGetVerCodeModel mj_objectWithKeyValues:dataDict[@"data"]];
        [ChatTool shareChatTool].basicConfig = model;
        if ([model.live_of isEqualToString:@"1"]) { //关
            [weakself setlive_off_btn];
        } else {
            weakself.live_off_btn.hidden = YES;
            weakself.live_off_PNG.hidden = YES;
        }
        if ([ChatTool shareChatTool].basicConfig.notice_msg.count && !weakself.isDisplayed) {
            [weakself DisplayedMsg];
        }
    } failure:^(NSInteger errorCode, NSString *msg) {
        
    }];
}
- (void)setlive_off_btn{
    self.live_off_btn.hidden = NO;
    [self.live_off_PNG sd_setImageWithURL:[NSURL URLWithString:[ChatTool shareChatTool].basicConfig.off_img]];
}

- (void)DisplayedMsg{
    if (!self.isDisplayed && !self.tabBarController.navigationController.presentedViewController) {
        self.isDisplayed = YES;
        [self DisplayedMsgIndex];
    }
}

- (void)DisplayedMsgIndex{
    if (self.indexMsg < [ChatTool shareChatTool].basicConfig.notice_msg.count) {
        notice_Onemsg *tmp = [ChatTool shareChatTool].basicConfig.notice_msg[self.indexMsg];
        kWeakSelf(self);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:tmp.title message:tmp.msg preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            weakself.indexMsg++;
            [weakself DisplayedMsgIndex];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 关闭跑马灯
    [_horizontalMarquee marqueeOfSettingWithState:MarqueeShutDown_H];
}
- (void)setpassWord{
    if (!self.passwordView) {
        self.passwordView =  [[passAll alloc]initWithFrame:self.scrollView.frame];
        [self.view addSubview:self.passwordView];
        kWeakSelf(self);
        self.passwordView.forgetPassWord = ^{
            [weakself reLOgin];
        };
    }
}
- (void)reLOgin{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
    [self dismissViewControllerAnimated:YES completion:nil];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window removeAllSubviews];
    window = nil;
    LBLoginViewController *vc = [[LBLoginViewController alloc] initWithNibName:@"LBLoginViewController" bundle:nil];
    LBNavigationController *nav = [[LBNavigationController alloc]initWithRootViewController:vc];
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
    
    //    [UIApplication sharedApplication].keyWindow.rootViewController = [[LBLoginViewController alloc] initWithNibName:@"LBLoginViewController" bundle:nil];
    [WHC_GestureUnlockScreenVC removeGesturePassword];
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
}

- (void)likeBtnClick{
    UIViewController *zhiboAndWebVcvc;
    for (UIViewController *tmp  in self.navigationController.childViewControllers) {
        if ([tmp isKindOfClass:[zhiboAndWebVc class]]) {
            zhiboAndWebVcvc = tmp;
            break;
        }
    }
    if (zhiboAndWebVcvc) {
        [self.navigationController popToViewController:zhiboAndWebVcvc animated:YES];
    } else {
        if (!self.zhiboAndWebVcvc) {
            self.zhiboAndWebVcvc =[zhiboAndWebVc new];
        }
        [self.navigationController pushViewController:self.zhiboAndWebVcvc animated:YES];
    }
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
@end
