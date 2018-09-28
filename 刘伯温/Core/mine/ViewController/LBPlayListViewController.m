//
//  LBPlayListViewController.m
//  Core
//
//  Created by mac on 2017/9/30.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LBPlayListViewController.h"

@interface LBPlayListViewController ()

@end

@implementation LBPlayListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.header beginRefreshing];
}

- (void)loadNewData{
    WeakSelf
    self.Pagenumber = 1;
    [[ToolHelper shareToolHelper] getPlayeListWithPage:[NSString stringWithFormat:@"%ld",(long)self.Pagenumber] success:^(id json, NSString *msg, NSInteger code) {
        NSArray *arr = [NSArray modelArrayWithClass:[LBAnchorListModel class] json:json[@"data"]];
        [weakSelf.arry removeAllObjects];
        [weakSelf.arry addObjectsFromArray:arr];
        
        BOOL isShow = NO;
        NSString *more = nil;
        if (arr.count >= 20) {
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
    [[ToolHelper shareToolHelper] getPlayeListWithPage:[NSString stringWithFormat:@"%ld",(long)self.Pagenumber] success:^(id json, NSString *msg, NSInteger code) {
        NSArray *arr = [NSArray modelArrayWithClass:[LBAnchorListModel class] json:json[@"data"]];
        [weakSelf.arry addObjectsFromArray:arr];
        NSString *more = nil;
        if (arr.count >= 20) {
            more = @"1";
        }else{
            more = nil;
        }
        [weakSelf ColoadMoreDataEndFootsuccessSet:nil hasMore:more];
    } failure:^(NSInteger errorCode, NSString *msg) {
        [weakSelf ColoadMoreDataEndFootfailureSet:nil errorCode:errorCode msg:msg];
    }];
}
@end
