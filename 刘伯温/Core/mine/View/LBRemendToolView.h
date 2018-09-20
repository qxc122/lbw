//
//  LBRemendToolView.h
//  Core
//
//  Created by mac on 2017/11/12.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^EnterBlock)();
typedef void (^CancelBlock)();

@interface LBRemendToolView : UIView
+(void)showRemendViewText:(NSString *)showContent andTitleText:(NSString *)titleText andEnterText:(NSString *)neterText andCancelText:(NSString *)cancelText andEnterBlock:(EnterBlock)enterBlock andCancelBlock:(CancelBlock)cancelBlock;
@end
