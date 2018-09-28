//
//  basicUiTableView.h
//  TourismT
//
//  Created by Store on 2017/7/24.
//  Copyright © 2017年 qxc122@126.com. All rights reserved.
//

#import "basicVc.h"
#import "MJRefresh.h"
#import "ToolHelper.h"
#import "LBShowRemendView.h"
#import "LBLoginViewController.h"
#import "LiveBroadcastVc.h"
#import "LBShowRemendView.h"

typedef NS_ENUM(NSInteger, empty_num)
{
    fail_empty_num = KRespondCodeFail, //加载失败
    succes_empty_num = kRespondCodeSuccess,   //加载成功
    NoNetworkConnection_empty_num = KRespondCodeNotConnect,   //无网络连接
};


@interface baseUiTableView : basicVc
@property (nonatomic,assign) BOOL isRefreshing;
@property (nonatomic,strong) MJRefreshHeader *header;//头部
@property (nonatomic,strong) MJRefreshFooter *footer;//底部
@property (nonatomic,strong) NSString  *NodataTitle; // 没有数据时候的标题
@property (nonatomic,assign) empty_num  empty_type;
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,assign) UITableViewStyle  style; // 默认是分组
@property (nonatomic,assign) NSInteger Pagenumber;
@property (nonatomic,assign) NSInteger Pagesize;

@property (nonatomic,strong) NSArray  *registerCells; //需要注册的cell


@property (nonatomic,assign) BOOL isNeedRefreshWhenLoginOrOut;
- (void)loadNewDataEndHeadsuccessSet:(UITableView *)TableView code:(NSInteger)code footerIsShow:(BOOL)footerIsShow  hasMore:(NSString *)hasMore;
- (void)loadNewDataEndHeadfailureSet:(UITableView *)TableView errorCode:(NSInteger)errorCode;

- (void)loadMoreDataEndFootsuccessSet:(UITableView *)TableView  hasMore:(NSString *)hasMore;
- (void)loadMoreDataEndFootfailureSet:(UITableView *)TableView errorCode:(NSInteger)errorCode msg:(NSString *)msg;

- (void)set_MJRefreshFooter;
@end
