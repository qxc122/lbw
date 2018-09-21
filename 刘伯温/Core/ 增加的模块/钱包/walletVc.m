//
//  walletVc.m
//  Core
//
//  Created by heiguohua on 2018/9/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "walletVc.h"
#import "walletHead.h"
#import "LBDepositViewController.h"
#import "WithdrawalApplicationVc.h"
@interface walletVc ()
@property(nonatomic, strong)NSArray *titleArr;
@property(nonatomic, strong)NSArray *imageArr;
@property (nonatomic,weak)walletHead *head;

@end

@implementation walletVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"钱包";
    self.registerCells = @[@"UITableViewCell"];
    self.titleArr = @[@[@"充值",@"提现"],@[@"购买卡密",@"转换现金"]];
    self.imageArr = @[@[WALLET_ONE,WALLET_TWO],@[WALLET_THREE,WALLET_FOUR]];
    self.empty_type = succes_empty_num;
    self.header.hidden = YES;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    walletHead *head = [[walletHead alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 120)];
    self.head = head;
    self.tableView.tableHeaderView = head;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:@"chageUserInfoNotifi" object:nil];
}

- (void)loadNewData{
    kWeakSelf(self);
    [[ToolHelper shareToolHelper]getUserInfosuccess:^(id dataDict, NSString *msg, NSInteger code) {
        LBGetMyInfoModel *data = [LBGetMyInfoModel mj_objectWithKeyValues:dataDict[@"data"]];
        [NSKeyedArchiver archiveRootObject:data toFile:PATH_UESRINFO];
        weakself.head.data = data;
        [weakself loadNewDataEndHeadsuccessSet:nil code:code footerIsShow:NO hasMore:nil];
        weakself.header.hidden = YES;
    } failure:^(NSInteger errorCode, NSString *msg) {
        [weakself loadNewDataEndHeadfailureSet:nil errorCode:errorCode];
    }];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *tmp = self.titleArr[indexPath.section];
    NSString *rowTitle = tmp[indexPath.row];
    
    if ([rowTitle isEqualToString:@"充值"]) {
        LBGetVerCodeModel *dataBase =  [NSKeyedUnarchiver unarchiveObjectWithFile:PATH_base];
        LBGetMyInfoModel *data =  [NSKeyedUnarchiver unarchiveObjectWithFile:PATH_UESRINFO];
        
        NSString *url = dataBase.payfor_url;
        url = [url stringByAppendingString:data.userID];
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
    } else if ([rowTitle isEqualToString:@"提现"]) {
        [MBProgressHUD showPrompt:@"暂无提现功能，请转入游戏平台提现" toView:self.view];
//        WithdrawalApplicationVc *VC = [WithdrawalApplicationVc new];
//        [self.navigationController pushViewController:VC animated:YES];
    } else if ([rowTitle isEqualToString:@"购买卡密"]) {
        [self selectBuyCard];
    } else if ([rowTitle isEqualToString:@"转换现金"]) {
        LBDepositViewController *VC = [[LBDepositViewController alloc]initWithNibName:@"LBDepositViewController" bundle:nil];
        LBGetMyInfoModel *data =  [NSKeyedUnarchiver unarchiveObjectWithFile:PATH_UESRINFO];
        VC.amount = [NSString stringWithFormat:@"%.2f",[data.amount floatValue]+[data.freezing floatValue]];
        [self.navigationController pushViewController:VC animated:YES];
    }
}

- (void)selectBuyCard{
    kWeakSelf(self);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择卡密类型" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"月卡(188元)" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakself BuyCard:0];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"季卡(188元)" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakself BuyCard:1];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"半年卡(188元)" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakself BuyCard:2];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"年卡(188元)" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakself BuyCard:3];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)BuyCard:(NSInteger)vipType{
    kWeakSelf(self);
//    [MBProgressHUD showLoadingMessage:@"购买中..." toView:self.view];
//    [[ToolHelper shareToolHelper] CP_url_buyCardWithvipType:[NSNumber numberWithInteger:vipType] success:^(id dataDict, NSString *msg, NSInteger code) {
//        [MBProgressHUD hideHUDForView:weakself.view];
//        [MBProgressHUD showPrompt:msg];
//    } failure:^(NSInteger errorCode, NSString *msg) {
//        [MBProgressHUD hideHUDForView:weakself.view];
//        [MBProgressHUD showPrompt:msg];
//    }];
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"vipType"] = [NSNumber numberWithInteger:vipType] ;
    paramDict[@"token"] = TOKEN;
    paramDict[@"sign"] = [[LBToolModel sharedInstance] getSign:paramDict];

    [MBProgressHUD showLoadingMessage:@"购买中..." toView:self.view];
    [VBHttpsTool postWithURL:@"buyCard" params:paramDict success:^(id json) {
        [MBProgressHUD hideHUDForView:weakself.view];
        [MBProgressHUD showPrompt:json[@"info"]];
        if ([json[@"result"] intValue] ==1){
            weakself.header.hidden = NO;
            [weakself.header beginRefreshing];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakself.view];
        [MBProgressHUD showPrompt:@"请重试"];
    }];
            
            
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFullWidth, 10)];
    sectionView.backgroundColor = BackGroundColor;
    return sectionView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}


#pragma --mark< UITableViewDelegate 高>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *tmp = self.titleArr[section];
    return tmp.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *myCell = @"mineCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myCell];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:myCell];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSArray *tmp = self.titleArr[indexPath.section];
    NSArray *tmp2 = self.imageArr[indexPath.section];
    cell.imageView.image = [UIImage imageNamed:tmp2[indexPath.row]];
    cell.textLabel.text = tmp[indexPath.row];
    if (indexPath.section == 0 && indexPath.row == 1) {
        LBGetMyInfoModel *data =  [NSKeyedUnarchiver unarchiveObjectWithFile:PATH_UESRINFO];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"当前可提现金额(%.2f元)",[data.amount floatValue]];
    } else {
        cell.detailTextLabel.text = nil;
    }

    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

@end
