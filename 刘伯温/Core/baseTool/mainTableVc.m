//
//  mainTableVc.m
//  portal
//
//  Created by Store on 2017/9/25.
//  Copyright © 2017年 qxc122@126.com. All rights reserved.
//

#import "mainTableVc.h"
#import "baseWkVc.h" 
#import "LBNavigationController.h"
#import "LBMineRootViewController.h"
#import "DHGuidePageHUD.h"
#import "WHC_GestureUnlockScreenVC.h"
#import "LBShowRemendView.h"
#import "LBLoginViewController.h"
#import "AdvertisingVc.h"
#import "LBWMainVc.h"
@interface mainTableVc ()<UITabBarControllerDelegate>
@property (nonatomic,strong) NSString *appUrl;

@end

@implementation mainTableVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.tabBar.translucent = NO;
    [self setUpChildVC];
    [self upadateApp];
    self.delegate = self;
    [[ChatTool shareChatTool] StartWork];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.isaidong isEqualToString:@"1"]) {
        self.isaidong = @"0";

        UIViewController *NaVC = self;
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ConfigurationKey"]){
            WHC_GestureUnlockScreenVC  * unlockVC = [WHC_GestureUnlockScreenVC new];
            unlockVC.unlockType = ClickNumberType;
            [self  presentViewController:unlockVC animated:NO completion:nil];
            NaVC = self.presentedViewController;
        }
        AdvertisingVc *vc =[AdvertisingVc new];
        [NaVC presentViewController:vc animated:NO completion:nil];
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController NS_AVAILABLE_IOS(3_0){
    if ([viewController isKindOfClass:[LBNavigationController class]]) {
        UINavigationController *tmp = (UINavigationController *)viewController;
        if([tmp.topViewController isKindOfClass:[JCHATConversationViewController class]] || [tmp.topViewController isKindOfClass:[LBMineRootViewController class]]){
            if(ISLOGIN){
                return YES;
            }else{
                [LBShowRemendView showRemendViewText:@"您还没有登录，请先登录" andTitleText:@"提示" andEnterText:@"确定" andEnterBlock:^{
                    UIWindow *window = [UIApplication sharedApplication].keyWindow;
                    [window removeAllSubviews];
                    window = nil;
                    LBLoginViewController *vc = [[LBLoginViewController alloc] initWithNibName:@"LBLoginViewController" bundle:nil];
                    LBNavigationController *nav = [[LBNavigationController alloc]initWithRootViewController:vc];
                    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
                }];
                return NO;
            }
        }
    }
    return YES;
}
- (void)setUpChildVC {

    LBWMainVc *mainVC = [LBWMainVc new];
    [self setChildVC:mainVC title:@"VIP俱乐" image:@"tab_live" selectedImage:@"tab_live_press"];
    
    baseWkVc *webVC3 = [baseWkVc new];
    [self setChildVC:webVC3 title:@"娱乐城" image:@"tab_lbw" selectedImage:@"tab_lbw_press"];
    
    JCHATConversationViewController *webVC = [JCHATConversationViewController new];
    webVC.gotoZhiBoVc = YES;
    [self setChildVC:webVC title:@"聊天室" image:@"tab_lt" selectedImage:@"tab_lt_press"];
    
    baseWkVc *webVC2 = [baseWkVc new];
    [self setChildVC:webVC2 title:@"彩票" image:@"tab_cp" selectedImage:@"tab_cp_press"];
    
    LBMineRootViewController *mineVC = [LBMineRootViewController new];
    [self setChildVC:mineVC title:@"我的" image:@"tab_my" selectedImage:@"tab_my_press"];
}

- (void)setChildVC:(UIViewController *)childVC title:(NSString *)title image:(NSString *) image selectedImage:(NSString *) selectedImage {
    childVC.title = title;
    childVC.tabBarItem.title = title;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    [childVC.tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName:MainColor} forState:UIControlStateSelected];
    [childVC.tabBarItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    childVC.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    LBNavigationController *nav = [[LBNavigationController alloc] initWithRootViewController:childVC];
    nav.title = title;
    //    nav.delegate = self;
    [self addChildViewController:nav];
}

#pragma mark - app更新检测
- (void)upadateApp{
    NSString *url = [ChatTool shareChatTool].basicConfig.ios_update_check;
    url = [url stringByTrimmingCharactersInSet:
           [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //1.获取一个全局串行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    
    //2.把任务添加到队列中执行
    dispatch_async(queue, ^{
        
        //3.从网络上下载图片
        NSURL *urlstr = [NSURL URLWithString:url];
        NSData *data = [NSData dataWithContentsOfURL:urlstr];
        
        
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc]
                                               initWithData:[str dataUsingEncoding:
                                                             NSUnicodeStringEncoding]
                                               options:@{
                                                         NSDocumentTypeDocumentAttribute:
                                                             NSHTMLTextDocumentType
                                                         }
                                               documentAttributes:nil error:nil];
        
        
        
        NSDictionary * json = [NSString dictionaryWithJsonString:attrStr];
        if (!data) {
            return ;
        }
        
        NSLog(@"status = %@",json);
        NSLog(@"version=%@",json[@"version"]);
        //UIImage *image=[UIImage imageWithData:data];
        //提示
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            
            NSString *currentVer = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            
            NSString *lastVer = json[@"version"];
            
            lastVer = [lastVer stringByReplacingOccurrencesOfString:@"." withString:@""];
            currentVer = [currentVer stringByReplacingOccurrencesOfString:@"." withString:@""];
            
            if ([lastVer intValue] <= [currentVer intValue]) {

            }else{
                [self appUpdateWith:json[@"url"] with:json[@"description"]];
            }
            
        });
        
        
    });
}

#pragma mark - app更新
- (void) appUpdateWith:(NSString *)url with:(NSString *)info
{
    self.appUrl = url;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:info message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        
        NSURL *url = [NSURL URLWithString:self.appUrl];
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
