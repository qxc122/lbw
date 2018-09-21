//
//  LBAnchorListViewController.m
//  Core
//
//  Created by mac on 2017/9/22.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LBAnchorListViewController.h"

#import "LBMainRootCell.h"
#import <MJRefresh.h>
#import "SDCycleScrollView.h"
#import "LSPaoMaView.h"
#import "LiveBroadcastVc.h"
#import "LBRemendToolView.h"
#import "LBRechargerViewController.h"
@interface LBAnchorListViewController ()<SDCycleScrollViewDelegate>
@property(nonatomic, strong)SDCycleScrollView *SDscrollView;
@property(nonatomic, strong)NSMutableArray *anchorListArray;
@property(nonatomic, assign)int page;

@property(nonatomic, strong)LSPaoMaView *maView;
@property (nonatomic, strong) NSMutableArray *dataloop;
@end

@implementation LBAnchorListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.registerCoCells  =@[@"LBMainRootCell"];
    self.anchorListArray = [NSMutableArray array];

    [self setupView];

    [self.header beginRefreshing];
}

- (void)setupView{
    UIButton *reloadButton = [UIButton buttonWithType:0];
    reloadButton.size = CGSizeMake(20, 20);
    [reloadButton setImage:[UIImage imageNamed:@"action_refresh"] forState:0];
    [reloadButton addTarget:self action:@selector(reloadButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:reloadButton];
    self.navigationItem.rightBarButtonItem = rightItem;

    self.dataloop = [NSMutableArray array];
    SDCycleScrollView *SDscrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kFullWidth, adjuctFloat(150)) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [self.view addSubview:(self.SDscrollView=SDscrollView)];
    LBGetAdvListModelAll *data =  [NSKeyedUnarchiver unarchiveObjectWithFile:PATH_guanggao];
    [self setGetAdvListArr:data];
    
    UIImageView *hornImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5+SDscrollView.bottom, 20, 20)];
    hornImageView.image = [UIImage imageNamed:@"喇叭"];
    [self.view addSubview:hornImageView];
    
    LBGetVerCodeModel *database =  [NSKeyedUnarchiver unarchiveObjectWithFile:PATH_base];
    LSPaoMaView *maView = [[LSPaoMaView alloc] initWithFrame:CGRectMake(30, hornImageView.top, kFullWidth-30, 20) title:database.msg];
    maView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:maView];
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(maView.mas_bottom);
        make.bottom.equalTo(self.view);
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
- (void)reloadButtonClick{
    [self.header beginRefreshing]; // 获取主播列表
}
- (void)loadNewData{
    WeakSelf
    self.Pagenumber = 1;
    [[ToolHelper shareToolHelper] getFcousListWithPage:[NSString stringWithFormat:@"%ld",(long)self.Pagenumber] livePlatID:self.livePlatID success:^(id json, NSString *msg, NSInteger code) {
        NSArray *arr = [NSArray modelArrayWithClass:[LBAnchorListModel class] json:json[@"data"]];
        [weakSelf.anchorListArray removeAllObjects];
        [weakSelf.anchorListArray addObjectsFromArray:arr];
        
        BOOL isShow = NO;
        NSString *more = nil;
        if (arr.count >= 40) {
            isShow = YES;
            more = @"1";
        }else{
            isShow = NO;
            more = nil;
        }
        [weakSelf ColoadNewDataEndHeadsuccessSet:nil code:[json[@"result"] intValue]  footerIsShow:isShow hasMore:more];
        //        [MBProgressHUD hideHUDForView:weakSelf.view];
    } failure:^(NSInteger errorCode, NSString *msg) {
        [weakSelf ColoadNewDataEndHeadfailureSet:nil errorCode:errorCode];
        //        [MBProgressHUD hideHUDForView:weakSelf.view];
    }];
}

#pragma -mark<加载更多数据>
- (void)loadMoreData{
    WeakSelf
//    self.Pagenumber++;
    [[ToolHelper shareToolHelper] getFcousListWithPage:[NSString stringWithFormat:@"%ld",(long)self.Pagenumber] livePlatID:self.livePlatID success:^(id json, NSString *msg, NSInteger code) {
        NSArray *arr = [NSArray modelArrayWithClass:[LBAnchorListModel class] json:json[@"data"]];
        [weakSelf.anchorListArray addObjectsFromArray:arr];
        NSString *more = nil;
        if (arr.count >= 40) {
            more = @"1";
        }else{
            more = nil;
        }
        [weakSelf ColoadMoreDataEndFootsuccessSet:nil hasMore:more];
    } failure:^(NSInteger errorCode, NSString *msg) {
        [weakSelf ColoadMoreDataEndFootfailureSet:nil errorCode:errorCode msg:msg];
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.anchorListArray.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LBMainRootCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LBMainRootCell" forIndexPath:indexPath];
    cell.anchorModel = self.anchorListArray[indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    LBAnchorListModel *model = self.anchorListArray[indexPath.row];

    LBGetVerCodeModel *data =  [NSKeyedUnarchiver unarchiveObjectWithFile:PATH_base];
    if ([data.isFree intValue]){
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
    LiveBroadcastVc *vc =[LiveBroadcastVc new];
    vc.anchorLiveUrl = model.anchorLiveUrl;
    
    vc.anchorID = model.anchorID;
    vc.livePlatID = model.livePlatID;
    vc.iconUrl = model.anchorThumb;
    vc.nickname = model.anchorName;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark----UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellW = (kFullWidth-10*2)/3;
    return CGSizeMake(cellW,cellW+20);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10.0;
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    LBGetAdvListModel *model = self.dataloop[index];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:model.linkUrl]]) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:model.linkUrl]];
    }
}
@end
