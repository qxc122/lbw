//
//  LBRechargerViewController.m
//  Core
//
//  Created by mac on 2017/9/30.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LBRechargerViewController.h"
#import "LBActivationListViewController.h"
#import "LBShowRemendView.h"

@interface LBRechargerViewController ()

@property (weak, nonatomic) IBOutlet UIButton *enterButton;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *deceLabel;
@property (strong, nonatomic)  UIWebView *content;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topspaceing;
@end

@implementation LBRechargerViewController
- (IBAction)clickBtn:(id)sender {
    LBActivationListViewController *VC = [LBActivationListViewController new];
    
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)enterClick:(id)sender {
    [self.textField resignFirstResponder];
    if (!self.textField.text.length){
        [MBProgressHUD showMessage:@"请输入卡号" finishBlock:nil];
        return;
    }
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"cardNum"] = self.textField.text;
    paramDict[@"token"] = TOKEN;
    paramDict[@"timestamp"] = [[LBToolModel sharedInstance] getTimestamp];
    paramDict[@"sign"] = [[LBToolModel sharedInstance]getSign:paramDict];
    
    WeakSelf
    [VBHttpsTool postWithURL:@"activationCard" params:paramDict success:^(id json) {
        
        if ([json[@"result"] intValue] ==1){
            dispatch_async(dispatch_get_main_queue(), ^{
                [LBShowRemendView showRemendViewText:@"点卡激活成功，尽情享受直播吧" andTitleText:@"刘伯温" andEnterText:@"知道了" andEnterBlock:^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    [[NSUserDefaults standardUserDefaults] setObject:@"2030-11-11 12:24:20" forKey:@"expirationDate"];
                }];
            });
        }else{
            [MBProgressHUD showMessage:json[@"info"] finishBlock:nil];
        }
    } failure:^(NSError *error) {
        
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值卡";
    
    self.topspaceing.constant = 20;
    self.enterButton.layer.cornerRadius = 4;
    self.enterButton.clipsToBounds = YES;
    
    self.content = [UIWebView new];
    [self.view addSubview:self.content];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.enterButton);
        make.right.equalTo(self.enterButton);
        make.top.equalTo(self.enterButton.mas_bottom).offset(10);
        make.height.equalTo(@220);
    }];
    self.content.backgroundColor = [UIColor clearColor];
    self.content.scrollView.bounces = NO;

    [self.content loadHTMLString:[ChatTool shareChatTool].basicConfig.publishMsg baseURL:nil];

    
    UIView *back = [UIView new];
    [self.view addSubview:back];
    
    UILabel *title = [UILabel new];
    [self.view addSubview:title];
    
    UIView *line = [UIView new];
    [self.view addSubview:line];
    
    
    UIButton *btn1 = [UIButton new];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton new];
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [UIButton new];
    [self.view addSubview:btn3];
    
    UIButton *btn4 = [UIButton new];
    [self.view addSubview:btn4];
    
    [back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.content);
        make.right.equalTo(self.content);
        make.top.equalTo(self.content.mas_bottom).offset(5);
        make.bottom.equalTo(btn4.mas_bottom).offset(5);
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.content);
        make.right.equalTo(self.content);
        make.top.equalTo(back).offset(30);
    }];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.content);
        make.top.equalTo(back);
        make.bottom.equalTo(line);
    }];
    title.font = [UIFont systemFontOfSize:14];
    title.textColor = [UIColor darkTextColor];
    title.text = @"自助购买卡密";
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.content);
        make.top.equalTo(line.mas_bottom).offset(5);
        make.height.equalTo(@60);
        make.width.equalTo(@[btn2,btn3,btn4]);
    }];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn1.mas_right).offset(20);
        make.right.equalTo(self.content);
        make.top.equalTo(btn1);
        make.height.equalTo(@60);
    }];
    [btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn1);
        make.right.equalTo(btn1);
        make.top.equalTo(btn1.mas_bottom).offset(5);
        make.height.equalTo(@60);
    }];
    [btn4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn2);
        make.right.equalTo(btn2);
        make.top.equalTo(btn3);
        make.height.equalTo(@60);
    }];
    back.backgroundColor = [UIColor whiteColor];
    line.backgroundColor = [UIColor darkGrayColor];
    [btn1 setImage:[UIImage imageNamed:card_one] forState:UIControlStateNormal];
    btn1.restorationIdentifier = card_one;
    [btn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn2 setImage:[UIImage imageNamed:card_two] forState:UIControlStateNormal];
    btn2.restorationIdentifier = card_two;
    [btn2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn3 setImage:[UIImage imageNamed:card_three] forState:UIControlStateNormal];
    btn3.restorationIdentifier = card_three;
    [btn3 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn4 setImage:[UIImage imageNamed:card_four] forState:UIControlStateNormal];
    btn4.restorationIdentifier = card_four;
    [btn4 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnClick:(UIButton *)btn {
    NSString *url = @"https://i.loli.net/2018/07/26/5b59991b753f7.png";
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}
@end
