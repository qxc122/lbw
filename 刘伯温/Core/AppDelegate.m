//
//  AppDelegate.m
//  Core
//
//  Created by mac on 2017/9/19.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "AppDelegate.h"
#import "mainTableVc.h"
#import "LBLoginViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import "UMMobClick/MobClick.h"
#import <CoreLocation/CoreLocation.h>
#import <UserNotifications/UserNotifications.h>
#import "UMessage.h"
#import "WHC_GestureUnlockScreenVC.h"
#import <JMessage/JMessage.h>
#import "IQKeyboardManager.h"
#import "mainTableVc.h"
#import "AdvertisingVc.h"
@interface AppDelegate ()<CLLocationManagerDelegate,UNUserNotificationCenterDelegate>
@property (nonatomic, strong) CLLocationManager * locationManager;
@end

@implementation AppDelegate
- (void)setupMainTabBar{
    
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
//    MMKV *mmkv = [MMKV defaultMMKV];
//    [mmkv setBool:YES forKey:@"isaidong"];
    
    mainTableVc *vc = [mainTableVc new];
    vc.isaidong = @"1";
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:vc];
    [self.window makeKeyAndVisible];

    BOOL tmp;;
#ifdef DEBUG
    tmp = NO;
//    [JMessage setDebugMode];
    [JMessage setLogOFF];
#else
    tmp = YES;
    [JMessage setLogOFF];
#endif
    [JMessage setupJMessage:launchOptions appKey:JIM_APPKEY channel:nil apsForProduction:tmp category:nil messageRoaming:YES];
    [JMessage registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert) categories:nil];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    UMConfigInstance.appKey = USHARE_APPKEY;
    UMConfigInstance.channelId = @"";
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取

#ifdef DEBUG
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:NO];
#else
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:NO];
#endif
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:USHARE_APPKEY];
    
    
    [UMessage startWithAppkey:USHARE_APPKEY launchOptions:launchOptions httpsenable:YES];
    //注册通知，如果要使用category的自定义策略，可以参考demo中的代码。
    [UMessage registerForRemoteNotifications];
    [UMessage setLogEnabled:NO];
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
    [self configUSharePlatforms];
    [self startLocation];
    return YES;
}
- (void)configUSharePlatforms
{
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1107782599" appSecret:@"OXkVbGrd8Jsyu54b" redirectURL:@"http://www.umeng.com/social"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Qzone appKey:@"1107782599" appSecret:@"OXkVbGrd8Jsyu54b" redirectURL:@"http://www.umeng.com/social"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx813be7b408c68019" appSecret:@"b0927db2cae4f8c7ae3afa3dd5c7fae6" redirectURL:@"http://www.umeng.com/social"];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    MMKV *mmkv = [MMKV defaultMMKV];
    if ([mmkv getBoolForKey:@"bool"]){
        [WHC_GestureUnlockScreenVC setUnlockScreenWithType:ClickNumberType];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidEnterBackground" object:nil];
    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.

}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ConfigurationKey"]){
//        [WHC_GestureUnlockScreenVC setUnlockScreenWithType:ClickNumberType];
//    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // 1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
    [UMessage registerDeviceToken:deviceToken];
    [JMessage registerDeviceToken:deviceToken];
}

//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //关闭U-Push自带的弹出框
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
}


-(void)startLocation
{
    if([CLLocationManager locationServicesEnabled])
    {
        // 启动位置更新
        // 开启位置更新需要与服务器进行轮询所以会比较耗电，在不需要时用stopUpdatingLocation方法关闭;
        _locationManager = [[CLLocationManager alloc] init];
        //设置定位的精度
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        _locationManager.distanceFilter = 10.0f;
        _locationManager.delegate = self;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] > 8.0)
        {
            [_locationManager requestAlwaysAuthorization];
            [_locationManager requestWhenInUseAuthorization];
        }
        
        //开始实时定位
        [_locationManager startUpdatingLocation];
    }else {
        DDLog(@"请开启定位功能！");
    }
}

// 地理位置发生改变时触发
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    DDLog(@"Longitude = %f", newLocation.coordinate.longitude);
    DDLog(@"Latitude = %f", newLocation.coordinate.latitude);
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",newLocation.coordinate.longitude] forKey:@"longitude"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",newLocation.coordinate.latitude] forKey:@"latitude"];
    
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             
             //将获得的所有信息显示到label上
             DDLog(@"位置：%@",placemark.name);
             DDLog(@"国家：%@",placemark.country);
             DDLog(@"城市：%@",placemark.locality);
             DDLog(@"区：%@",placemark.subLocality);
             DDLog(@"街道：%@",placemark.thoroughfare);
             DDLog(@"子街道：%@",placemark.subThoroughfare);
             //获取城市
             NSString *city = placemark.locality;
             if (!city) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 city = placemark.administrativeArea;
             }
             
             NSString *address = [NSString stringWithFormat:@"%@,%@,%@",placemark.administrativeArea,city,placemark.subLocality];
             [[NSUserDefaults standardUserDefaults] setObject:address forKey:@"address"];
//             DDLog(@"address =======%@%@%@%@%@",placemark.administrativeArea,city,placemark.subLocality,placemark.thoroughfare,placemark.subThoroughfare);

             
         }
//         else if (error == nil && [array count] == 0)
//         {
//             DDLog(@"No results were returned.");
//         }
//         else if (error != nil)
//         {
//             DDLog(@"An error occurred = %@", error);
//         }
         
         [_locationManager stopUpdatingLocation];
     }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
}




@end
