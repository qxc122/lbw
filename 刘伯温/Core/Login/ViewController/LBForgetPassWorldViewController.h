//
//  LBForgetPassWorldViewController.h
//  Core
//
//  Created by mac on 2017/9/20.
//  Copyright © 2017年 mac. All rights reserved.
//


#import "basicVc.h"


@interface LBForgetPassWorldViewController : basicVc
//@property(nonatomic, assign)BOOL isChangePassword;// 修改密码
@property(nonatomic, assign)BOOL isEnterVC;// 提交界面
@property(nonatomic, copy)NSString *phoneNun;
@property(nonatomic, copy)NSString *codeStr;

@end
