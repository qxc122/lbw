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
    NSString *pattern =@"^1+[345789]+\\d{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
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


- (CGSize)sizeWithFont:(UIFont*)font   andMaxSize:(CGSize)size {
    //特殊的格式要求都写在属性字典中
    NSDictionary*attrs =@{NSFontAttributeName: font};
    //返回一个矩形，大小等于文本绘制完占据的宽和高。
    return  [self  boundingRectWithSize:size  options:NSStringDrawingUsesLineFragmentOrigin  attributes:attrs   context:nil].size;
}
@end
