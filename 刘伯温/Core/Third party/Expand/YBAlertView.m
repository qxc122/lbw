//
//  YBAlertView.m
//  YeBa
//
//  Created by CoderYLiu on 16/3/29.
//  Copyright © 2016年 夜吧科技. All rights reserved.
//

#import "YBAlertView.h"
//#import "NSMutableAttributedString+AttString.h"
#define kAlertWidth 260.0f
#define kAlertHeight 180.0f

#define kTitleYOffset 15.0f
#define kTitleHeight 25.0f

#define kContentOffset 30.0f
#define kBetweenLabelOffset 20.0f

#define kSingleButtonWidth 160.0f
#define kCoupleButtonWidth 107.0f
#define kButtonHeight 40.0f
#define kButtonBottomOffset 10.0f

@interface YBAlertView (){
    BOOL remove_Self;
    UIButton *xButton;
}

@property (nonatomic, strong) UILabel *alertTitleLabel;
@property (nonatomic, strong) UILabel *alertContentLabel;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIView *backImageView;

@property (nonatomic, assign, getter=isLeftLeave) BOOL leftLeave;

@end

@implementation YBAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 5.0;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.alertTitleLabel];
        [self addSubview:self.alertContentLabel];
        [self addSubview:self.leftButton];
        [self addSubview:self.rightButton];
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    return self;
}

#pragma mark - init
- (instancetype)initWithTitle:(NSString *)title
                  contentText:(NSString *)content
              leftButtonTitle:(NSString *)leftTitle
             rightButtonTitle:(NSString *)rigthTitle leftBlock:(LYPLeftBlock)leftBlock righBlock:(LYPRightBlock)righBlock; {
    if (self = [super init]) {
        
        CGRect leftBtnFrame;
        CGRect rightBtnFrame;
        self.leftBlock = leftBlock;
        self.righBlock = righBlock;
        
        if (!leftTitle) {
            rightBtnFrame = CGRectMake((kAlertWidth - kSingleButtonWidth) * 0.5, kAlertHeight - kButtonBottomOffset - kButtonHeight, kSingleButtonWidth, kButtonHeight);
            self.rightButton.frame = rightBtnFrame;
        } else {
            leftBtnFrame = CGRectMake((kAlertWidth - 2 * kCoupleButtonWidth - kButtonBottomOffset) * 0.5, kAlertHeight - kButtonBottomOffset - kButtonHeight, kCoupleButtonWidth, kButtonHeight);
            rightBtnFrame = CGRectMake(CGRectGetMaxX(leftBtnFrame) + kButtonBottomOffset, kAlertHeight - kButtonBottomOffset - kButtonHeight, kCoupleButtonWidth, kButtonHeight);
            self.leftButton.frame = leftBtnFrame;
            self.rightButton.frame = rightBtnFrame;
        }
        
        self.alertTitleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
        self.alertContentLabel.font = [UIFont systemFontOfSize:15.0f];
        [self.leftButton setTitle:leftTitle forState:UIControlStateNormal];
        [self.rightButton setTitle:rigthTitle forState:UIControlStateNormal];
        self.alertTitleLabel.text = title;
        self.alertContentLabel.text = content;
//        self.alertContentLabel.attributedText = [NSMutableAttributedString arrtLabelText:content arrFont:CustomUIFont(15) attColor:YBColor(56.0, 64.0, 71.0, 1.0) lineLengh:3 alignment:1 colorLenghFrom :0 colorLengh:content.length];
        
        xButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [xButton setImage:[UIImage imageNamed:@"btn_close_normal.png"] forState:UIControlStateNormal];
        [xButton setImage:[UIImage imageNamed:@"btn_close_selected.png"] forState:UIControlStateHighlighted];
        xButton.frame = CGRectMake(kAlertWidth - 32, 0, 32, 32);
        [self addSubview:xButton];
        [xButton addTarget:self action:@selector(dismissAlert) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                  contentText:(NSString *)content
              leftButtonTitle:(NSString *)leftTitle
             rightButtonTitle:(NSString *)rigthTitle titleColor:(UIColor *)color contentColor :(UIColor *)contentColor isShowx:(BOOL)isShowx leftBlock:(LYPLeftBlock)leftBlock righBlock:(LYPRightBlock)righBlock {
    if (self = [super init]) {
        CGRect leftBtnFrame;
        CGRect rightBtnFrame;
        self.leftBlock = leftBlock;
        self.righBlock = righBlock;
        if (!leftTitle) {
            rightBtnFrame = CGRectMake((kAlertWidth - kSingleButtonWidth) * 0.5, kAlertHeight - kButtonBottomOffset - kButtonHeight, kSingleButtonWidth, kButtonHeight);
            self.rightButton.frame = rightBtnFrame;
            
        }else {
            leftBtnFrame = CGRectMake((kAlertWidth - 2 * kCoupleButtonWidth - kButtonBottomOffset) * 0.5, kAlertHeight - kButtonBottomOffset - kButtonHeight, kCoupleButtonWidth, kButtonHeight);
            rightBtnFrame = CGRectMake(CGRectGetMaxX(leftBtnFrame) + kButtonBottomOffset, kAlertHeight - kButtonBottomOffset - kButtonHeight, kCoupleButtonWidth, kButtonHeight);
            self.leftButton.frame = leftBtnFrame;
            self.rightButton.frame = rightBtnFrame;
        }
        self.alertTitleLabel.textColor = color;
        self.alertContentLabel.textColor = contentColor;
        self.alertTitleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        self.alertContentLabel.font = [UIFont systemFontOfSize:10.0f];
        [self.leftButton setTitle:leftTitle forState:UIControlStateNormal];
        [self.rightButton setTitle:rigthTitle forState:UIControlStateNormal];
        self.alertTitleLabel.text = title;
//        self.alertContentLabel.attributedText = [NSMutableAttributedString arrtLabelText:content arrFont:CustomUIFont(15) attColor:contentColor lineLengh:3 alignment:1 colorLenghFrom:0 colorLengh:content.length];
        self.alertContentLabel.font = [UIFont systemFontOfSize:13.0f];
        
        
    }
    return self;
}


- (UIViewController *)appRootViewController {
    if (self.delegate) {
        return (UIViewController *)self.delegate;
    } else {
        UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        while (appRootVC.parentViewController) {
            appRootVC = appRootVC.presentedViewController;
        }
        return appRootVC;
    }
}

- (void)removeFromSuperview {
    [self.backImageView removeFromSuperview];
    self.backImageView = nil;
    UIViewController *topVC = [self appRootViewController];
    CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, CGRectGetHeight(topVC.view.bounds), kAlertWidth, kAlertHeight);
    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = afterFrame;
        if (self.isLeftLeave) {
            self.transform = CGAffineTransformMakeRotation(-M_1_PI / 1.5);
        } else {
            self.transform = CGAffineTransformMakeRotation(M_1_PI / 1.5);
        }
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview == nil) {
        return;
    }
    UIViewController *topVC = [self appRootViewController];
    
    if (!self.backImageView) {
        self.backImageView = [[UIView alloc] initWithFrame:topVC.view.bounds];
        self.backImageView.backgroundColor = [UIColor blackColor];
        self.backImageView.alpha = 0.6f;
        self.backImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    UITapGestureRecognizer *removetap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removetagclick:)];
    removetap.numberOfTapsRequired = 1;
    removetap.numberOfTouchesRequired = 1;
    [self.backImageView addGestureRecognizer:removetap];
    
    [topVC.view addSubview:self.backImageView];
    self.transform = CGAffineTransformMakeRotation(-M_1_PI / 2);
    CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, (CGRectGetHeight(topVC.view.bounds) - kAlertHeight) * 0.5, kAlertWidth, kAlertHeight);
    remove_Self = NO;
    
    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.transform = CGAffineTransformMakeRotation(0);
        self.frame = afterFrame;
    } completion:^(BOOL finished) {
        
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            remove_Self = YES;
//        });
        
    }];
    [super willMoveToSuperview:newSuperview];
}

