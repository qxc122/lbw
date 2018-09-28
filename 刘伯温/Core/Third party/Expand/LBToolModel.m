//
//  LBToolModel.m
//  Core
//
//  Created by mac on 2017/9/22.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LBToolModel.h"
static LBToolModel *tool;

@implementation LBToolModel

+(LBToolModel *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[LBToolModel alloc] init];
    });
    return tool;
}


//-(NSString *)getSign{
//    return [[NSString stringWithFormat:@"%@%@%@",APIKEY,[self getTimestamp],JAMS] md5String];
//}

-(NSString *)getSign:(NSMutableDictionary *)paramDict{
    
    if (!paramDict.count){
        return [JAMS md5String];
    }
    
    NSMutableArray *keyArray = [NSMutableArray arrayWithArray:[paramDict allKeys]];
    
    
    NSMutableArray *valueArray = [NSMutableArray array];

    NSArray *newArray = [keyArray sortedArrayUsingSelector:@selector(compare:)];
    for (NSString *keyStr in newArray) {
        [valueArray addObject:paramDict[keyStr]];
    }
    NSString *sign = @"";
    
    for (NSString *valueStr in valueArray) {
        sign = [NSString stringWithFormat:@"%@%@",sign,valueStr];
    }
    
    sign = [NSString stringWithFormat:@"%@%@",sign,JAMS];
    return [sign md5String];
    
}


-(NSString *)getTimestamp{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
//
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//
//    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss.SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
//
//    //设置时区,这个对于时间的处理有时很重要
//
//    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
//
//    [formatter setTimeZone:timeZone];
//
//    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
//
//    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%ld", (long)a];
    return timeString;
}
@end
