//
//  zhiboAndWebVc.m
//  Core
//
//  Created by heiguohua on 2018/9/12.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "zhiboAndWebVc.h"

@interface zhiboAndWebVc ()

@end

@implementation zhiboAndWebVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    UIButton *likeButton = [UIButton buttonWithType:0];
    likeButton.frame = CGRectMake(SCREENWIDTH - SCREENWIDTH/10-width_zhibo*0.5, kFullHeight-kTabBarHeight, width_zhibo, width_zhibo);
    [likeButton setBackgroundImage:[UIImage imageNamed:zhiboAndWebVcPNG] forState:0];
    [likeButton setBackgroundImage:[UIImage imageNamed:zhiboAndWebVcPNG] forState:UIControlStateHighlighted];
    [likeButton addTarget:self action:@selector(likeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:likeButton];
    
    
    LBGetVerCodeModel *dataBase =  [NSKeyedUnarchiver unarchiveObjectWithFile:PATH_base];
    NSString * reqUrl =dataBase.CFLT;
    NSString *token =  [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    reqUrl = [reqUrl stringByAppendingString:token];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:reqUrl]];
    [self.webView loadRequest:request];

}
- (void)likeButtonClick{
    [self.navigationController popViewControllerAnimated:NO];
}

@end
