//
//  VBWebViewProgressLine.h
//  MyBrowser
//
//  Created by mac on 2017/9/4.
//  Copyright © 2017年 wodedata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VBWebViewProgressLine : UIView
//进度条颜色
@property (nonatomic,strong) UIColor  *lineColor;

//开始加载
-(void)startLoadingAnimation;

//结束加载
-(void)endLoadingAnimation;
@end
