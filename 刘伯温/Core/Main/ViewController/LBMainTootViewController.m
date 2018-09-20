//
//  LBMainTootViewController.m
//  Core
//
//  Created by mac on 2017/9/19.
//  Copyright © 2017年 mac. All rights reserved.
//
#import "LBMainTootViewController.h"
#import "LBMainTootHeadView.h"
#import "LBMainRootCell.h"
#import "LBAnchorListViewController.h"
#import "LBSearchViewController.h"
#import "LBShowRemendView.h"
#import "LBLoginViewController.h"
#import "DHGuidePageHUD.h"
#import <MJRefresh.h>
#import "LBRemendToolView.h"
#import "LBRechargerViewController.h"
#import "AdvertisingVc.h"
#import "ChatRoom.h"
#import "JCHATConversationViewController.h"
#import "LiveBroadcastVc.h"
#import "WHC_GestureUnlockScreenVC.h"
@interface LBMainTootViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property(nonatomic, strong)UICollectionView *myCollectionView;
@property(nonatomic, strong)NSMutableArray *livePlatListArray;
@property(nonatomic, strong)NSMutableArray *anchorListArray;

@property(nonatomic, assign)NSInteger selectIndex;
@property(nonatomic, strong)LBMainTootHeadView *headView;
@property(nonatomic, strong)NSArray *bannaerArr;
@property(nonatomic, strong)UIView *navView;
@property(nonatomic, assign)int page;
@property(nonatomic, strong)NSMutableArray *fcousListArray;

@property(nonatomic, assign)BOOL isHasMore;
@end

@implementation LBMainTootViewController

- (void)viewDidLoad {
    UIView *back = [UIView new];
    self.selectIndex = 0;
    self.isHasMore = YES;
    back.backgroundColor = [UIColor clearColor];
    [self.view addSubview:back];
    [back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [super viewDidLoad];
    
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:BOOLFORKEY]) {
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:BOOLFORKEY];
//        NSArray *imageNameArray = @[@"splash2",@"介绍图2",@"介绍图3"];
//        DHGuidePageHUD *guidePage = [[DHGuidePageHUD alloc] dh_initWithFrame:self.view.frame imageNameArray:imageNameArray buttonIsHidden:NO];
//        guidePage.slideInto = YES;
//        [WINDOW addSubview:guidePage];
//    }
    
    self.view.backgroundColor = BackGroundColor;
    self.selectIndex = 0;
    self.livePlatListArray = [NSMutableArray array];
    self.anchorListArray = [NSMutableArray array];
    self.fcousListArray = [NSMutableArray array];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTabItemTitleNotification:) name:@"changeTabItemTitleNotification" object:nil];
    
    [self setupView];
    
    [self getAdvList]; // 获取广告列表

    [self getLivePlatList]; // 获取直播平台
    
    [self getFcousList:YES]; // 我的关注
    
    [self setFcousList];  //设置刷新头
    [self setFoot];
    self.title = @"VIP俱乐";
    [self.myCollectionView.mj_header beginRefreshing];
}

- (void)setFcousList{
    self.page = 1;
    WeakSelf
    self.myCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        if(weakSelf.selectIndex == 0){
//            if(weakSelf.anchorListArray.count){
//                [weakSelf.myCollectionView.mj_header endRefreshing];
//            }
//            [weakSelf getAnchorList]; // 获取推介主播
//        }else if(weakSelf.selectIndex == 1){
//            if(weakSelf.livePlatListArray.count){
//                [weakSelf.myCollectionView.mj_header endRefreshing];
//            }else{
//                [weakSelf getLivePlatList]; // 获取直播平台
//            }
//        }else if(weakSelf.selectIndex == 2){
//            [weakSelf getFcousList:YES]; // 我的关注
//            if(weakSelf.fcousListArray.count){
//                [weakSelf.myCollectionView.mj_header endRefreshing];
//            }
//        }
        [weakSelf.myCollectionView.mj_header endRefreshing];
        [weakSelf reloadButtonClick];
    }];
}

- (void)setFoot{
    //上拉加载
    WeakSelf
    self.myCollectionView.mj_footer=[MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        if(weakSelf.selectIndex == 2){
            [weakSelf getFcousList:NO];
        }
    }];
    self.myCollectionView.mj_footer.hidden = YES;
}

