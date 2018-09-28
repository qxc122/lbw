//
//  AppDelegate.h
//  Core
//
//  Created by mac on 2017/9/19.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CocoaLumberjack/DDLegacyMacros.h>

#import "JChatConstants.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate,JMessageDelegate>
{
    UIAlertView *myAlertView;
}
@property (strong, nonatomic) UIWindow *window;

@property (assign, nonatomic)BOOL isDBMigrating;
- (void)setupMainTabBar;



@end



