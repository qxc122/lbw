//
//  VBWebViewProgressLine.m
//  MyBrowser
//
//  Created by mac on 2017/9/4.
//  Copyright © 2017年 wodedata. All rights reserved.
//

#import "VBWebViewProgressLine.h"

@implementation VBWebViewProgressLine

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)setLineColor:(UIColor *)lineColor{
    _lineColor = lineColor;
    self.backgroundColor = lineColor;
}

-(void)startLoadingAnimation{
    self.hidden = NO;
    CGRect frame;
    frame.size.width = 0.0;
    frame.size.height = self.frame.size.height;
    frame.origin = self.frame.origin;
    self.frame = frame;
    
    __weak UIView *weakSelf = self;
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame;
        frame.size.width = [[UIScreen mainScreen] bounds].size.width * 0.6;
        frame.size.height = weakSelf.frame.size.height;
        frame.origin = weakSelf.frame.origin;
        weakSelf.frame = frame;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            CGRect frame;
            frame.size.width = [[UIScreen mainScreen] bounds].size.width * 0.8;
            frame.size.height = weakSelf.frame.size.height;
            frame.origin = weakSelf.frame.origin;
            weakSelf.frame = frame;
        }];
    }];
    
    
}

-(void)endLoadingAnimation{
    __weak UIView *weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame;
        frame.size.width = [[UIScreen mainScreen] bounds].size.width;
        frame.size.height = weakSelf.frame.size.height;
        frame.origin = weakSelf.frame.origin;
        weakSelf.frame = frame;
    } completion:^(BOOL finished) {
        weakSelf.hidden = YES;
    }];
}

@end
