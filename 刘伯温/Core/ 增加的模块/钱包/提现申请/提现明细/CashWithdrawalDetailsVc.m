//
//  CashWithdrawalDetailsVc.m
//  Core
//
//  Created by heiguohua on 2018/9/11.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "CashWithdrawalDetailsVc.h"
#import "WithdrawalCell.h"

@interface CashWithdrawalDetailsVc ()
@property (nonatomic,strong) WithdrawalList *arry; 
@end

@implementation CashWithdrawalDetailsVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"提现明细";
    self.registerCells = @[@"WithdrawalCell"];
    [self.header beginRefreshing];
    self.NodataTitle = @"暂无记录";
}

- (void)loadNewData{
    kWeakSelf(self);
    [[ToolHelper shareToolHelper] submitCashLogWithpage:[NSNumber numberWithInt:0] row:[NSNumber numberWithInt:50] success:^(id dataDict, NSString *msg, NSInteger code) {
        weakself.arry = [WithdrawalList mj_objectWithKeyValues:dataDict];
        [weakself loadNewDataEndHeadsuccessSet:nil code:code footerIsShow:NO hasMore:nil];
    } failure:^(NSInteger errorCode, NSString *msg) {
        [weakself loadNewDataEndHeadfailureSet:nil errorCode:errorCode];
    }];

}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arry.arry.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.empty_type == succes_empty_num) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WithdrawalCell *cell = [WithdrawalCell returnCellWith:tableView];
    [self configureWithdrawalCell:cell atIndexPath:indexPath];
    return  cell;
}

- (void)configureWithdrawalCell:(WithdrawalCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.one = self.arry.arry[indexPath.row];
}

@end
