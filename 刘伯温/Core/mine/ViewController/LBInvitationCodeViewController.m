//
//  LBInvitationCodeViewController.m
//  Core
//
//  Created by mac on 2017/11/11.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LBInvitationCodeViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>
#import <MessageUI/MessageUI.h>
#import <Photos/Photos.h>
@interface LBInvitationCodeViewController ()<MFMessageComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) UIImageView *codePng;
@end

@implementation LBInvitationCodeViewController
- (IBAction)sendMessageClick:(id)sender {
    [self showMessageView:nil title:@"邀请好友" body:[NSString stringWithFormat:@"%@:使用邀请码‘%@’可获得%@金币的奖励。快去下载吧",[ChatTool shareChatTool].basicConfig.shareMsg,[[NSUserDefaults standardUserDefaults] objectForKey:@"invitationCode"],[ChatTool shareChatTool].basicConfig.invitationReward]];
}
- (IBAction)shareClick:(id)sender {
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [self  shareWebPageToPlatformType:platformType];
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"邀请奖励";
    UIImageView *codePng = [UIImageView new];
    [self.view addSubview:codePng];
    [codePng mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(40);
        make.right.equalTo(self.view).offset(-40);
        make.top.equalTo(self.descLabel.mas_bottom).offset(20);
        make.height.mas_equalTo(codePng.mas_width);
    }];

    [codePng sd_setImageWithURL:[NSURL URLWithString:[ChatTool shareChatTool].basicConfig.shareVcode]];
    
    self.hidesBottomBarWhenPushed = YES;
    self.topView.backgroundColor = MainColor;


    self.codeLabel.text = [NSString stringWithFormat:@"我的邀请码:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"invitationCode"]];
    self.descLabel.text = [NSString stringWithFormat:@"每邀请一位好友，将获得%@金币的奖励。接受好友邀请的用户同样获得%@的金币",[ChatTool shareChatTool].basicConfig.invitationReward,[ChatTool shareChatTool].basicConfig.invitationReward];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存二维码" style:UIBarButtonItemStylePlain target:self action:@selector(saveCodeClick)];
}
- (void)saveCodeClick{
    kWeakSelf(self);
    [MBProgressHUD showLoadingMessage:NSLocalizedString(@"保存中...", @"") toView:self.view];
    SDWebImageDownloader *manager = [SDWebImageDownloader sharedDownloader];

    [manager downloadImageWithURL:[NSURL URLWithString:[ChatTool shareChatTool].basicConfig.shareVcode] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        if (image) {
            [weakself saveCodePng:image];
        }else{
            [MBProgressHUD hideHUDForView:weakself.view animated:YES];
            [MBProgressHUD showPrompt:@"请重试~" toView:weakself.view];
        }
    }];
}

- (void)saveCodePng:(UIImage *)png{
    PHAuthorizationStatus authoriation = [PHPhotoLibrary authorizationStatus];
    if (authoriation == PHAuthorizationStatusNotDetermined) {
        kWeakSelf(self);
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            //这里非主线程，选择完成后会出发相册变化代理方法
            if (status == PHAuthorizationStatusAuthorized) {
                //OK
                [weakself loadImageFinished:png];
            } else {
                [MBProgressHUD hideHUDForView:weakself.view animated:YES];
                [MBProgressHUD showPrompt:@"您没有设置权限" toView:weakself.view];
            }
        }];
    }else if (authoriation == PHAuthorizationStatusAuthorized) {
        //OK
        [self loadImageFinished:png];
    }else {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showPrompt:@"您没有设置权限" toView:self.view];
    }
}


- (void)loadImageFinished:(UIImage *)image
{
    kWeakSelf(self);
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        //写入图片到相册
        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        NSLog(@"success = %d, error = %@ %@", success, error,[NSThread currentThread]);
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
            [MBProgressHUD hideHUDForView:weakself.view animated:YES];
            if (error) {
                [MBProgressHUD showPrompt:@"保存失败" toView:weakself.view];
            } else {
                [MBProgressHUD showPrompt:@"保存成功" toView:weakself.view];
            }
        });
    }];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:[NSString stringWithFormat:@"刘伯温邀请码：%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"invitationCode"]] descr:[NSString stringWithFormat:@"使用邀请码'%@'可获得%@金币的奖励。快去下载吧",[[NSUserDefaults standardUserDefaults] objectForKey:@"invitationCode"],[ChatTool shareChatTool].basicConfig.invitationReward] thumImage:[UIImage imageNamed:@"logo"]];
    //设置网页地址
    shareObject.webpageUrl = [ChatTool shareChatTool].basicConfig.shareVcode;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        //        [self alertWithError:error];
    }];
}

#pragma mark - 代理方法
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功
            
            break;
        case MessageComposeResultFailed:
            //信息传送失败
            
            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
            
            break;
        default:
            break;
    }
}

#pragma mark - 发送短信方法
-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.navigationBar.tintColor = [UIColor redColor];
        controller.body = body;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end