#pragma mark 获取主播列表
- (void)getAnchorList{
    WeakSelf
    [[ToolHelper shareToolHelper] getReAnchorListSuccess:^(id json, NSString *msg, NSInteger code) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
        if ([json[@"result"] intValue] == 1){
            [weakSelf.anchorListArray removeAllObjects];
            NSArray *arr = [NSArray modelArrayWithClass:[LBAnchorListModel class] json:json[@"data"]];
            [weakSelf.anchorListArray addObjectsFromArray:arr];
            if (weakSelf.selectIndex == 0){
                [weakSelf.myCollectionView reloadData];
            }
            [weakSelf.myCollectionView.mj_header endRefreshing];
        }
    } failure:^(NSInteger errorCode, NSString *msg) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
        if (weakSelf.selectIndex== 0 && !weakSelf.anchorListArray.count) {
            [MBProgressHUD showMessage:@"请重试" view:weakSelf.view];
            [weakSelf.myCollectionView.mj_header endRefreshing];
        }
    }];
}
#pragma mark 获取直播平台
- (void)getLivePlatList{
    WeakSelf
    [[ToolHelper shareToolHelper] getLivePlatListSuccess:^(id json, NSString *msg, NSInteger code) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
        [weakSelf.livePlatListArray removeAllObjects];
        NSArray *arr = [NSArray modelArrayWithClass:[LBGetLivePlatModel class] json:json[@"data"]];
        [weakSelf.livePlatListArray addObjectsFromArray:arr];
        if (weakSelf.selectIndex == 1){
            [weakSelf.myCollectionView reloadData];
            [weakSelf.myCollectionView.mj_header endRefreshing];
        }
    } failure:^(NSInteger errorCode, NSString *msg) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
        if (weakSelf.selectIndex== 1 && !weakSelf.livePlatListArray.count) {
            [MBProgressHUD showMessage:@"请重试" view:weakSelf.view];
            [weakSelf.myCollectionView.mj_header endRefreshing];
        }
    }];
}

#pragma mark 获取我喜欢的主播列表
- (void)getFcousList:(BOOL)isHead{
    if (!ISLOGIN) {
        return;
    }
    WeakSelf
    if (isHead) {
        self.page = 1;
    } else {
        self.page++;
    }
    [[ToolHelper shareToolHelper] getFcousListWithPage:[NSString stringWithFormat:@"%d",self.page] success:^(id json, NSString *msg, NSInteger code) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
            NSArray *arr = [NSArray modelArrayWithClass:[LBAnchorListModel class] json:json[@"data"]];
            if (isHead){
                [weakSelf.fcousListArray removeAllObjects];
                [weakSelf.myCollectionView.mj_header endRefreshing];
            }else{
                [weakSelf.myCollectionView.mj_footer endRefreshing];
            }
            if (!arr.count || arr.count<20){
                weakSelf.myCollectionView.mj_footer.hidden = YES;
                weakSelf.isHasMore = NO;
            }else{
                weakSelf.myCollectionView.mj_footer.hidden = NO;
                weakSelf.isHasMore = YES;
            }
            [weakSelf.fcousListArray addObjectsFromArray:arr];
            [weakSelf.myCollectionView reloadData];
    } failure:^(NSInteger errorCode, NSString *msg) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
        if (weakSelf.selectIndex== 2 && !weakSelf.fcousListArray.count) {
            [MBProgressHUD showMessage:@"请重试" view:weakSelf.view];
            [weakSelf.myCollectionView.mj_header endRefreshing];
        }
    }];
}

#pragma mark 获取广告列表
- (void)getAdvList{
    WeakSelf
    [[ToolHelper shareToolHelper] getAdvListSuccess:^(id json, NSString *msg, NSInteger code) {
        LBGetAdvListModelAll *tmp = [LBGetAdvListModelAll mj_objectWithKeyValues:json];
        [NSKeyedArchiver archiveRootObject:tmp toFile:PATH_guanggao];
        weakSelf.headView.getAdvListArr  = [NSArray modelArrayWithClass:[LBGetAdvListModel class] json:json[@"data"]];
    } failure:^(NSInteger errorCode, NSString *msg) {
        if (![NSKeyedUnarchiver unarchiveObjectWithFile:PATH_guanggao]) {
            [weakSelf performSelector:@selector(getAdvList) withObject:nil afterDelay:0.2];
        }
    }];
}

- (void)reloadButtonClick{
    [MBProgressHUD showLoadingMessage:@"刷新中..." toView:self.view];
    if (self.selectIndex == 0) {
        [self getAnchorList]; // 获取主播列表
    } else   if (self.selectIndex == 1) {
        [self getLivePlatList]; // 获取直播平台
    } else   if (self.selectIndex == 2) {
        [self getFcousList:YES];
    }
}

