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
@end


@implementation LBWMainVc

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 开启跑马灯
    [_horizontalMarquee marqueeOfSettingWithState:MarqueeStart_H];
    
//    [self createChatRoomConversation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 关闭跑马灯
    [_horizontalMarquee marqueeOfSettingWithState:MarqueeShutDown_H];
}
//
//#pragma mark 聊天室测试
//- (void)createChatRoomConversation{
//    [JMSGConversation createChatRoomConversationWithRoomId:@"5294578" completionHandler:^(id resultObject, NSError *error) {
//        if (!error) {
//            NSLog(@"创建聊天室成功");
//        }else{
//            NSLog(@"%@",error);
//        }
//    }];
//}
//
//- (void)deleteChatRoomConversatio{
//    if ([JMSGConversation deleteChatRoomConversationWithRoomId:@"5294578"]) {
//        NSLog(@"删除聊天室成功");
//    } else {
//        NSLog(@"删除聊天室 失败");
//    }
//}
@end
