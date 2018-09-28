//
//  YBAlertView.h
//  YeBa
//
//  Created by CoderYLiu on 16/3/29.
//  Copyright © 2016年 夜吧科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBAlertView : UIView

//@property (nonatomic, copy) dispatch_block_t leftBlock;
//@property (nonatomic, copy) dispatch_block_t rightBlock;

typedef void (^LYPLeftBlock)();
typedef void (^LYPRightBlock)();
@property(nonatomic, copy)LYPLeftBlock leftBlock;
@property(nonatomic, copy)LYPRightBlock righBlock;

@property (nonatomic, copy) dispatch_block_t dismissBlock;
/** 是否显示 */
@property (nonatomic, assign, getter=isShowx) BOOL showx;

/** 代理 */
@property (nonatomic, weak) id delegate;

- (instancetype)initWithTitle:(NSString *)title
        contentText:(NSString *)content
    leftButtonTitle:(NSString *)leftTitle
             rightButtonTitle:(NSString *)rigthTitle leftBlock:(LYPLeftBlock)leftBlock righBlock:(LYPRightBlock)righBlock;

- (instancetype)initWithTitle:(NSString *)title
        contentText:(NSString *)content
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle titleColor:(UIColor *)color contentColor :(UIColor *)contentColor isShowx:(BOOL)isShowx leftBlock:(LYPLeftBlock)leftBlock righBlock:(LYPRightBlock)righBlock;

- (void)show;

- (instancetype)initWithFramewt:(CGRect)frame;
- (void)showOther;
@end
