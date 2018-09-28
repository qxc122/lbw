//
//  passWordView.m
//  Core
//
//  Created by heiguohua on 2018/9/27.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "passWordView.h"
//#define KWHC_BackStartColor          ((id)[UIColor colorWithRed:56.0 / 255.0 green:34.0 / 255.0 blue:80.0 / 255.0 alpha:1.0].CGColor)
//#define KWHC_BackEndColor            ((id)[UIColor colorWithRed:56.0 / 255.0 green:34.0 / 255.0 blue:36.0 / 255.0 alpha:1.0].CGColor)


#define KWHC_CircleMarginTwo  (20.0)

@implementation passWordView

//- (instancetype)initWithFrame:(CGRect)frame{
//    self = [super initWithFrame:frame];
//    if(self){
//        CAGradientLayer *defaultBackgroudLayer = [CAGradientLayer layer];
//        defaultBackgroudLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
//        defaultBackgroudLayer.colors = @[KWHC_BackStartColor,KWHC_BackEndColor];
//        defaultBackgroudLayer.locations = @[@(0.0),@(1.0)];
//        [self.layer insertSublayer:defaultBackgroudLayer atIndex:0];
//    }
//    return self;
//}



- (void)updateUILayoutWithType:(WHCGestureUnlockType)type{
    NSArray  * subArr = self.subviews;
    if(subArr){
        for (UIView * subView in subArr) {
            [subView removeFromSuperview];
        }
    }
    [_rectArr removeAllObjects];
    [_circleViewArr removeAllObjects];
    self.backgroundColor = [UIColor clearColor];
    CGFloat   circleWidth1 = (self.width - (KWHC_PlateColumn + 1) * KWHC_CircleMarginTwo) / (CGFloat)KWHC_PlateColumn;
    
    CGFloat   circleWidth2 = (self.height - (KWHC_PlateRow) * KWHC_CircleMarginTwo) / (CGFloat)(KWHC_PlateRow + 1);
    CGFloat   circleWidth = 0;
    if (circleWidth1 <= circleWidth2) {
        circleWidth = circleWidth1;
    } else {
        circleWidth = circleWidth2;
    }
    
    CGFloat   circleSumWidth = KWHC_PlateColumn * circleWidth + (KWHC_PlateColumn - 1) * KWHC_CircleMarginTwo;
    CGFloat   oneCircleX = (self.width - circleSumWidth) / 2.0;
    for (NSInteger i = 0; i < KWHC_PlateRow; i++) {
        for (NSInteger j = 0; j < KWHC_PlateColumn; j++) {
            NSInteger  number = i * KWHC_PlateRow + j + 1;
            CGFloat  x = oneCircleX + circleWidth / 2.0 * (j + 1) + j * (KWHC_CircleMarginTwo + circleWidth / 2.0);
            WHC_CircleView  * circleView = [WHC_CircleView new];
            circleView.delegate = self;
            circleView.size = CGSizeMake(circleWidth, circleWidth);
            circleView.center = CGPointMake(x, (i + 1) * circleWidth / 2.0 + i * (KWHC_CircleMarginTwo + circleWidth / 2.0));
            circleView.circleType = type;
            [circleView setNumber:number];
            [self addSubview:circleView];
            [_circleViewArr addObject:circleView];
            if(type == GestureDragType){
                WHC_Rect   * rectObject = [WHC_Rect new];
                CGRect     rect  = {circleView.x, circleView.y , circleWidth, circleWidth};
                rectObject.rect = rect;
                rectObject.number = number;
                [_rectArr addObject:rectObject];
            }
        }
    }
    if(type == ClickNumberType){
        WHC_CircleView  * circleView = [WHC_CircleView new];
        circleView.delegate = self;
        circleView.size = CGSizeMake(circleWidth, circleWidth);
        circleView.center = CGPointMake(self.centerX, (KWHC_PlateRow + 1) * circleWidth / 2.0 + KWHC_PlateRow * (KWHC_CircleMarginTwo + circleWidth / 2.0));
        circleView.circleType = ClickNumberType;
        [circleView setNumber:0];
        [self addSubview:circleView];
    }
}
@end
