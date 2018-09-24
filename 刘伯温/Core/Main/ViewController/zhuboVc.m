//
//  zhuboVc.m
//  Core
//
//  Created by heiguohua on 2018/9/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "zhuboVc.h"

@interface zhuboVc ()

@end

@implementation zhuboVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.header beginRefreshing];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(oneloadNewData)
                                                 name:@"one"
                                               object:nil];
}
-(void)oneloadNewData{
    [self.header beginRefreshing];
}
- (void)loadNewData{
    WeakSelf
    [[ToolHelper shareToolHelper] getReAnchorListSuccess:^(id json, NSString *msg, NSInteger code) {
        NSArray *arr = [NSArray modelArrayWithClass:[LBAnchorListModel class] json:json[@"data"]];
        [weakSelf.arry removeAllObjects];
        [weakSelf.arry addObjectsFromArray:arr];
        [weakSelf ColoadNewDataEndHeadsuccessSet:nil code:[json[@"result"] intValue]  footerIsShow:NO hasMore:nil];
    } failure:^(NSInteger errorCode, NSString *msg) {
        [weakSelf ColoadNewDataEndHeadfailureSet:nil errorCode:errorCode];
    }];
}
@end
