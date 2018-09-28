//
//  NSString+Add.h
//  portal
//
//  Created by Store on 2017/8/30.
//  Copyright © 2017年 qxc122@126.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Add)
#pragma --mark<返回一个富文本可变字符串  字体  颜色 行间距 换行模式>
- (NSMutableAttributedString *)CreatMutableAttributedStringWithFont:(UIFont *)font Color:(UIColor *)color LineSpacing:(CGFloat )lineSpacing Alignment:(NSTextAlignment )alignment BreakMode:(NSLineBreakMode)breakMode  firstLineHeadIndent:(CGFloat )firstLineHeadIndent  headIndent:(CGFloat )headIndent  paragraphSpacing:(CGFloat )paragraphSpacing WordSpace:(CGFloat)WordSpace;

- (BOOL)isMobileNumber;

+ (NSDictionary *)dictionaryWithJsonString:(NSMutableString *)jsonString;
@end
