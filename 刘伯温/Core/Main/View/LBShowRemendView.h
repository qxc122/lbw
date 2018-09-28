//
//  LBShowRemendView.h
//  Core
//
//  Created by mac on 2017/10/8.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^EnterBlock)();

@interface LBShowRemendView : UIView
+(void)showRemendViewText:(NSString *)showContent andTitleText:(NSString *)titleText andEnterText:(NSString *)neterText andEnterBlock:(EnterBlock)enterBlock;
@end
