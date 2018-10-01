//
//  LBExchangeGoldView.m
//  Core
//
//  Created by Jan on 2018/4/7.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "LBExchangeGoldView.h"
#import "VBHttpsTool.h"
#import "LBShowRemendView.h"
@interface LBExchangeGoldView ()<UITextFieldDelegate>
@property (nonatomic, copy)CancelBlock cancelBlock;
@property (nonatomic, copy)EnterBlock enterBlock;
@property (nonatomic,strong)UITextField *textField;
@property (nonatomic,weak)UILabel *titleLabel;
@end
@implementation LBExchangeGoldView

+(void)showRemendViewText:(NSString *)showContent andTitleText:(NSString *)titleText andEnterText:(NSString *)neterText andCancelText:(NSString *)cancelText andEnterBlock:(EnterBlock)enterBlock andCancelBlock:(CancelBlock)cancelBlock{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    LBExchangeGoldView * showView = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
    showView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    id view = [[window subviews] lastObject];
    if([view isKindOfClass:[LBExchangeGoldView class]]){
        
        
        LBExchangeGoldView *shareView = (LBExchangeGoldView *)view;
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
    self.titleLabel = titleLabel;
    titleLabel.text = [NSString stringWithFormat:@"兑换%d个金币,您可以得到%.2f元",[Integral intValue],[Integral intValue]*[[ChatTool shareChatTool].basicConfig.ratioCJ floatValue]/100];
//    NSString *ttt = [ChatTool shareChatTool].basicConfig.ratioCJ;
    titleLabel.font = CustomUIFont(19);
    titleLabel.textColor = [UIColor blackColor];
    [showView  addSubview:titleLabel];
    titleLabel.frame = CGRectMake(leftPading, 0, showView.width, 40);
    
    
    UITextField *textField = [UITextField new];
    textField.userInteractionEnabled = NO;
    textField.font = CustomUIFont(16);
    textField.textColor = [UIColor blackColor];
    [showView  addSubview:(self.textField=textField)];
    textField.frame = CGRectMake(titleLabel.left, titleLabel.bottom, showView.width-titleLabel.left*2, 40);
    textField.keyboardType = UIKeyboardTypeNumberPad;
    int teee = [Integral intValue];
    textField.text = [NSString stringWithFormat:@"%d",teee];
    UILabel *lineLabel = [UILabel new];
    lineLabel.backgroundColor = SecondColor;
    [showView addSubview:lineLabel];
    lineLabel.frame = CGRectMake(textField.left, textField.bottom, textField.width, 1);
    
    UIButton *enterButton = [UIButton buttonWithType:0];
    [enterButton setTitle:neterText forState:0];
    [enterButton setTitleColor:SecondColor forState:0];
    enterButton.titleLabel.font = CustomUIFont(16);
    [enterButton addTarget:self action:@selector(enterButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [showView addSubview:enterButton];
    enterButton.frame = CGRectMake(showView.width-100,textField.bottom+20, 80, 40);
    
    
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
    
    if (!self.textField.text.length){
        [MBProgressHUD showMessage:@"请输入要兑换的金币" finishBlock:nil];
        return;
    }

    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"integral"] = self.textField.text;
    paramDict[@"token"] = TOKEN;
    paramDict[@"sign"] = [[LBToolModel sharedInstance] getSign:paramDict];
    [VBHttpsTool postWithURL:@"exchangeIntegral" params:paramDict success:^(id json) {
        if ([json[@"result"] intValue] ==1){
            dispatch_async(dispatch_get_main_queue(), ^{
                self.enterBlock();
                NSString *price = json[@"data"][@"price"];
                [LBShowRemendView showRemendViewText:[NSString stringWithFormat:@"兑换成功，您获得%@元已存入您的钱包",price] andTitleText:@"成功" andEnterText:@"我知道了" andEnterBlock:^{
                    
                }];
            });
        }else{
            [MBProgressHUD showMessage:json[@"info"] finishBlock:nil];
        }
    } failure:^(NSError *error) {
        
    }];
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
