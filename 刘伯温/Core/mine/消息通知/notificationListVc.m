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
        if ([json[@"result"] intValue] ==1){
            weakself.arry = nil;
            weakself.arry = [msgList mj_objectWithKeyValues:json];
            [weakself loadNewDataEndHeadsuccessSet:nil code:1 footerIsShow:YES hasMore:@"1"];
        }else{
             [weakself loadNewDataEndHeadfailureSet:nil errorCode:[json[@"result"] intValue]];
        }
    } failure:^(NSError *error) {
         [weakself loadNewDataEndHeadfailureSet:nil errorCode:999];
    }];
}

- (void)loadMoreData{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    if (self.arry.arry.count) {
        msgOne *last = self.arry.arry.lastObject;
        paramDict[@"last_id"] = last.msg_id;
    } else {
        paramDict[@"last_id"] = [NSNumber numberWithInt:0];
    }
    paramDict[@"token"] = TOKEN;
    paramDict[@"sign"] = [[LBToolModel sharedInstance] getSign:paramDict];
    
    kWeakSelf(self);
    [VBHttpsTool postWithURL:@"getMyMsg" params:paramDict success:^(id json) {
        if ([json[@"result"] intValue] ==1){
            msgList *tmp = [msgList mj_objectWithKeyValues:json];
            [weakself.arry.arry addObjectsFromArray:tmp.arry];
            NSString *hasMore = @"0";
            if (tmp.arry.count) {
                hasMore = @"1";
            }else{
                [MBProgressHUD showPrompt:@"没有更多消息了" toView:weakself.view];
            }
            [weakself loadMoreDataEndFootsuccessSet:nil hasMore:hasMore];
        }else{
            [weakself loadMoreDataEndFootfailureSet:nil errorCode:[json[@"result"] intValue] msg:json[@"info"]];
        }
    } failure:^(NSError *error) {
        [weakself loadMoreDataEndFootfailureSet:nil errorCode:999 msg:nil];
    }];
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
