//
//  DataModel.m
//  base
//
//  Created by 开发者最好的 on 2018/8/22.
//  Copyright © 2018年 开发者最好的. All rights reserved.
//

#import "DataModel.h"

/**
 *  将属性名换为其他key去字典中取值
 *
 *  @return 字典中的key是属性名，value是从字典中取值用的key
 */
//+ (NSDictionary *)mj_replacedKeyFromPropertyName;

/**
 *  将属性名换为其他key去字典中取值
 *
 *  @return 从字典中取值用的key
 */
//+ (id)mj_replacedKeyFromPropertyName121:(NSString *)propertyName;


/**
 *  旧值换新值，用于过滤字典中的值
 *
 *  @param oldValue 旧值
 *
 *  @return 新值
 */
//- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property;
//    if ([property.name isEqualToString:@"publisher"]) {
//        if (oldValue == nil) return @"";
//    } else if (property.type.typeClass == [NSDate class]) {
//        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
//        fmt.dateFormat = @"yyyy-MM-dd";
//        return [fmt dateFromString:oldValue];
//    }

//+ (NSDictionary *)mj_replacedKeyFromPropertyName{
//    /* 返回的字典，key为模型属性名，value为转化的字典的多级key */
//    return @{
//             @"contentA" : @"content",
//             @"pageableD" : @"pageable",
//             };
//}
//+ (NSDictionary *)mj_objectClassInArray
//{
//    return @{
//             @"contentA" : @"contentS",
//             };
//}

//MJExtensionCodingImplementation

@implementation DataModel

@end

@implementation msgList
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    /* 返回的字典，key为模型属性名，value为转化的字典的多级key */
    return @{
             @"arry" : @"data",
             };
}
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"arry" : @"msgOne",
             };
}
@end

@implementation msgOne

@end


@implementation bankList
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    /* 返回的字典，key为模型属性名，value为转化的字典的多级key */
    return @{
             @"arry" : @"data",
             };
}
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"arry" : @"bankOne",
             };
}
@end
@implementation bankOne

@end

@implementation WithdrawalList
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    /* 返回的字典，key为模型属性名，value为转化的字典的多级key */
    return @{
             @"arry" : @"data",
             };
}
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"arry" : @"WithdrawalOne",
             };
}
@end


@implementation LBAnchorListModelList
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    /* 返回的字典，key为模型属性名，value为转化的字典的多级key */
    return @{
             @"arry" : @"data",
             };
}
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"arry" : @"LBAnchorListModel",
             };
}
@end



@implementation WithdrawalOne

@end


@implementation chatRecodList
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    /* 返回的字典，key为模型属性名，value为转化的字典的多级key */
    return @{
             @"arry" : @"data",
             };
}
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"arry" : @"chatRecodOne",
             };
}
@end

@implementation chatRecodOne

@end

@implementation LBGetVerCodeModel
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    if ([property.name isEqualToString:@"payfor_url"] || [property.name isEqualToString:@"CFLT"] || [property.name isEqualToString:@"WBW"]) {
        if (oldValue != nil && [oldValue isKindOfClass:[NSString class]] ){
            NSString *tmp = oldValue;
            return [tmp stringByReplacingOccurrencesOfString:@"http://jxjiancai.net" withString:@"http://43.230.143.218"];
        }else{
            return @"";
        }
    }else{
        return oldValue;
    }
}
MJExtensionCodingImplementation
@end

@implementation LBGetLivePlatModel
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return@{@"ID" :@"id"};
}
@end


@implementation LBAnchorListModel
MJExtensionCodingImplementation
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return@{@"ID" :@"id"};
}
@end



@implementation LBGetAdvListModelAll
MJExtensionCodingImplementation
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    /* 返回的字典，key为模型属性名，value为转化的字典的多级key */
    return @{
             @"arry" : @"data",
             };
}
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"arry" : @"LBGetAdvListModel",
             };
}
@end

@implementation LBGetAdvListModel
MJExtensionCodingImplementation
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return@{@"ID" :@"id"};
}
@end


@implementation LBExchangeModel
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return@{@"ID" :@"id"};
}
@end


@implementation LBGetGoodsListModel
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return@{@"ID" :@"id"};
}
@end

@implementation LBGetMyInfoModel
MJExtensionCodingImplementation
@end

@implementation LBGetActivationCardListModel
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return@{@"ID" :@"id"};
}
@end

