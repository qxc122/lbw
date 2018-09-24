//
//  VBHttpsTool.m
//  MyBrowser
//
//  Created by mac on 2017/4/8.
//  Copyright © 2017年 wodedata. All rights reserved.
//

#import "VBHttpsTool.h"
#import "AFNetworking.h"
#import "LBShowRemendView.h"
#import "UIApplication+YYAdd.h"
#import "LBLoginViewController.h"
@implementation VBHttpsTool
+(void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *))failure{
    
    url = [NSString stringWithFormat:@"%@%@",HeadURL,url];
    
//    DDLog(@"=================%@=========%@",params,url);
    
    NSMutableDictionary *newParams = [NSMutableDictionary dictionaryWithDictionary:params];
    // 1.创建请求管理对象
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer= [AFHTTPRequestSerializer serializer];
//    mgr.responseSerializer= [AFHTTPResponseSerializer serializer];
    
    // 设置超时时间
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.timeoutInterval = 15.f;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    mgr.requestSerializer.cachePolicy =  NSURLRequestReloadIgnoringCacheData;
    [mgr POST:url parameters:newParams progress:^(NSProgress * _Nonnull uploadProgress)
     {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

         if (success) {
             
//             YBLog(@"resutl = %@",responseObject);
             if ([responseObject[@"result"] intValue] == 7){
                 if (ISLOGIN) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                        UIWindow *window = [UIApplication sharedApplication].keyWindow;
                         UIViewController *tm2;
                         UIViewController *tmp = window.rootViewController;
                         if ([tmp isKindOfClass:[UITabBarController class]]) {
                             UITabBarController *tab = tmp;
                             tm2 = tab.selectedViewController;
                         } else if ([tmp isKindOfClass:[UINavigationController class]]) {
                             UINavigationController *tab = tmp;
                             tm2 = tab.topViewController;
                         }else if ([tmp isKindOfClass:[UIViewController class]]) {
                             tm2 = tmp;
                         }
                         if(!tm2.presentedViewController){
                             [LBShowRemendView showRemendViewText:[NSString stringWithFormat:@"验证失效，请重新登录"] andTitleText:@"重新登录" andEnterText:@"我知道了" andEnterBlock:^{
                                 UIWindow *window = [UIApplication sharedApplication].keyWindow;
                                 [window removeAllSubviews];
                                 window = nil;
                                 
                                 LBLoginViewController *vc = [[LBLoginViewController alloc] initWithNibName:@"LBLoginViewController" bundle:nil];
                                 LBNavigationController *nav = [[LBNavigationController alloc]initWithRootViewController:vc];
                                 [UIApplication sharedApplication].keyWindow.rootViewController = nav;
                             }];
                         }
                     });
                     failure([[NSError alloc]initWithDomain:@"验证失效，请重新登录" code:7 userInfo:nil]);
                 }
             }else{
                 success(responseObject);
             }
             
         }
         
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
         if (failure) {
             failure(error);
//             YBLog(@"---error = %@",error);
             
         }
         
     }];
    
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    [mgr setSecurityPolicy:securityPolicy];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
}

+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *))failure{
    
}
@end
