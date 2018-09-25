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
#import "LiveBroadcastVc.h"
#import "LBRemendToolView.h"
#import "LBRechargerViewController.h"
#import <JhtMarquee/JhtVerticalMarquee.h>
#import <JhtMarquee/JhtHorizontalMarquee.h>

@interface LBAnchorListViewController ()<SDCycleScrollViewDelegate>
@property(nonatomic, strong)SDCycleScrollView *SDscrollView;
@property (nonatomic, strong) NSMutableArray *dataloop;
@property (nonatomic, weak) JhtHorizontalMarquee *horizontalMarquee;
@end

@implementation LBAnchorListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.NodataTitle = @"该平台暂无主播";
    self.dataloop = [NSMutableArray array];
    SDCycleScrollView *SDscrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kFullWidth, adjuctFloat(150)) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [self.view addSubview:(self.SDscrollView=SDscrollView)];
    LBGetAdvListModelAll *data =  [NSKeyedUnarchiver unarchiveObjectWithFile:PATH_guanggao];
    [self setGetAdvListArr:data];
    
    UIImageView *hornImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, SDscrollView.bottom, 20, 20)];
    hornImageView.image = [UIImage imageNamed:@"喇叭"];
    [self.view addSubview:hornImageView];
    [self setPaoMaDeng];
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.horizontalMarquee.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    [self.header beginRefreshing];
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

- (void)loadNewData{
    WeakSelf
    self.Pagenumber = 1;
    [[ToolHelper shareToolHelper] getFcousListWithPage:[NSString stringWithFormat:@"%ld",(long)self.Pagenumber] livePlatID:self.livePlatID success:^(id json, NSString *msg, NSInteger code) {
        NSArray *arr = [NSArray modelArrayWithClass:[LBAnchorListModel class] json:json[@"data"]];
        [weakSelf.arry removeAllObjects];
        [weakSelf.arry addObjectsFromArray:arr];
        
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
        [weakSelf.arry addObjectsFromArray:arr];
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


- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    LBGetAdvListModel *model = self.dataloop[index];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:model.linkUrl]]) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:model.linkUrl]];
    }
}


#pragma mark 设置跑马灯
- (void)setPaoMaDeng{

    JhtHorizontalMarquee * horizontalMarquee = [[JhtHorizontalMarquee alloc] initWithFrame:CGRectMake(30, self.SDscrollView.frame.size.height, SCREENWIDTH-30, 20) withSingleScrollDuration:[ChatTool shareChatTool].basicConfig.msg.length*0.15];
    self.horizontalMarquee = horizontalMarquee;
    horizontalMarquee.textColor = MainColor;
    horizontalMarquee.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:horizontalMarquee];
    self.horizontalMarquee.text = [ChatTool shareChatTool].basicConfig.msg;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 开启跑马灯
    [_horizontalMarquee marqueeOfSettingWithState:MarqueeStart_H];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 关闭跑马灯
    [_horizontalMarquee marqueeOfSettingWithState:MarqueeShutDown_H];
}
@end
