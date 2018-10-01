//
//  zhiboAndWebVc.m
//  Core
//
//  Created by heiguohua on 2018/9/12.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "zhiboAndWebVc.h"

@interface zhiboAndWebVc ()
@property (nonatomic,weak) UIButton *likeButton;
@end

@implementation zhiboAndWebVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    UIButton *likeButton = [UIButton buttonWithType:0];
    self.likeButton  =likeButton;
    likeButton.frame = CGRectMake(SCREENWIDTH - SCREENWIDTH/10-width_zhibo*0.5, kFullHeight-kTabBarHeight, width_zhibo, width_zhibo);
    [likeButton setBackgroundImage:[UIImage imageNamed:zhiboAndWebVcPNG] forState:0];
    [likeButton setBackgroundImage:[UIImage imageNamed:zhiboAndWebVcPNG] forState:UIControlStateHighlighted];
    [likeButton addTarget:self action:@selector(likeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:likeButton];
    
    NSString * reqUrl =[ChatTool shareChatTool].basicConfig.CFLT;
    NSString *token =  [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    reqUrl = [reqUrl stringByAppendingString:token];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:reqUrl]];
    [self.webView loadRequest:request];

    
    NSLog(@"url =%@",reqUrl);
}
- (void)likeButtonClick{
    if ([[ChatTool shareChatTool].basicConfig.live_of isEqualToString:@"1"]) {
        [MBProgressHUD showPrompt:@"直播暂时关闭"];
    } else {
        
        UIViewController *chatRoom;
        for (UIViewController *tmp  in self.navigationController.childViewControllers) {
            if ([tmp isKindOfClass:[LiveBroadcastVc class]]) {
                chatRoom = tmp;
                break;
            }
        }
        if (chatRoom) {
            [self.navigationController popToViewController:chatRoom animated:YES];
        } else {
            LBAnchorListModel *model =  [NSKeyedUnarchiver unarchiveObjectWithFile:PATH_OF_ZHUBO];
            if ([[ChatTool shareChatTool].basicConfig.isFree intValue]){
                NSString *expirationDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"expirationDate"];
                NSDateFormatter *format = [[NSDateFormatter alloc] init];
                format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                NSDate *oneData = [format dateFromString:expirationDate];
                NSString *type = [[NSUserDefaults standardUserDefaults] objectForKey:@"type"];
                
                if ([type isEqualToString:@"0"]){
                    [self joinMembership];
                    return;
                }else if([NSDate date].timeIntervalSince1970 >= oneData.timeIntervalSince1970){
                    [self RenewalFee];
                    return;
                }
            }
            NSLog(@"%@\n\n\n\n\n\nhhhhhhhhh",model.anchorLiveUrl);
            LiveBroadcastVc *vc =[LiveBroadcastVc new];
            vc.anchorLiveUrl = model.anchorLiveUrl;
            
            vc.anchorID = model.anchorID;
            vc.livePlatID = model.livePlatID;
            vc.iconUrl = model.anchorThumb;
            vc.nickname = model.anchorName;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

@end
