//
//  basicVc.h
//  Tourism
//
//  Created by Store on 16/11/8.
//  Copyright © 2016年 qxc122@126.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD+MJ.h"
#import "HeaderBase.h"
#import "Masonry.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
@interface basicVc : UIViewController
@property (nonatomic,strong) NSArray *willToBeRemovedVcs; //在改控制被打开时候，改数组中的控制器类型将被移除
- (void)popSelf;
- (void)OPenVc:(UIViewController *)vc;
@end
