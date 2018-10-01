//
//  CPRootVc.m
//  Core
//
//  Created by heiguohua on 2018/10/1.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "CPRootVc.h"

@implementation CPRootVc
- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"彩票";
    NSString *reqUrl =reqUrl = [ChatTool shareChatTool].basicConfig.CFLT;
    if(ISLOGIN){
        self.islogSuccessfully = NO;
        NSString *token =  [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        reqUrl = [reqUrl stringByAppendingString:token];
    }else{
        self.islogSuccessfully = YES;
    }
    self.title = [ChatTool shareChatTool].basicConfig.tab_ltTitle;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:reqUrl]];
    [self.webView loadRequest:request];
}
@end
