//
//  MBProgressHUD+assistant.h
//  GroupBuyUserAPP
//
//  Created by tianXin on 16/9/1.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (assistant)

//显示纯文本提示框，延时2秒后提示框消失
+ (void)showMessage:(NSString *)message finishBlock:(void(^)(void))finishBlock;

@end