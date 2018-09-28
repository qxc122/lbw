//
//  basicUiTableView.m
//  TourismT
//
//  Created by Store on 2017/7/24.
//  Copyright © 2017年 qxc122@126.com. All rights reserved.
//

#import "baseUiTableView.h"
#import "UIScrollView+EmptyDataSet.h"
#import "Masonry.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "HeaderBase.h"
#import "NSString+Add.h"
#import "ToolHelper.h"
#import <CoreTelephony/CTCellularData.h>

@interface baseUiTableView ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end

@implementation baseUiTableView
- (void)viewDidLoad {
    [super viewDidLoad];
    self.style = UITableViewStyleGrouped;
    self.Pagesize = 10;
    self.Pagenumber = 0;
    self.NodataTitle = @"没有数据";
    self.isRefreshing = YES;
    [self setTableView];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(networkStateChange) name:kReachabilityChangedNotification object:nil];
    
//    if (@available(iOS 11.0, *)) {
//        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
//    }else {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
}
- (void)setTableView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:self.style];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tableView.backgroundColor =  [UIColor clearColor];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.left.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.mj_header = self.header;
    tableView.emptyDataSetSource = self;
    tableView.emptyDataSetDelegate = self;
}
#pragma -mark<mj_header  头部>
- (MJRefreshHeader *)header{
    if (!_header) {
        MJRefreshHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewDataPre)];
        _header = header;
    }
    return _header;
}

- (void)loadNewDataPre{
    self.isRefreshing = NO;
    [self loadNewData];
}
- (void)loadMoreDataPre{
    self.isRefreshing = NO;
    [self loadMoreData];
}

- (void)loadNewData{
}
#pragma -mark<加载更多数据>
- (void)loadMoreData{
    
}

#pragma -mark<mj_footer  头部>
- (void)set_MJRefreshFooter{
    MJRefreshFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataPre)];
    self.footer = footer;
}

- (void)setRegisterCells:(NSArray *)registerCells{
    _registerCells = registerCells;
    for (NSString *tmp in registerCells) {
        if([tmp hasSuffix:@"xib"] || [tmp hasSuffix:@"Xib"]){
            [self.tableView registerNib:[UINib nibWithNibName:tmp bundle:nil] forCellReuseIdentifier:tmp];
        }else{
            [self.tableView registerClass:NSClassFromString(tmp) forCellReuseIdentifier:tmp]; 
        }
    }
}

#pragma --mark< UITableViewDelegate 高>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.empty_type == succes_empty_num) {
        kWeakSelf(self);
        return [tableView fd_heightForCellWithIdentifier:self.registerCells[indexPath.section] cacheByIndexPath:indexPath configuration:^(id cell)
                {
                    NSString *method =[NSString stringWithFormat:@"configure%@:atIndexPath:",NSStringFromClass([cell class])];
                    SEL selector = NSSelectorFromString(method);
                    if ([weakself respondsToSelector:selector]) {
                        [weakself performSelector:selector withObject:cell withObject:indexPath];
                    }
                }];
    }else{
        return 0.01;
    }
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//
//}
#pragma --mark< 创建cell >
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    testCellXib *cell = [tableView dequeueReusableCellWithIdentifier:@"testCellXib" forIndexPath:indexPath];
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellT"];
//    if (!cell) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellT"];
//    }
//    return  cell;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
     return nil;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
     return nil;
}
#pragma -mark<UITableViewDataSource>
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 0;
//}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.empty_type == succes_empty_num) {
        return 1;
    }
    return 0;
}

    
- (void)loadNewDataEndHeadsuccessSet:(UITableView *)TableView code:(NSInteger)code footerIsShow:(BOOL)footerIsShow hasMore:(NSString *)hasMore{
    self.empty_type = code;
    self.isRefreshing = NO;
    [self.header endRefreshing];
    [self.tableView reloadData];
    if (footerIsShow) {
        if(!self.footer){
            [self set_MJRefreshFooter];
            self.tableView.mj_footer = self.footer;
        }
        if ([hasMore isEqualToString:@"1"]) {
            self.footer.hidden = NO;
            if (self.footer.state == MJRefreshStateNoMoreData) {
                [self.footer resetNoMoreData];
            }
        }else{
            self.footer.hidden = YES;
        }
        self.Pagenumber++;
    }
}
- (void)loadNewDataEndHeadfailureSet:(UITableView *)TableView errorCode:(NSInteger)errorCode{
    self.empty_type = errorCode;
    self.isRefreshing = NO;
    [self.header endRefreshing];
    [self.tableView reloadData];
    if(self.footer){
        self.footer.hidden = YES;
    }
}
    
- (void)loadMoreDataEndFootsuccessSet:(UITableView *)TableView  hasMore:(NSString *)hasMore{
    [self.footer endRefreshing];
    self.isRefreshing = NO;
    if ([hasMore isEqualToString:@"1"]) {
        self.footer.hidden = NO;
        if (self.footer.state == MJRefreshStateNoMoreData) {
            [self.footer resetNoMoreData];
        }
    }else{
        self.footer.hidden = YES;
    }
    self.Pagenumber++;
    [TableView reloadData];
}
- (void)loadMoreDataEndFootfailureSet:(UITableView *)TableView errorCode:(NSInteger)errorCode msg:(NSString *)msg{
    [self.footer endRefreshing];
    self.isRefreshing = NO;
}
  
