//
//  LBMineHeadView.h
//  Core
//
//  Created by mac on 2017/9/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBMineHeadView : UIView
@property (nonatomic, strong)void(^clickEnditBlock)();
@property(nonatomic, strong)LBGetMyInfoModel *infoModel;
@property (nonatomic, strong)void(^clickSettingBlock)();
@property (nonatomic, strong)void(^clickGoldBlock)();

@property (nonatomic, strong)void(^moneyButtonBlock)();

@end
