//
//  LBNavigationController.m
//  Core
//
//  Created by mac on 2017/9/19.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LBNavigationController.h"

@interface LBNavigationController ()

@end

@implementation LBNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.translucent = NO;
    [[UINavigationBar appearance] setBarTintColor:MainColor];

    //设置导航条文字颜色 白色
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    //设置按钮文字颜色 白色
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    //设置导航栏按钮字体大小
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15], UITextAttributeFont,nil] forState:UIControlStateNormal];

    [[UINavigationBar appearance] setBackgroundImage:[MainColor imageWithColor] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[MainColor imageWithColor]];
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
//    if (animated) {
        if (self.viewControllers.count > 0) {
            viewController.hidesBottomBarWhenPushed = YES;
        }
//    } else {
//
//    }
    [super pushViewController:viewController animated:animated];
}

@end
