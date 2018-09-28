//
//  VBHttpsTool.h
//  MyBrowser
//
//  Created by mac on 2017/4/8.
//  Copyright © 2017年 wodedata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VBHttpsTool : NSObject
+(void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *))failure;

@end
