//
//  webAddIMVc.m
//  Core
//
//  Created by heiguohua on 2018/9/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "webAddIMVc.h"

@interface webAddIMVc ()
@property (nonatomic,weak) UIButton *btn0;
@property (nonatomic,weak) UIButton *btn1;
@property (nonatomic,weak) UIButton *btn2;

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
    UIButton *btn0 = [UIButton new];
    [self.view addSubview:btn0];
    self.btn0 = btn0;
    btn0.restorationIdentifier = zhiboAndWebVcPNG;
    [btn0 setImage:[UIImage imageNamed:zhiboAndWebVcPNG] forState:UIControlStateNormal];
    [btn0 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn1 = [UIButton new];
    [self.view addSubview:btn1];
    self.btn1 = btn1;
    btn1.restorationIdentifier = IM_VIEW_money;
    [btn1 setImage:[UIImage imageNamed:IM_VIEW_money] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [UIButton new];
    self.btn2 = btn2;
    [self.view addSubview:btn2];
    btn2.restorationIdentifier = IM_VIEW_swith_WEB;
    [btn2 setImage:[UIImage imageNamed:IM_VIEW_swith_WEB] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat width = 40;
    [btn0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view).offset(-55-IMkTabBarHeight);
        make.height.equalTo(@(width));
        make.width.equalTo(@(width));
    }];
    
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(btn0);
        make.bottom.equalTo(btn0.mas_top).offset(-15);
        make.height.equalTo(@(width));
        make.width.equalTo(@(width));
    }];
    
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(btn2);
        make.bottom.equalTo(btn2.mas_top).offset(-15);
        make.height.equalTo(@(width));
        make.width.equalTo(@(width));
    }];
}
- (void)sendFront{
    [self.view bringSubviewToFront:self.btn1];
    [self.view bringSubviewToFront:self.btn2];
    [self.view bringSubviewToFront:self.btn0];
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
    }else if ([btn.restorationIdentifier isEqualToString:zhiboAndWebVcPNG]) {
        
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
            LBGetVerCodeModel *data =  [NSKeyedUnarchiver unarchiveObjectWithFile:PATH_base];
            if ([data.isFree intValue]){
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
    } else {
        [self.navigationController popViewControllerAnimated:NO];
    }
}

@end
