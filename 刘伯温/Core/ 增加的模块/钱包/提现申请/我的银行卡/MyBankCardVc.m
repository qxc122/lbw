//
//  MyBankCardVc.m
//  Core
//
//  Created by heiguohua on 2018/9/11.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "MyBankCardVc.h"
#import "AddBankCardVc.h"
#import "bankCell.h"

@interface MyBankCardVc ()
@property (nonatomic,strong) bankList *arry;
@end

@implementation MyBankCardVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的银行卡";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightClick)];
    self.registerCells = @[@"bankCell"];
    [self.header beginRefreshing];
    self.NodataTitle = @"您还没有绑定过银行卡";
}
- (void)loadNewData{
    kWeakSelf(self);
    [[ToolHelper shareToolHelper] myBankCardListsuccess:^(id dataDict, NSString *msg, NSInteger code) {
        weakself.arry = [bankList mj_objectWithKeyValues:dataDict];
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
    bankCell *cell = [bankCell returnCellWith:tableView];
    [self configurebankCell:cell atIndexPath:indexPath];
    return  cell;
}

- (void)configurebankCell:(bankCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.one = self.arry.arry[indexPath.row];
}


- (void)rightClick{
    AddBankCardVc *vc =[AddBankCardVc new];
    [self OPenVc:vc];
}

@end
