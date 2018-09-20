//
//  LBMineRootViewController.m
//  Core
//
//  Created by mac on 2017/9/19.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LBMineRootViewController.h"
#import "LBMineHeadView.h"
#import "LBFeedBackViewController.h"
#import "LBLoginViewController.h"
#import "LBEnditUserViewController.h"
#import "LBPlayListViewController.h"
#import "LBRechargerViewController.h"
#import "LBShowRemendView.h"
#import "LBInvitationCodeViewController.h"
#import "LBGiftStrorViewController.h"
#import "LBSettingViewController.h"
#import "LBDepositViewController.h"
#import "LBExchangeGoldView.h"
#import "notificationListVc.h"
#import "walletVc.h"
@interface LBMineRootViewController()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)NSArray *titleArr;
@property(nonatomic, strong)NSArray *imageArr;
@property(nonatomic, strong)LBMineHeadView *headView;
@property (nonatomic,strong) NSString *appUrl;
@property(nonatomic, strong)LBGetMyInfoModel *myinfoModel;
//@property(nonatomic, strong)UIButton *goldButton;
//@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)UILabel *descLabel;

@end

@implementation LBMineRootViewController
- (void)hideBottomBarWhenPush{}
- (void)customBackButton{}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    self.title = @"我的";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"more_setting"] style:UIBarButtonItemStylePlain target:self action:@selector(settingButtonClick)];

//    self.titleArr = @[@"卡密激活",@"转换现金",@"在线客服",@"金币商城",@"邀请好友",@"点播历史记录",@"我关注的主播",@"意见反馈",@"检查更新"];
//    self.imageArr = @[@"gerenxinxi_r11_c2",@"wode_trancel",@"wode_online_call",@"ic_jifeng",@"ic_yaoqing",@"wode_r2_c2",@"wode_r8_c1",@"wode_r17_c3",@"wode_r15_c4"];
    
    self.titleArr = @[@[@"消息通知"],@[@"充值",@"卡密激活",@"转换现金"],@[@"在线客服",@"金币商城",@"邀请好友"],@[@"点播历史",@"我关注的主播",@"意见反馈"]];
    self.imageArr = @[@[@"myset_msg"],@[@"myset_recharge",@"myic_amount_vip",@"mywode_trancel"],@[@"mywode_online_call",@"myic_jifeng",@"ic_yaoqing"],@[@"mywode_r2_c2",@"mywode_r8_c1",@"mywode_r15_c4",@"wode_r15_c4"]];

    WeakSelf
    LBMineHeadView *headView = [[LBMineHeadView alloc] initWithFrame:CGRectMake(0, 0, kFullWidth, 250.5-64)];
    self.tableView.tableHeaderView = headView;
    self.headView = headView;
    headView.clickEnditBlock = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!ISLOGIN){
                [LBShowRemendView showRemendViewText:@"您还没有登录，请先登录" andTitleText:@"提示" andEnterText:@"确定" andEnterBlock:^{
                    UIWindow *window = [UIApplication sharedApplication].keyWindow;
                    [window removeAllSubviews];
                    window = nil;
                    LBLoginViewController *vc = [[LBLoginViewController alloc] initWithNibName:@"LBLoginViewController" bundle:nil];
                    LBNavigationController *nav = [[LBNavigationController alloc]initWithRootViewController:vc];
                    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
                    
//                    [UIApplication sharedApplication].keyWindow.rootViewController = [[LBLoginViewController alloc] initWithNibName:@"LBLoginViewController" bundle:nil];
                }];
                return;
            }
            LBEnditUserViewController *VC = [LBEnditUserViewController new];
            VC.infoModel = weakSelf.myinfoModel;
            [weakSelf.navigationController pushViewController:VC animated:YES];
        });
    };
    
    headView.clickGoldBlock = ^{
        [LBExchangeGoldView showRemendViewText:@"当前金币可以兑换成金额，是否需要兑换？" andTitleText:@"兑换" andEnterText:@"确定" andCancelText:@"取消" andEnterBlock:^{
            [weakSelf getMyInfo];
        } andCancelBlock:^{
            
        }];
    };
    headView.moneyButtonBlock = ^{
        walletVc *VC = [walletVc new];
        [weakSelf.navigationController pushViewController:VC animated:YES];
    };

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMyInfo) name:@"chageUserInfoNotifi" object:nil];
    self.header.hidden = YES;
    self.empty_type = succes_empty_num;
    
    self.myinfoModel = [NSKeyedUnarchiver unarchiveObjectWithFile:PATH_UESRINFO];
    self.headView.infoModel = self.myinfoModel;
}
- (void)settingButtonClick{
    kWeakSelf(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!ISLOGIN){
            [LBShowRemendView showRemendViewText:@"您还没有登录，请先登录" andTitleText:@"提示" andEnterText:@"确定" andEnterBlock:^{
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                [window removeAllSubviews];
                window = nil;
                LBLoginViewController *vc = [[LBLoginViewController alloc] initWithNibName:@"LBLoginViewController" bundle:nil];
                LBNavigationController *nav = [[LBNavigationController alloc]initWithRootViewController:vc];
                [UIApplication sharedApplication].keyWindow.rootViewController = nav;
                
                //                    [UIApplication sharedApplication].keyWindow.rootViewController = [[LBLoginViewController alloc] initWithNibName:@"LBLoginViewController" bundle:nil];
            }];
            return;
        }
        LBSettingViewController *VC = [LBSettingViewController new];
        [weakself.navigationController pushViewController:VC animated:YES];
    });
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *tmp = self.titleArr[section];
    return tmp.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFullWidth, 10)];
    sectionView.backgroundColor = BackGroundColor;
    return sectionView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *myCell = @"mineCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myCell];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCell];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSArray *tmp = self.titleArr[indexPath.section];
    NSArray *tmp2 = self.imageArr[indexPath.section];
    cell.imageView.image = [UIImage imageNamed:tmp2[indexPath.row]];
    cell.textLabel.text = tmp[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!ISLOGIN){
        [self jurisdiction];
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *tmp = self.titleArr[indexPath.section];
    NSString *rowTitle = tmp[indexPath.row];

    if ([rowTitle isEqualToString:@"消息通知"]) {
        notificationListVc *VC= [notificationListVc new];
        [self.navigationController pushViewController:VC animated:YES];
    } else if ([rowTitle isEqualToString:@"充值"]) {
        LBGetVerCodeModel *dataBase =  [NSKeyedUnarchiver unarchiveObjectWithFile:PATH_base];
        LBGetMyInfoModel *data =  [NSKeyedUnarchiver unarchiveObjectWithFile:PATH_UESRINFO];
        NSString *url = dataBase.payfor_url;
        url = [url stringByAppendingString:data.userID];
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
    } else if ([rowTitle isEqualToString:@"卡密激活"]) {
        LBRechargerViewController *VC = [[LBRechargerViewController alloc] initWithNibName:@"LBRechargerViewController" bundle:nil];
        [self.navigationController pushViewController:VC animated:YES];
    } else if ([rowTitle isEqualToString:@"转换现金"]) {
        LBDepositViewController *VC = [[LBDepositViewController alloc]initWithNibName:@"LBDepositViewController" bundle:nil];
        [self.navigationController pushViewController:VC animated:YES];
        VC.amount = [NSString stringWithFormat:@"%.2f",[self.myinfoModel.amount floatValue]+[self.myinfoModel.freezing floatValue]];
    } else if ([rowTitle isEqualToString:@"在线客服"]) {
        NSString *url = @"https://kf1.learnsaas.com/chat/chatClient/chatbox.jsp?companyID=814050&configID=62885&jid=3341006926&s=1";
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
    } else if ([rowTitle isEqualToString:@"金币商城"]) {
        LBGiftStrorViewController *VC= [LBGiftStrorViewController new];
        [self.navigationController pushViewController:VC animated:YES];
    } else if ([rowTitle isEqualToString:@"邀请好友"]) {
        LBInvitationCodeViewController *VC = [[LBInvitationCodeViewController alloc] initWithNibName:@"LBInvitationCodeViewController" bundle:nil];
        [self.navigationController pushViewController:VC animated:YES];
    } else if ([rowTitle isEqualToString:@"点播历史"]) {
        LBPlayListViewController *VC = [LBPlayListViewController new];
        VC.inerName = @"getPlayeList";
        VC.title = @"历史记录";
        [self.navigationController pushViewController:VC animated:YES];
    } else if ([rowTitle isEqualToString:@"我关注的主播"]) {
        LBPlayListViewController *VC = [LBPlayListViewController new];
        VC.title = @"关注的主播";
        VC.inerName = @"getFcousList";
        [self.navigationController pushViewController:VC animated:YES];
    } else if ([rowTitle isEqualToString:@"意见反馈"]) {
        LBFeedBackViewController *VC = [LBFeedBackViewController new];
        VC.title = @"意见反馈";
        [self.navigationController pushViewController:VC animated:YES];
    } else if ([rowTitle isEqualToString:@"检查更新"]) {

    }
}

