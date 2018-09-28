//
//  LBOtherLoginTool.h
//  Core
//
//  Created by mac on 2017/9/25.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,LoginType){
    WxLognin,
    QQLogin
};
@interface LBOtherLoginTool : NSObject
+(void)otherLoginType:(LoginType)loginType LoginResult:(void(^)(NSDictionary *result))loginResult;
@property (nonatomic, assign)LoginType loginType;
@end
