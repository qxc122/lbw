//
//  notificationListVc.m
//  Core
//
//  Created by heiguohua on 2018/9/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "notificationListVc.h"
#import "notificationCell.h"
#import "noticationDesVc.h"

@interface notificationListVc ()
@property (nonatomic,strong) msgList *arry; 
@end

@implementation notificationListVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息通知";
    self.navigationController.navigationBar.translucent = NO;
    self.registerCells = @[@"notificationCell"];
    [self.header beginRefreshing];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:PNG_bar_right] style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
}
- (void)loadNewData{

    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"last_id"] = [NSNumber numberWithInt:0];
    paramDict[@"token"] = TOKEN;
    paramDict[@"sign"] = [[LBToolModel sharedInstance] getSign:paramDict];

    kWeakSelf(self);
    [VBHttpsTool postWithURL:@"getMyMsg" params:paramDict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([json[@"result"] intValue] ==1){
            weakself.arry = [msgList mj_objectWithKeyValues:json];
            [weakself loadNewDataEndHeadsuccessSet:nil code:1 footerIsShow:NO hasMore:nil];
        }else{
             [weakself loadNewDataEndHeadfailureSet:nil errorCode:[json[@"result"] intValue]];
        }
    } failure:^(NSError *error) {
         [weakself loadNewDataEndHeadfailureSet:nil errorCode:999];
    }];

//    kWeakSelf(self);
//    [[ToolHelper shareToolHelper]CP_getMyMsgWithlastId:[NSNumber numberWithInt:0] success:^(id dataDict, NSString *msg, NSInteger code) {
//        [weakself loadNewDataEndHeadsuccessSet:nil code:code footerIsShow:NO hasMore:nil];
//    } failure:^(NSInteger errorCode, NSString *msg) {
//        [weakself loadNewDataEndHeadfailureSet:nil errorCode:errorCode];
//    }];
}
- (void)rightClick{
    NSString *url = @"https://kf1.learnsaas.com/chat/chatClient/chatbox.jsp?companyID=814050&configID=62885&jid=3341006926&s=1";
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 100;
//}

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
    notificationCell *cell = [notificationCell returnCellWith:tableView];
    [self configurenotificationCell:cell atIndexPath:indexPath];
    return  cell;
}

- (void)configurenotificationCell:(notificationCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.one = self.arry.arry[indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    noticationDesVc *vc = [noticationDesVc new];
    vc.one = self.arry.arry[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