#pragma mark - Event
- (void)leftBtnClicked:(id)sender {
//    self.leftLeave = YES;
    self.leftBlock();

    [self dismissAlert];
//    BLOCK_EXEC(self.leftBlock);
}

- (void)rightBtnClicked:(id)sender {
//    self.leftLeave = NO;
    self.righBlock();

    [self dismissAlert];
//    BLOCK_EXEC(self.righBlock);
}

- (void)show {
    UIViewController *topVC = [self appRootViewController];
    self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, - kAlertHeight - 10, kAlertWidth, kAlertHeight);
    [topVC.view addSubview:self];
}


- (void)showOther {
    UIViewController *topVC = [self appRootViewController];
    self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, - kAlertHeight - 10, kAlertWidth, kAlertHeight);
    [topVC.view addSubview:self];
    
    
    
    self.backImageView.userInteractionEnabled = NO;
    xButton.hidden = YES;
}



- (void)dismissAlert {
    [self removeFromSuperview];
//    BLOCK_EXEC(self.dismissBlock);
}

- (void)removetagclick:(UITapGestureRecognizer *)tap {
    
    if (!remove_Self) {
        return;
    }
    
    [self removeFromSuperview];
    [self dismissAlert];
//    BLOCK_EXEC(self.leftBlock)
}


#pragma mark - lazy loading
- (UILabel *)alertTitleLabel {
    if (!_alertTitleLabel) {
        _alertTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kTitleYOffset, kAlertWidth, kTitleHeight)];
//        _alertTitleLabel.textColor = YBColor(56.0, 64.0, 71.0, 1.0);
        _alertTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _alertTitleLabel;
}

- (UILabel *)alertContentLabel {
    if (!_alertContentLabel) {
        CGFloat contentLabelWidth = kAlertWidth - 16;
        _alertContentLabel = [[UILabel alloc] initWithFrame:CGRectMake((kAlertWidth - contentLabelWidth) * 0.5, CGRectGetMaxY(self.alertTitleLabel.frame), contentLabelWidth, 60)];
        _alertContentLabel.numberOfLines = 0;
//        _alertContentLabel.textColor = YBColor(127.0, 127.0, 127.0, 1.0);
        _alertContentLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _alertContentLabel;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _leftButton.backgroundColor = YBmainTextColor;
//        _leftButton.layer.borderWidth = 1.0f;
//        _leftButton.layer.borderColor = YBColor(255.0, 255.0, 255.0, 1.0).CGColor;
        _leftButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        [_leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _leftButton.layer.cornerRadius = 3.0f;
        _leftButton.layer.masksToBounds = YES;
        _leftButton.backgroundColor = [UIColor lightGrayColor];
        [_leftButton addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_rightButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:251/255.0 green:49/255.0 blue:121/255.0 alpha:1]] forState:UIControlStateNormal];
        _rightButton.backgroundColor = [UIColor orangeColor];
        _rightButton.layer.cornerRadius = 3.0f;
        _rightButton.layer.masksToBounds = YES;
         _rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

@end

