//
//  basicVc.m
//  Tourism
//
//  Created by Store on 16/11/8.
//  Copyright © 2016年 qxc122@126.com. All rights reserved.
//

#import "basicVc.h"
#import "LBShowRemendView.h"
#import "LBLoginViewController.h"

@interface basicVc ()

@end

@implementation basicVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customBackButton];
    self.view.backgroundColor = BackGroundColor;

    UIView *back = [UIView new];
    back.backgroundColor = [UIColor clearColor];
    [self.view addSubview:back];
    [back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [self.view sendSubviewToBack:back];
}
- (void)customBackButton
{
    UIImage* image = [[UIImage imageNamed:Navigation_bar_return_button] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem* leftBarutton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(popSelf)];
    self.navigationItem.leftBarButtonItem = leftBarutton;
}
//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        [self hideBottomBarWhenPush];
//    }
//    return self;
//}
//- (void)hideBottomBarWhenPush
//{
//    self.hidesBottomBarWhenPushed = YES;
//}
- (void)popSelf{
//    if (self.presentingViewController) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    } else {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)OPenVc:(basicVc *)vc{
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.willToBeRemovedVcs.count) {
        NSMutableArray *muArry =[self.navigationController.viewControllers mutableCopy];
        for (UIViewController *vc in self.navigationController.viewControllers) {
            for (Class class in self.willToBeRemovedVcs) {
                if ([vc isKindOfClass:class] && ![vc isEqual:self.navigationController.topViewController]) {
                    [muArry removeObject:vc];
                    break;
                }
            }
        }
        self.navigationController.viewControllers = muArry;
        self.willToBeRemovedVcs = nil;
    }
}
- (void)dealloc{
    NSLog(@"%s",__func__);
}

- (void)login{
    [LBShowRemendView showRemendViewText:@"您还没有登录，请先登录" andTitleText:@"提示" andEnterText:@"确定" andEnterBlock:^{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window removeAllSubviews];
        window = nil;
        LBLoginViewController *vc = [[LBLoginViewController alloc] initWithNibName:@"LBLoginViewController" bundle:nil];
        LBNavigationController *nav = [[LBNavigationController alloc]initWithRootViewController:vc];
        [UIApplication sharedApplication].keyWindow.rootViewController = nav;
    }];
}


- (void)joinMembership{
    kWeakSelf(self);
    [LBRemendToolView showRemendViewText:[NSString stringWithFormat:@"您还不是会员，现在去充值吗"] andTitleText:@"赚钱APP" andEnterText:@"确认" andCancelText:@"取消" andEnterBlock:^{
        LBRechargerViewController *VC = [[LBRechargerViewController alloc] initWithNibName:@"LBRechargerViewController" bundle:nil];
        [weakself.navigationController pushViewController:VC animated:YES];
    } andCancelBlock:^{
        
    }];
}
- (void)RenewalFee{
    kWeakSelf(self);
    [LBRemendToolView showRemendViewText:[NSString stringWithFormat:@"您的会员已经到期，现在去充值吗"] andTitleText:@"赚钱APP" andEnterText:@"确认" andCancelText:@"取消" andEnterBlock:^{
        LBRechargerViewController *VC = [[LBRechargerViewController alloc] initWithNibName:@"LBRechargerViewController" bundle:nil];
        [weakself.navigationController pushViewController:VC animated:YES];
    } andCancelBlock:^{
        
    }];
}


#pragma mark --签到
- (void)basicVcsignButtonClick{
    
    if (!ISLOGIN){
        [self login];
        return;
    }
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"timestamp"] = [[LBToolModel sharedInstance] getTimestamp];
    paramDict[@"token"] = TOKEN;
    paramDict[@"jd"] = Longitude;
    paramDict[@"wd"] = Latitude;
    paramDict[@"address"] = Address;
    paramDict[@"sign"] = [[LBToolModel sharedInstance]getSign:paramDict];
    WeakSelf
    [MBProgressHUD showLoadingMessage:@"加载中..." toView:self.view];
    [VBHttpsTool postWithURL:@"sign" params:paramDict success:^(id json) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
        if ([json[@"result"] intValue] == 1){

            [LBShowRemendView showRemendViewText:[NSString stringWithFormat:@"签到成功，您将获得%@金币奖励",[ChatTool shareChatTool].basicConfig.singReward] andTitleText:@"签到" andEnterText:@"我知道了" andEnterBlock:^{
                
            }];
        }else{
            [MBProgressHUD showPrompt:json[@"info"] toView:weakSelf.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
        [MBProgressHUD showPrompt:@"请重试" toView:weakSelf.view];
    }];
}
@end
