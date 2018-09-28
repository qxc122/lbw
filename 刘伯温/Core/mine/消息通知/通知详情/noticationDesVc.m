//
//  noticationDesVc.m
//  Core
//
//  Created by heiguohua on 2018/9/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "noticationDesVc.h"
#import "Masonry.h"

@interface noticationDesVc ()
@property (nonatomic,weak) UIWebView *des;
@end

@implementation noticationDesVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通知详情";
    UIWebView *des = [UIWebView new];
    self.des = des;
    [self.view addSubview:des];
    [self.des mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(-0);
        make.top.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(-0);
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:PNG_bar_right] style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    [self.des loadHTMLString:self.one.msg baseURL:nil];
}
- (void)rightClick{
    NSString *url = @"https://kf1.learnsaas.com/chat/chatClient/chatbox.jsp?companyID=814050&configID=62885&jid=3341006926&s=1";
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

@end