- (void)setupView{
    WeakSelf
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
    
    self.headView = [[LBMainTootHeadView alloc] initWithFrame:CGRectMake(0, 0, kFullWidth,adjuctFloat(210)) andSelectIndex:weakSelf.selectIndex];
    LBGetAdvListModelAll *data =  [NSKeyedUnarchiver unarchiveObjectWithFile:PATH_guanggao];
    if (data) {
        self.headView.getAdvListArr = data.arry;
    }
    [self.view addSubview:self.headView];
    self.headView.selectIndexBlock = ^(NSInteger index) {
        weakSelf.selectIndex = index;
        if (index == 2) {
            if (weakSelf.isHasMore) {
                weakSelf.myCollectionView.mj_footer.hidden = NO;
            } else {
                weakSelf.myCollectionView.mj_footer.hidden = YES;
            }
        } else {
            weakSelf.myCollectionView.mj_footer.hidden = YES;
        }
        [weakSelf.myCollectionView reloadData];
    };

    self.headView.clickSearchBlock = ^{
        LBSearchViewController *VC = [LBSearchViewController new];
        [weakSelf.navigationController pushViewController:VC animated:YES];
    };
    self.headView.clickBannerBlock = ^(NSString *linkUrl) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:linkUrl]];
    };
    
    CGFloat leftPading = 10;
    
    CGFloat cellW = (kFullWidth-leftPading*2)/3;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(cellW, cellW+20);
    layout.minimumInteritemSpacing = leftPading;
    layout.minimumLineSpacing = leftPading;

    _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.view addSubview:_myCollectionView];
    [_myCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.headView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    _myCollectionView.backgroundColor = [UIColor whiteColor];
    _myCollectionView.delegate = self;
    _myCollectionView.dataSource = self;
    _myCollectionView.showsVerticalScrollIndicator = NO;
    _myCollectionView.showsHorizontalScrollIndicator = NO;
    [_myCollectionView registerClass:[LBMainRootCell class] forCellWithReuseIdentifier:@"LBMainRootCell"];
    
    [self.myCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableViewHeader"];
}

- (void)searchButtonClick{
    if (!ISLOGIN){
        [LBShowRemendView showRemendViewText:@"您还没有登录，请先登录" andTitleText:@"提示" andEnterText:@"确定" andEnterBlock:^{
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [window removeAllSubviews];
            window = nil;
            LBLoginViewController *vc = [[LBLoginViewController alloc] initWithNibName:@"LBLoginViewController" bundle:nil];
            LBNavigationController *nav = [[LBNavigationController alloc]initWithRootViewController:vc];
            [UIApplication sharedApplication].keyWindow.rootViewController = nav;
        }];
        return;
    }
    LBSearchViewController *VC = [LBSearchViewController new];
    [self.navigationController pushViewController:VC animated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.selectIndex == 0){
        return self.anchorListArray.count;
    }else if (self.selectIndex == 1){
        return self.livePlatListArray.count;
    }else{
        return self.fcousListArray.count;
    }
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LBMainRootCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LBMainRootCell" forIndexPath:indexPath];
    if (self.selectIndex == 0){
        cell.anchorModel = self.anchorListArray[indexPath.row];
    }else if (self.selectIndex == 1){
        cell.liveModel = self.livePlatListArray[indexPath.row];
    }else{
        cell.anchorModel = self.fcousListArray[indexPath.row];
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (!ISLOGIN){
        [LBShowRemendView showRemendViewText:@"您还没有登录，请先登录" andTitleText:@"提示" andEnterText:@"确定" andEnterBlock:^{
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [window removeAllSubviews];
            window = nil;
            LBLoginViewController *vc = [[LBLoginViewController alloc] initWithNibName:@"LBLoginViewController" bundle:nil];
            LBNavigationController *nav = [[LBNavigationController alloc]initWithRootViewController:vc];
            [UIApplication sharedApplication].keyWindow.rootViewController = nav;
            
//            [UIApplication sharedApplication].keyWindow.rootViewController = [[LBLoginViewController alloc] initWithNibName:@"LBLoginViewController" bundle:nil];
        }];
        return;
    }
    
    if (self.selectIndex == 0 || self.selectIndex == 2){
        if (!self.anchorListArray.count)return;
        LBAnchorListModel *model = self.anchorListArray[indexPath.row];
        if (self.selectIndex == 2){
            model = self.fcousListArray[indexPath.row];
        }
          LBGetVerCodeModel *data =  [NSKeyedUnarchiver unarchiveObjectWithFile:PATH_base];
        if ([data.isFree intValue]){
            NSString *expirationDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"expirationDate"];
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            NSDate *oneData = [format dateFromString:expirationDate];
            NSString *type = [[NSUserDefaults standardUserDefaults] objectForKey:@"type"];
            WeakSelf
            if ([type isEqualToString:@"0"]){
                [LBRemendToolView showRemendViewText:[NSString stringWithFormat:@"您还不是会员，现在去充值吗"] andTitleText:@"赚钱APP" andEnterText:@"确认" andCancelText:@"取消" andEnterBlock:^{
                    LBRechargerViewController *VC = [[LBRechargerViewController alloc] initWithNibName:@"LBRechargerViewController" bundle:nil];
                    [weakSelf.navigationController pushViewController:VC animated:YES];
                } andCancelBlock:^{
                    
                }];
                return;
            }else if([NSDate date].timeIntervalSince1970 >= oneData.timeIntervalSince1970){
                [LBRemendToolView showRemendViewText:[NSString stringWithFormat:@"您的会员已经到期，现在去充值吗"] andTitleText:@"赚钱APP" andEnterText:@"确认" andCancelText:@"取消" andEnterBlock:^{
                    LBRechargerViewController *VC = [[LBRechargerViewController alloc] initWithNibName:@"LBRechargerViewController" bundle:nil];
                    [weakSelf.navigationController pushViewController:VC animated:YES];
                } andCancelBlock:^{
                    
                }];
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

    }else{
        if (!self.livePlatListArray.count)return;
        LBGetLivePlatModel *model = self.livePlatListArray[indexPath.row];
        LBAnchorListViewController *VC = [LBAnchorListViewController new];
        VC.title = model.livePlatTitle;
        VC.livePlatID = model.livePlatID;
        VC.getAdvListArr = self.headView.getAdvListArr;
        [self.navigationController pushViewController:VC animated:YES];
    }
}

//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [self getAnchorList]; // 获取主播列表
//}
-(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay

{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    
    NSComparisonResult result = [dateA compare:dateB];
    
    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    
    if (result == NSOrderedDescending) {
        
        //NSLog(@"Date1  is in the future");
        
        return 1;
        
    }
    
    else if (result ==NSOrderedAscending){
        
        //NSLog(@"Date1 is in the past");
        
        return -1;
        
    }
    return 0;
}


#pragma 签到
- (void)signButtonClick{
    
    if (!ISLOGIN){
        [LBShowRemendView showRemendViewText:@"您还没有登录，请先登录" andTitleText:@"提示" andEnterText:@"确定" andEnterBlock:^{
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [window removeAllSubviews];
            window = nil;
            LBLoginViewController *vc = [[LBLoginViewController alloc] initWithNibName:@"LBLoginViewController" bundle:nil];
            LBNavigationController *nav = [[LBNavigationController alloc]initWithRootViewController:vc];
            [UIApplication sharedApplication].keyWindow.rootViewController = nav;
            
//            [UIApplication sharedApplication].keyWindow.rootViewController = [[LBLoginViewController alloc] initWithNibName:@"LBLoginViewController" bundle:nil];
        }];
        return;
    }
    LBGetVerCodeModel *data =  [NSKeyedUnarchiver unarchiveObjectWithFile:PATH_base];
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"timestamp"] = [[LBToolModel sharedInstance] getTimestamp];
    paramDict[@"token"] = TOKEN;
    paramDict[@"jd"] = Longitude;
    paramDict[@"wd"] = Latitude;
    paramDict[@"address"] = Address;
    paramDict[@"sign"] = [[LBToolModel sharedInstance]getSign:paramDict];
    WeakSelf
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [VBHttpsTool postWithURL:@"sign" params:paramDict success:^(id json) {
        if ([json[@"result"] intValue] == 1){
            [LBShowRemendView showRemendViewText:[NSString stringWithFormat:@"签到成功，您将获得%@金币奖励",data.singReward] andTitleText:@"签到" andEnterText:@"我知道了" andEnterBlock:^{
                
            }];
        }else{
            [MBProgressHUD showMessage:json[@"info"] finishBlock:nil];
        }
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
}
@end
