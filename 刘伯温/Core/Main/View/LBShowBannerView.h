//
//  LBShowBannerView.h
//  Core
//
//  Created by Jan on 2018/4/7.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBShowBannerView : UIView
//@property (nonatomic, copy) void (^doneSomething)();

@property (nonatomic,strong) NSString *isNeedDaoJiShi;

@property (nonatomic,assign) NSInteger num;

- (void)show;
@end
