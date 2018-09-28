//
//  MBProgressHUD+assistant.m
//  GroupBuyUserAPP
//  Created by tianXin on 16/9/1.
//

#import "MBProgressHUD+assistant.h"

#define C_ScreenWidth         ([UIScreen mainScreen].bounds.size.width)
#define C_ScreenHeight        ([UIScreen mainScreen].bounds.size.height)

@implementation MBProgressHUD (assistant)

//显示纯文本提示框，延时2秒后提示框消失
+ (void)showMessage:(NSString *)message finishBlock:(void(^)(void))finishBlock{
    if (message==nil) {
        return;
    }
    MBProgressHUD *HUD;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, C_ScreenHeight/2.0, C_ScreenWidth, C_ScreenHeight/2.0)];
    view.backgroundColor = [UIColor clearColor];
    HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    
    [WINDOW addSubview:view];
    HUD.label.text = message;
    HUD.mode = MBProgressHUDModeText;
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [HUD removeFromSuperview];
        if (finishBlock) {
            finishBlock();
        }
        [view removeFromSuperview];
    }];
}


@end