#pragma --<空白页处理>
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    if([[ToolHelper shareToolHelper] isReachable]){
        if (self.empty_type == succes_empty_num) {
            return [UIImage imageNamed:PIC_nodata];
        } else  {
            return [UIImage imageNamed:PIC_Loadfailure];
        }
    }else{
        return [UIImage imageNamed:PIC_Nonetwork];
    }
    return nil;
}
    
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    if([[ToolHelper shareToolHelper] isReachable]){
        if (self.empty_type == succes_empty_num) {
            NSMutableAttributedString *all = [[NSMutableAttributedString alloc]init];
            NSAttributedString *title = [[NSString stringWithFormat:@"\n%@",self.NodataTitle&&self.NodataTitle.length?self.NodataTitle:STR_nodata] CreatMutableAttributedStringWithFont:PingFangSC_Regular(14) Color:ColorWithHex(0x000000, 0.4) LineSpacing:0 Alignment:NSTextAlignmentCenter BreakMode:NSLineBreakByTruncatingTail firstLineHeadIndent:0 headIndent:0 paragraphSpacing:0 WordSpace:0];
            [all appendAttributedString:title];
            return all;
        } else  {
            NSMutableAttributedString *all = [[NSMutableAttributedString alloc]init];
            NSAttributedString *title = [[NSString stringWithFormat:STR_Loadfailure] CreatMutableAttributedStringWithFont:PingFangSC_Regular(14) Color:ColorWithHex(0x000000, 0.4) LineSpacing:0 Alignment:NSTextAlignmentCenter BreakMode:NSLineBreakByTruncatingTail firstLineHeadIndent:0 headIndent:0 paragraphSpacing:0 WordSpace:0];
            [all appendAttributedString:title];
            return all;
        }
    }else{
        NSMutableAttributedString *all = [[NSMutableAttributedString alloc]init];
        NSAttributedString *title = [[NSString stringWithFormat:STR_Nonetwork] CreatMutableAttributedStringWithFont:PingFangSC_Regular(14) Color:ColorWithHex(0x000000, 0.4) LineSpacing:0 Alignment:NSTextAlignmentCenter BreakMode:NSLineBreakByTruncatingTail firstLineHeadIndent:0 headIndent:0 paragraphSpacing:0 WordSpace:0];
        [all appendAttributedString:title];
        return all;
    }
}
//- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
//
//}
    //按钮文本或者背景样式
//- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
//    if (self.empty_type == NoNetworkConnection_empty_num) {
//        return [NSLocalizedString(@"检查设置", @"检查设置") CreatMutableAttributedStringWithFont:PingFangSC_Regular(16) Color:ColorWithHex(0x4EA2FF, 1.0) LineSpacing:0 Alignment:NSTextAlignmentCenter BreakMode:NSLineBreakByTruncatingTail firstLineHeadIndent:0 headIndent:0 paragraphSpacing:0 WordSpace:0];
//    }else if (self.empty_type != succes_empty_num){
//        return [NSLocalizedString(@"重新加载", @"重新加载") CreatMutableAttributedStringWithFont:PingFangSC_Regular(16) Color:ColorWithHex(0x4EA2FF, 1.0) LineSpacing:0 Alignment:NSTextAlignmentCenter BreakMode:NSLineBreakByTruncatingTail firstLineHeadIndent:0 headIndent:0 paragraphSpacing:0 WordSpace:0];
//    }else if (self.empty_type == NoNetworkConnection_empty_num) {
//        return [NSLocalizedString(@"重新加载", @"重新加载") CreatMutableAttributedStringWithFont:PingFangSC_Regular(16) Color:ColorWithHex(0x4EA2FF, 1.0) LineSpacing:0 Alignment:NSTextAlignmentCenter BreakMode:NSLineBreakByTruncatingTail firstLineHeadIndent:0 headIndent:0 paragraphSpacing:0 WordSpace:0];
//    }
//    return nil;
//}
//- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
//
//}
//- (CGPoint)offsetForEmptyDataSet:(UIScrollView *)scrollView{
//      return CGPointMake(SCREENWIDTH*0.5, 300);
//}
//
//- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
//    return 30;
//}
//
//- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView{
//    return 15.0;
//}
    
//空白页的背景色
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIColor clearColor];
}
    
//是否显示空白页，默认YES
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return !self.isRefreshing;
}
    
//空白页点击事件
- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView {
    if([[ToolHelper shareToolHelper] isReachable]){
        if (self.empty_type != kRespondCodeSuccess && !self.isRefreshing) {
            [self.header beginRefreshing];
            [self.tableView reloadData];
        }
    }else{
        if (@available(iOS 9.0, *)) {
            CTCellularData *cellularData = [[CTCellularData alloc]init];
            if(cellularData.restrictedState == kCTCellularDataNotRestricted){
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
                [self presentViewControllerToSystemSetupWithTitle:@"您没有网络权限" WithMessage:[NSString stringWithFormat:@"请在设置>蜂窝移动网络>%@中打开网络使用权限",appCurName]];
            }else{
                [self RemindUsersToOpenDataOrWiFi];
            }
        }else{
            [self RemindUsersToOpenDataOrWiFi];
        }
    }
}
- (void)RemindUsersToOpenDataOrWiFi{
    [MBProgressHUD showPrompt:@"请打开您的手机数据流量或WIFI~"];
}
    
//- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView{
//
//}
    
- (void)networkStateChange{
    if(!self.isRefreshing){
        if(self.empty_type == NoNetworkConnection_empty_num){
            [self.header beginRefreshing];
        }
        [self reload];
    }
}

- (void)reload{
    [self.tableView reloadData];
}

- (void)presentViewControllerToSystemSetupWithTitle:(NSString *)title WithMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
@end

