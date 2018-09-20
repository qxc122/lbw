//
//  single.h
//  base
//
//  Created by 开发者最好的 on 2018/8/21.
//  Copyright © 2018年 开发者最好的. All rights reserved.
//

#ifndef single_h
#define single_h


#define singleH(name) + (instancetype)share##name;

#define singleM(name) \
static id _instance; \
\
+ (instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
NSLog(@"创建了单栗：%@", NSStringFromClass([name class]));\
}); \
return _instance; \
} \
\
+ (instancetype)share##name \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return _instance; \
}\
\
- (id)mutableCopyWithZone:(NSZone *)zone { \
return _instance; \
}

#endif /* single_h */
