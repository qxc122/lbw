//
//  Header.h
//  Hear
//
//  Created by mac on 2017/3/21.
//  Copyright © 2017年 mac. All rights reserved.
//

#ifndef Header_h
#define Header_h
#define DDLog(xx, ...)  NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#define IS_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)




#define WINDOW [UIApplication sharedApplication].keyWindow

#define CustomUIFont(F) [UIFont systemFontOfSize:F]

#define CustomColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]


#define IMkTabBarHeight 0.0

#define kNavBarHeight 44.0
#define kTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
#define kTopHeight (kStatusBarHeight + kNavBarHeight)
#define kStatusBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?44:20)

#define kNaHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?88:66)

//#define VIEWCCONTROLER [[[((HRTabBarViewController *)[[UIApplication sharedApplication].keyWindow rootViewController]) selectedViewController] childViewControllers] lastObject]

//#define kWeakSelf(type)  __weak typeof(type) weak##type = type;
// 弱引用
#define WeakSelf __weak typeof(self) weakSelf = self;

#define kFullScreen [UIScreen mainScreen].bounds
#define kFullWidth [UIScreen mainScreen].bounds.size.width
#define kFullHeight [UIScreen mainScreen].bounds.size.height
#define adjuctFloat(x) (x)*kFullWidth/375


#define MainColor CustomColor(80, 166, 242, 1)
#define SecondColor CustomColor(18, 150, 219, 1)


#define BackGroundColor CustomColor(240, 240, 240, 1)


// OSS
#define AccessKey @"LTAIYuKB1nkLNTiI"
#define SecretKey @"mhdTFZ36xqw9K7CYJEgiGxwD5JR8Tq"
#define BucketName @"walkforlove"
#define AliYunHost @"oss-cn-qingdao.aliyuncs.com/"
#define kTempFolder @"image_ios"

#define heightUserName    15.0f  //聊天名字高度

#define APIKEY @"EADIFLKJFADIE82RFA"

#define JAMS @"JAMESM3DADF"

#define HeadURL @"http://jxjiancai.net:9999/api.v11.php?a="// 正式

//#define HeadURL @"http://121.42.42.112:903/api.v10.php?a="//测试

#define ImageHead @"http://jxjiancai.net:804"

#define ISLOGIN [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"]

#define USERID [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]
#define NICKNAME [[NSUserDefaults standardUserDefaults] objectForKey:@"name"]
#define GENDER [[NSUserDefaults standardUserDefaults] objectForKey:@"gender"] //0  # 性别（0：女 1：男 2：未知）,
#define TYPE [[NSUserDefaults standardUserDefaults] objectForKey:@"type"]//# 0:普通用户 1：VIP会员 2：管理员
#define ICON [[NSUserDefaults standardUserDefaults] objectForKey:@"avatar"]
#define EXPIRATIONDATE [[NSUserDefaults standardUserDefaults] objectForKey:@"expirationDate"]
#define COUPONS [[NSUserDefaults standardUserDefaults] objectForKey:@"coupons"]
#define TOKEN [[NSUserDefaults standardUserDefaults] objectForKey:@"token"]
#define TESTLEND [[NSUserDefaults standardUserDefaults] objectForKey:@"testLend"]
#define INVITATIONCODE [[NSUserDefaults standardUserDefaults] objectForKey:@"invitationCode"]

// 定位
#define Address [[NSUserDefaults standardUserDefaults] objectForKey:@"address"]
#define Longitude [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"]
#define Latitude [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"]

//收货地址
#define DeliveryAddress [[NSUserDefaults standardUserDefaults] objectForKey:@"DeliveryAddress"]

// 金币
#define Integral [[NSUserDefaults standardUserDefaults] objectForKey:@"integral"]

#endif /* Header_h */




#if !defined(CG_INLINE)
# if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 199901L
#  define CG_INLINE static inline
# elif defined(__cplusplus)
#  define CG_INLINE static inline
# elif defined(__GNUC__)
#  define CG_INLINE static __inline__
# else
#  define CG_INLINE static
# endif
#endif

