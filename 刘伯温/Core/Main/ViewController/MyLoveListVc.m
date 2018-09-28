//
//  MyLoveListVc.m
//  Core
//
//  Created by heiguohua on 2018/9/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "MyLoveListVc.h"

@interface MyLoveListVc ()

@end

@implementation MyLoveListVc

- (void)viewDidLoad {
    [super viewDidLoad];

    if (ISLOGIN) {
        [self.header beginRefreshing];
    }else{
        self.empty_type = succes_empty_num;
        self.header.hidden = YES;
        self.NodataTitle = @"请先登录";
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(threeloadNewData)
                                                 name:@"three"
                                               object:nil];

}

-(void)threeloadNewData{
    if (ISLOGIN) {
        [self.header beginRefreshing];
    }
}
- (void)loadNewData{
    if (!ISLOGIN) {
        return;
    }
    WeakSelf
    self.Pagenumber = 1;
    [[ToolHelper shareToolHelper] getFcousListWithPage:[NSString stringWithFormat:@"%ld",(long)self.Pagenumber] success:^(id json, NSString *msg, NSInteger code) {
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
    [[ToolHelper shareToolHelper] getFcousListWithPage:[NSString stringWithFormat:@"%ld",(long)self.Pagenumber] success:^(id json, NSString *msg, NSInteger code) {
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