- (void)jurisdiction{
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getMyInfo];
    [self getBaseConfig];
}

- (void)getBaseConfig{
    [[ToolHelper shareToolHelper]getBaseConfigSuccess:^(id dataDict, NSString *msg, NSInteger code) {
        NSLog(@"在我的页面 基础信息获取成功");
        LBGetVerCodeModel *model = [LBGetVerCodeModel modelWithJSON:dataDict[@"data"]];
        [NSKeyedArchiver archiveRootObject:model toFile:PATH_base];
    } failure:^(NSInteger errorCode, NSString *msg) {

    }];
}

- (void)getMyInfo{
    if (!ISLOGIN)return;
    WeakSelf
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"timestamp"] = [[LBToolModel sharedInstance] getTimestamp];
    paramDict[@"token"] = TOKEN;
    paramDict[@"sign"] = [[LBToolModel sharedInstance] getSign:paramDict];
    [VBHttpsTool postWithURL:@"getMyInfo" params:paramDict success:^(id json) {
        if ([json[@"result"] intValue] ==1){
            
            weakSelf.myinfoModel = [LBGetMyInfoModel modelWithJSON:json[@"data"]];
            [NSKeyedArchiver archiveRootObject:weakSelf.myinfoModel toFile:PATH_UESRINFO];
            [[NSUserDefaults standardUserDefaults]setObject:weakSelf.myinfoModel.address forKey:@"DeliveryAddress"];
            [[NSUserDefaults standardUserDefaults]setObject:weakSelf.myinfoModel.integral forKey:@"integral"];
            [[NSUserDefaults standardUserDefaults] setObject:weakSelf.myinfoModel.expirationDate forKey:@"expirationDate"];
            [[NSUserDefaults standardUserDefaults] setBool:(weakSelf.myinfoModel.address.length ||weakSelf.myinfoModel.phone.length||weakSelf.myinfoModel.surname.length) forKey:@"hasFullInfo"];
             NSLog(@"获取个人信息成功");
            weakSelf.headView.infoModel = weakSelf.myinfoModel;
        }
    } failure:^(NSError *error) {
        NSLog(@"获取个人信息失败");
    }];
}

@end

