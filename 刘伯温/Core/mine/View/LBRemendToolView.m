//
//  LBRemendToolView.m
//  Core
//
//  Created by mac on 2017/11/12.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LBRemendToolView.h"
@interface LBRemendToolView ()
@property (nonatomic, copy)CancelBlock cancelBlock;
@property (nonatomic, copy)EnterBlock enterBlock;

@end
@implementation LBRemendToolView
+(void)showRemendViewText:(NSString *)showContent andTitleText:(NSString *)titleText andEnterText:(NSString *)neterText andCancelText:(NSString *)cancelText andEnterBlock:(EnterBlock)enterBlock andCancelBlock:(CancelBlock)cancelBlock{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    LBRemendToolView * showView = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
    showView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    id view = [[window subviews] lastObject];
    if([view isKindOfClass:[LBRemendToolView class]]){
        
        
        LBRemendToolView *shareView = (LBRemendToolView *)view;
        [shareView closeView];
        
    }else{
        [window addSubview:showView];
        
        [showView loadRemendViewText:showContent andTitleText:titleText andEnterText:neterText andCancelText:cancelText andEnterBlock:enterBlock andCancelBlock:cancelBlock];
        
    }
}

- (void)loadRemendViewText:(NSString *)showContent andTitleText:(NSString *)titleText andEnterText:(NSString *)neterText andCancelText:(NSString *)cancelText andEnterBlock:(EnterBlock)enterBlock andCancelBlock:(CancelBlock)cancelBlock{
    self.enterBlock = enterBlock;
    self.cancelBlock = cancelBlock;
    
    CGFloat leftPading = 20;
    CGFloat showViewWidth = kFullWidth-leftPading*2;
    
    UIView *showView = [[UIView alloc] initWithFrame:CGRectMake((kFullWidth-showViewWidth)/2, (kFullHeight-150)/2, showViewWidth, 150)];
    showView.backgroundColor = [UIColor whiteColor];
    [self addSubview:showView];
    showView.layer.cornerRadius = 8;
    showView.clipsToBounds = YES;
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = titleText;
    titleLabel.font = CustomUIFont(19);
    titleLabel.textColor = [UIColor blackColor];
    [showView  addSubview:titleLabel];
    titleLabel.frame = CGRectMake(leftPading, 0, showView.width, 40);
    
    
    UILabel *contentLabel = [UILabel new];
    contentLabel.text = showContent;
    contentLabel.font = CustomUIFont(16);
    contentLabel.textColor = [UIColor blackColor];
    [showView  addSubview:contentLabel];
    contentLabel.frame = CGRectMake(titleLabel.left, titleLabel.bottom, showView.width-titleLabel.left*2, 40);
    contentLabel.numberOfLines = 0;
    [contentLabel sizeToFit];
    
    UIButton *enterButton = [UIButton buttonWithType:0];
    [enterButton setTitle:neterText forState:0];
    [enterButton setTitleColor:SecondColor forState:0];
    enterButton.titleLabel.font = CustomUIFont(16);
    [enterButton addTarget:self action:@selector(enterButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [showView addSubview:enterButton];
    enterButton.frame = CGRectMake(showView.width-100,contentLabel.bottom+20, 80, 40);
    
    
    UIButton *cancleButton = [UIButton buttonWithType:0];
    [cancleButton setTitle:cancelText forState:0];
    [cancleButton setTitleColor:SecondColor forState:0];
    cancleButton.titleLabel.font = CustomUIFont(16);
    [cancleButton addTarget:self action:@selector(cancleButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [showView addSubview:cancleButton];
    cancleButton.frame = CGRectMake(enterButton.left-100,enterButton.top, enterButton.width, enterButton.height);
}

- (void)enterButtonClick{
    [self closeView];
    self.enterBlock();
}

- (void)cancleButtonClick{
    [self closeView];
    self.cancelBlock();
}

-(void)closeView
{
    [UIView animateWithDuration:0.3f animations:^{
        [self.subviews objectAtIndex:0].alpha= 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
