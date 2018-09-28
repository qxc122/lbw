//
//  LBDepositViewController.h
//  Core
//
//  Created by Jan on 2018/4/6.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "basicVc.h"

@interface LBDepositViewController : basicVc
@property (nonatomic,copy)NSString *amount;

@end

@interface LBGetHappyPlateListModel :NSObject
@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)NSString *plate_name;
@property (nonatomic,copy)NSString *plate_homepage;
@property (nonatomic,copy)NSString *plate_memo;

@property (nonatomic,copy)NSString *plate_account;
@property (nonatomic,copy)NSString *plate_reg_type;

//"plate_name": "平台名称",
//"plate_homepage": "平台官网",
//"plate_memo": "平台备注信息",
//"plate_account": "平台帐号",
//"plate_reg_type": "0:不支持一键注册 1：支持一键注册"

@end
