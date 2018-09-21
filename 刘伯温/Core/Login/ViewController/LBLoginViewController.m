//
//  LBLoginViewController.m
//  Core
//
//  Created by mac on 2017/9/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LBLoginViewController.h"
#import "LBForgetPassWorldViewController.h"
#import "LBOtherLoginTool.h"
#import "LBRegisterViewController.h"
#import "HRContactsManager.h"
#import "YContactObject.h"
#import <JMessage/JMessage.h>
#import "SDWebImageDownloader.h"
#import "mainTableVc.h"
@interface LBLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accontTextField;
@property (weak, nonatomic) IBOutlet UIButton *qqButton;
@property (weak, nonatomic) IBOutlet UITextField *passworldTextField;
@property (weak, nonatomic) IBOutlet UIButton *next;
@end

@implementation LBLoginViewController
- (void)popSelf{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window removeAllSubviews];
    window = nil;
    [UIApplication sharedApplication].keyWindow.rootViewController = [[mainTableVc alloc] init];
}

- (IBAction)loginClick:(id)sender {
    if (!self.accontTextField.text.length){
        [MBProgressHUD showMessage:@"手机号不能为空" finishBlock:nil];
        return;
    }
    
    if (!self.passworldTextField.text.length){
        [MBProgressHUD showMessage:@"密码不能为空" finishBlock:nil];
        return;
    }
    
    
    [self phoneLogin];
    
    
}
- (void)phoneLogin{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"account"] = self.accontTextField.text;
    paramDict[@"password"] = [self.passworldTextField.text md5String];
    paramDict[@"clientType"] = @"2";
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    paramDict[@"version"] = app_build;
    paramDict[@"sign"] = [[LBToolModel sharedInstance] getSign:paramDict];

    [MBProgressHUD showLoadingMessage:@"登陆中..." toView:self.view];
WeakSelf
    [VBHttpsTool postWithURL:@"login" params:paramDict success:^(id json) {
        if ([json[@"result"] intValue] ==1){


            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"type"] forKey:@"type"];

            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"userID"] forKey:@"userID"];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"name"] forKey:@"name"];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"gender"] forKey:@"gender"];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"type"] forKey:@"type"];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"avatar"] forKey:@"avatar"];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"expirationDate"] forKey:@"expirationDate"];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"coupons"] forKey:@"coupons"];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"token"] forKey:@"token"];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"testLend"] forKey:@"testLend"];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"invitationCode"] forKey:@"invitationCode"];

            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"chat_forbidden"] forKey:@"chat_forbidden"];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"chat_image_open"] forKey:@"chat_image_open"];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"chat_username"] forKey:@"chat_username"];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"chat_password"] forKey:@"chat_password"];

            [weakSelf getMyInfo];
        }else{
            [MBProgressHUD hideHUDForView:weakSelf.view];
            [MBProgressHUD showPrompt:json[@"info"] toView:weakSelf.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
        [MBProgressHUD showPrompt:@"请重试" toView:weakSelf.view];
    }];
}

- (void)JIMlogin:(NSString *)username withPassword:(NSString *)passWord{
    WeakSelf(self);
    [JMSGUser loginWithUsername:username password:passWord completionHandler:^(id resultObject, NSError *error) {
        if (!error) {
            //登录成功
            NSLog(@"IM 登陆成功");
            [weakSelf updateUserInfo];
        } else {
            //登录失败
            NSLog(@"IM 登陆失败");
        }
    }];
}
- (void)updateUserInfo{
    NSString *avatar = [[NSUserDefaults standardUserDefaults] objectForKey:@"avatar"];
    if (avatar) {
        SDWebImageDownloader *manager = [SDWebImageDownloader sharedDownloader];
        [manager downloadImageWithURL:[NSURL URLWithString:avatar] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            if (image) {
                // do something with image
                JMSGUserInfo *userInfo = [[JMSGUserInfo alloc] init];
                userInfo.nickname = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
                userInfo.avatarData = UIImagePNGRepresentation(image);
                [JMSGUser updateMyInfoWithUserInfo:userInfo completionHandler:^(id resultObject, NSError *error) {
                    if (!error) {
                        //登录成功
                        NSLog(@"IM  信息 更新成功");
                    } else {
                        //登录失败
                        NSLog(@"IM 信息 更新失败");
                    }
                }];
            }
            
        }];
    }
}
- (IBAction)wechatLoginClick:(id)sender {
    WeakSelf
    [LBOtherLoginTool otherLoginType:WxLognin LoginResult:^(NSDictionary *result) {
        [weakSelf loginEx:result];
    }];
}
- (IBAction)qqLoginClick:(id)sender {
    WeakSelf
    [LBOtherLoginTool otherLoginType:QQLogin LoginResult:^(NSDictionary *result) {
        [weakSelf loginEx:result];
    }];
}
- (IBAction)forgetPassWordClick:(id)sender {
    LBForgetPassWorldViewController *VC = [[LBForgetPassWorldViewController alloc] initWithNibName:@"LBForgetPassWorldViewController" bundle:nil];
    VC.title = @"忘记密码";
    [self.navigationController pushViewController:VC animated:YES];
//    [self presentViewController:VC animated:YES completion:nil];
}

