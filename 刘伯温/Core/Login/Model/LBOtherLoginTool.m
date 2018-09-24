//
//  LBOtherLoginTool.m
//  Core
//
//  Created by mac on 2017/9/25.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LBOtherLoginTool.h"
#import <UMSocialCore/UMSocialCore.h>

@implementation LBOtherLoginTool
+(void)otherLoginType:(LoginType)loginType LoginResult:(void(^)(NSDictionary *result))loginResult{
    UMSocialPlatformType platType;
    if (loginType == WxLognin)
    {
        platType = UMSocialPlatformType_WechatSession;
    }else if (loginType == QQLogin)
    {
        platType = UMSocialPlatformType_QQ;
    }
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platType currentViewController:nil completion:^(id result, NSError *error) {
        if (error)
        {
            [MBProgressHUD showPrompt:@"登录失败"];
        }else{
            UMSocialUserInfoResponse *resp = result;
            NSString *WeiXinId = @"";
            NSString *QQId = @"";
            NSString *WeiBoId = @"";
            NSString *logType = @"";
            if (loginType == WxLognin)
            {
                WeiXinId = resp.openid;
                logType = @"1";
            }else if (loginType == QQLogin)
            {
                QQId = resp.openid;
                logType = @"2";
            }
            
            NSDictionary *dataDict = @{                                 @"usid":resp.uid,@"WeiXinId":WeiXinId,@"WeiBoId":WeiBoId,@"QQId":QQId,@"loginType":logType,@"openId":resp.openid,@"name":resp.name,@"avatar":resp.iconurl,@"accessToken":resp.accessToken};
            loginResult(dataDict);
            
        }
        
        
    }];
}
@end
