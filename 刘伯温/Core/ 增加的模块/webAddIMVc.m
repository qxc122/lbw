//
//  webAddIMVc.m
//  Core
//
//  Created by heiguohua on 2018/9/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "webAddIMVc.h"

@interface webAddIMVc ()

@end

@implementation webAddIMVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addTwoView];
    LBGetVerCodeModel *dataBase =  [NSKeyedUnarchiver unarchiveObjectWithFile:PATH_base];
    NSString * reqUrl =dataBase.CFLT;
    NSString *token =  [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    reqUrl = [reqUrl stringByAppendingString:token];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:reqUrl]];
    [self.webView loadRequest:request];
    
    NSLog(@"url =%@",reqUrl);
    
    if(!self.title){
        self.title = @"彩票";
    }
}

- (void)addTwoView{
    UIButton *btn1 = [UIButton new];
    [self.view addSubview:btn1];
    btn1.restorationIdentifier = IM_VIEW_money;
    [btn1 setImage:[UIImage imageNamed:IM_VIEW_money] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [UIButton new];
    [self.view addSubview:btn2];
    btn2.restorationIdentifier = IM_VIEW_swith_WEB;
    [btn2 setImage:[UIImage imageNamed:IM_VIEW_swith_WEB] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat width = 50;
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view).offset(-55-IMkTabBarHeight);
        make.height.equalTo(@(width));
        make.width.equalTo(@(width));
    }];
    
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(btn2);
        make.bottom.equalTo(btn2.mas_top).offset(-20);
        make.height.equalTo(@(width));
        make.width.equalTo(@(width));
    }];
}

- (void)btnClick:(UIButton *)btn{
    if ([btn.restorationIdentifier isEqualToString:IM_VIEW_money]) {
        LBGetVerCodeModel *dataBase =  [NSKeyedUnarchiver unarchiveObjectWithFile:PATH_base];
        LBGetMyInfoModel *data =  [NSKeyedUnarchiver unarchiveObjectWithFile:PATH_UESRINFO];
        
        NSString *url = dataBase.payfor_url;
        url = [url stringByAppendingString:data.userID];
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
    } else {
        [self.navigationController popViewControllerAnimated:NO];
    }
}

@end
