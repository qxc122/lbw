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

@end
