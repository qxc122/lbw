//
//  LBExchangeGoldView.h
//  Core
//
//  Created by Jan on 2018/4/7.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^EnterBlock)();
typedef void (^CancelBlock)();
@interface LBExchangeGoldView : UIView
+(void)showRemendViewText:(NSString *)showContent andTitleText:(NSString *)titleText andEnterText:(NSString *)neterText andCancelText:(NSString *)cancelText andEnterBlock:(EnterBlock)enterBlock andCancelBlock:(CancelBlock)cancelBlock;
@end