- (IBAction)registerClick:(id)sender {
    LBRegisterViewController *VC = [[LBRegisterViewController alloc] initWithNibName:@"LBRegisterViewController" bundle:nil];
        [self.navigationController pushViewController:VC animated:YES];
//    [self presentViewController:VC animated:YES completion:nil];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.passworldTextField.secureTextEntry = YES;
    self.qqButton.hidden = YES;
    self.next.backgroundColor =MainColor;
    
    self.title = @"登陆";
    self.fd_interactivePopDisabled = YES;
    UIImage* image = [[UIImage imageNamed:Navigation_bar_return_button] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem* leftBarutton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(popSelf)];
    self.navigationItem.leftBarButtonItem = leftBarutton;
}


- (void)loginEx:(NSDictionary *)userInfo{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"openid"] = userInfo[@"openId"];
    paramDict[@"access_token"] = userInfo[@"accessToken"];
    paramDict[@"timestamp"] = [[LBToolModel sharedInstance] getTimestamp];
    paramDict[@"name"] = userInfo[@"name"];
    paramDict[@"avatar"] = userInfo[@"avatar"];
    paramDict[@"clientType"] = @"2";
    paramDict[@"sign"] = [[LBToolModel sharedInstance] getSign:paramDict];
    
    WeakSelf
    [MBProgressHUD showLoadingMessage:@"登陆中..." toView:self.view];
    [VBHttpsTool postWithURL:@"loginEx" params:paramDict success:^(id json) {
        if ([json[@"result"] intValue] ==1){
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"type"] forKey:@"type"];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"userID"] forKey:@"userID"];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"name"] forKey:@"name"];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"gender"] forKey:@"gender"];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"type"] forKey:@"type"];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"avatar"] forKey:@"avatar"];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"expirationDate"] forKey:@"expirationDate"];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"coupons"] forKey:@"coupons"];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"token"] forKey:@"token"];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"testLend"] forKey:@"testLend"];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"invitationCode"] forKey:@"invitationCode"];
            
            
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"chat_forbidden"] forKey:@"chat_forbidden"];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"chat_image_open"] forKey:@"chat_image_open"];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"chat_username"] forKey:@"chat_username"];
            [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"chat_password"] forKey:@"chat_password"];
            [weakSelf getMyInfo];
        }else{
            [MBProgressHUD hideHUDForView:weakSelf.view];
            [MBProgressHUD showPrompt:json[@"info"] toView:weakSelf.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
        [MBProgressHUD showPrompt:@"请重试" toView:weakSelf.view];
    }];
}

- (void)uploadFriends{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (![[HRContactsManager shareInstance]hasOpenContactsPower]){
            
            NSMutableArray *mobileNumArr = [NSMutableArray array];
            [[HRContactsManager shareInstance] requestContactsComplete:^(NSArray<YContactObject *> * _Nonnull contacts) {
                
                //开始赋值
                for (YContactObject *object in contacts) {
                    YContactPhoneObject *phontObject = [object.phoneObject firstObject];
                    NSString *mobileNumStr = [phontObject.phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
                    if ([mobileNumStr isMobileNumber]){
                        DDLog(@"phoneNumber========================%@",mobileNumStr);
                        [mobileNumArr addObject:mobileNumStr];
                    }
                    [self uploadFriends:[mobileNumArr jsonStringEncoded]];
                }
            }];
        }
    });
}
- (void)uploadFriends:(NSString *)jsonData{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"timestamp"] = [[LBToolModel sharedInstance] getTimestamp];
    paramDict[@"token"] = TOKEN;
    paramDict[@"jsonData"] = jsonData;
    paramDict[@"sign"] = [[LBToolModel sharedInstance] getSign:paramDict];
    [VBHttpsTool postWithURL:@"uploadFriends" params:paramDict success:^(id json) {
        DDLog(@"");
    } failure:^(NSError *error) {
        
    }];
}

- (void)getMyInfo{
    kWEAKSELF
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"timestamp"] = [[LBToolModel sharedInstance] getTimestamp];
    paramDict[@"token"] = TOKEN;
    paramDict[@"sign"] = [[LBToolModel sharedInstance] getSign:paramDict];
    [VBHttpsTool postWithURL:@"getMyInfo" params:paramDict success:^(id json) {
        if ([json[@"result"] intValue] ==1){
            LBGetMyInfoModel *myinfoModel = [LBGetMyInfoModel mj_objectWithKeyValues:json[@"data"]];
            [NSKeyedArchiver archiveRootObject:myinfoModel toFile:PATH_UESRINFO];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
            [[NSUserDefaults standardUserDefaults]setObject:myinfoModel.address forKey:@"DeliveryAddress"];
            [[NSUserDefaults standardUserDefaults]setObject:myinfoModel.integral forKey:@"integral"];
            [[NSUserDefaults standardUserDefaults] setObject:myinfoModel.expirationDate forKey:@"expirationDate"];
            [[NSUserDefaults standardUserDefaults] setBool:(myinfoModel.address.length ||myinfoModel.phone.length||myinfoModel.surname.length) forKey:@"hasFullInfo"];

            [weakSelf uploadFriends];
            [weakSelf JIMlogin:json[@"data"][@"chat_username"] withPassword:json[@"data"][@"chat_password"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                [window removeAllSubviews];
                window = nil;
                [UIApplication sharedApplication].keyWindow.rootViewController = [[mainTableVc alloc] init];
            });
            
        }else{
            [MBProgressHUD hideHUDForView:weakSelf.view];
            [MBProgressHUD showPrompt:json[@"info"] toView:weakSelf.view];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
        [MBProgressHUD showPrompt:@"请重试" toView:weakSelf.view];
    }];
}
@end
