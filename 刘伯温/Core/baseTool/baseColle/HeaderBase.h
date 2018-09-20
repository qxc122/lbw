//
//  HeaderBase.h
//  base
//
//  Created by 开发者最好的 on 2018/8/14.
//  Copyright © 2018年 开发者最好的. All rights reserved.
//

#ifndef HeaderBase_h
#define HeaderBase_h

#import "UIColor+Add.h"
#import "PNG_MACRO.h"

#define FPS_TEST   //定义了则打开FPS监控，注释就没有FPS监控

// app版本
#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
// app build版本
#define APP_BUILD [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
// 手机系统的版本
#define PHONEVERSION [[UIDevice currentDevice] systemVersion]


#define PingFangSC_Regular(F) [UIFont systemFontOfSize:F]
#define PingFangSC_Medium(F) [UIFont boldSystemFontOfSize:F]

#define RGBColor(R,G,B)  [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:1.0f]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define randomColor random(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))


#define ColorWithHex(rgbValue,a) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:(a)]

#define kWeakSelf(type)  __weak typeof(type) weak##type = type;

#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define PROPORTION_HEIGHT  SCREENHEIGHT/667.0
#define PROPORTION_WIDTH   SCREENWIDTH/375.0

#define IPoneX (SCREENHEIGHT == 812)
#define isPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif

#define PIC_Nonetwork @"Nonetwork"
#define PIC_Loadfailure @"Loadfailure"
#define PIC_nodata   @"nodata"

#define STR_Nonetwork @"\n请打开Wifi或移动数据"
#define STR_Loadfailure @"\n加载失败，请重试"
#define STR_nodata   @"没有数据"


#endif /* Header_h */
