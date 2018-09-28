//
//  LBActivationListViewController.m
//  Core
//
//  Created by mac on 2017/9/30.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LBActivationListViewController.h"
#import "LBActivationListCell.h"
#import <MJRefresh.h>

@interface LBActivationListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *contentArr;
@property(nonatomic, assign)int page;

@end

@implementation LBActivationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.contentArr = [NSMutableArray array];
    self.title = @"充值记录";
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.rowHeight = 100;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = CustomColor(236, 237, 236, 1);
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LBActivationListCell class]) bundle:nil] forCellReuseIdentifier:@"LBActivationListCell"];

    [self getContentData];
}

- (void)getContentData{
    self.page = 1;
    
    [self getActivationCardList:YES];
    WeakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [self getActivationCardList:YES];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    
    //    //上拉加载
    self.tableView.mj_footer=[MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf getActivationCardList:NO];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
    
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.contentArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LBActivationListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBActivationListCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.contentArr[indexPath.row];
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)getActivationCardList:(BOOL)isHead{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    WeakSelf
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"token"] = TOKEN;
    paramDict[@"row"] = @"20";
    paramDict[@"page"] = [NSString stringWithFormat:@"%d",self.page];
    paramDict[@"sign"] = [[LBToolModel sharedInstance]getSign:paramDict];
    [VBHttpsTool postWithURL:@"getActivationCardList" params:paramDict success:^(id json) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if ([json[@"result"] intValue] == 1){
            if (isHead){
                [weakSelf.contentArr removeAllObjects];
            }
            NSArray *arr = [NSArray modelArrayWithClass:[LBGetActivationCardListModel class] json:json[@"data"]];
            if (isHead &&!arr.count){
                [MBProgressHUD showMessage:@"暂无充值记录" finishBlock:nil];
            }
            if (!arr.count || arr.count<20){
                self.tableView.mj_footer.hidden = YES;
            }
            [weakSelf.contentArr addObjectsFromArray:arr];
            [weakSelf.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
