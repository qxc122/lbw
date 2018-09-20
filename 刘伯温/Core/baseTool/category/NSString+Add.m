//
//  NSString+Add.m
//  portal
//
//  Created by Store on 2017/8/30.
//  Copyright © 2017年 qxc122@126.com. All rights reserved.
//

#import "NSString+Add.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Add)
#pragma --mark<返回一个富文本可变字符串  字体  颜色 行间距 换行模式>
- (NSMutableAttributedString *)CreatMutableAttributedStringWithFont:(UIFont *)font Color:(UIColor *)color LineSpacing:(CGFloat )lineSpacing Alignment:(NSTextAlignment )alignment BreakMode:(NSLineBreakMode)breakMode  firstLineHeadIndent:(CGFloat )firstLineHeadIndent  headIndent:(CGFloat )headIndent  paragraphSpacing:(CGFloat )paragraphSpacing WordSpace:(CGFloat)WordSpace{
    if (self && self.length) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:lineSpacing];//调整行间距
        [paragraphStyle setAlignment:alignment];
        [paragraphStyle setLineBreakMode:breakMode];
        
        NSDictionary *dic = @{NSFontAttributeName: font,
                              NSForegroundColorAttributeName: color,
                              NSParagraphStyleAttributeName: paragraphStyle,
                              NSKernAttributeName:@(WordSpace)};
        return [[NSMutableAttributedString alloc] initWithString:self attributes:dic];
    }else{
        return nil;
    }
}

//手机号有效性
- (BOOL)isMobileNumber{
    /**
     65      *  手机号以13、15、18、170开头，8个 \d 数字字符
     66      *  小灵通 区号：010,020,021,022,023,024,025,027,028,029 还有未设置的新区号xxx
     67      */
    NSString *mobileNoRegex = @"^1((3\\d|5[0-35-9]|8[025-9])\\d|70[059])\\d{7}$";//除4以外的所有个位整数，不能使用[^4,\\d]匹配，这里是否iOS Bug?
    NSString *phsRegex =@"^0(10|2[0-57-9]|\\d{3})\\d{7,8}$";
    
    BOOL ret = [self myisValidateByRegex:mobileNoRegex];
    BOOL ret1 = [self myisValidateByRegex:phsRegex];
    
    return (ret || ret1);
    
}

- (BOOL)myisValidateByRegex:(NSString *)regex{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pre evaluateWithObject:self];
}


+ (NSDictionary *)dictionaryWithJsonString:(NSMutableString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSString *immutableString = [NSString stringWithFormat:@"%@",jsonString];
    if ([immutableString rangeOfString:@"\n{"].location != NSNotFound) {
        immutableString = [immutableString substringToIndex:[immutableString rangeOfString:@"\n{"].location];
    }
    if ([immutableString containsString:@"”:”"]) {
        immutableString = [immutableString stringByReplacingOccurrencesOfString:@"”:”" withString:@"\":\""];
    }
    if ([immutableString containsString:@"”,"]) {
        immutableString = [immutableString stringByReplacingOccurrencesOfString:@"”," withString:@"\","];
    }
    NSData *jsonData = [immutableString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
@end
