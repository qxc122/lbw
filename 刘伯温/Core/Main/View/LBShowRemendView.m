//
//  LBShowRemendView.m
//  Core
//
//  Created by mac on 2017/10/8.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LBShowRemendView.h"
@interface LBShowRemendView ()
@property (nonatomic, copy)EnterBlock enterBlock;

@end
@implementation LBShowRemendView

+(void)showRemendViewText:(NSString *)showContent andTitleText:(NSString *)titleText andEnterText:(NSString *)neterText andEnterBlock:(EnterBlock)enterBlock{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    LBShowRemendView * showView = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
    showView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    id view = [[window subviews] lastObject];
    if([view isKindOfClass:[LBShowRemendView class]]){
        
        
        LBShowRemendView *shareView = (LBShowRemendView *)view;
        [shareView closeView];
        
    }else{
        [window addSubview:showView];
        
        [showView loadRemendViewText:showContent andTitleText:titleText andEnterText:neterText andEnterBlock:enterBlock];
        
    }
}
-(void)loadRemendViewText:(NSString *)showContent andTitleText:(NSString *)titleText andEnterText:(NSString *)neterText andEnterBlock:(EnterBlock)enterBlock{
    self.enterBlock = enterBlock;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView)];
    [self addGestureRecognizer:tap];
    
    CGFloat leftPading = 20;
    CGFloat showViewWidth = kFullWidth-leftPading*2;
    
    UIView *showView = [[UIView alloc] initWithFrame:CGRectMake((kFullWidth-showViewWidth)/2, (kFullHeight-150)/2, showViewWidth, 180)];
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
    contentLabel.frame = CGRectMake(titleLabel.left, titleLabel.bottom, showView.width-titleLabel.left, 80);
    contentLabel.numberOfLines = 0;
    
    UIButton *enterButton = [UIButton buttonWithType:0];
    [enterButton setTitle:neterText forState:0];
    [enterButton setTitleColor:CustomColor(62, 161, 147, 1) forState:0];
    enterButton.titleLabel.font = CustomUIFont(16);
    [enterButton addTarget:self action:@selector(enterButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [showView addSubview:enterButton];
    enterButton.frame = CGRectMake(showView.width-120,contentLabel.bottom+20, 100, 30);
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground)
                                                 name:@"applicationDidEnterBackground"
                                               object:nil];
}
- (void)applicationDidEnterBackground{
    [self closeView];
}
- (void)enterButtonClick{
    [self closeView];
    self.enterBlock();
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
