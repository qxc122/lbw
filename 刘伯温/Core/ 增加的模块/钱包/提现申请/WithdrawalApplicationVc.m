//
//  WithdrawalApplicationVc.m
//  Core
//
//  Created by heiguohua on 2018/9/11.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "WithdrawalApplicationVc.h"
#import "CashWithdrawalDetailsVc.h"
#import "MyBankCardVc.h"
@interface WithdrawalApplicationVc ()
@property (nonatomic,weak)UIView *back;

@property (nonatomic,weak)UILabel *one1;
@property (nonatomic,weak)UIImageView *bankIcon;
@property (nonatomic,weak)UILabel *bankName;
@property (nonatomic,weak)UIImageView *bankmore;
@property (nonatomic,weak)UIButton *bankSelect;


@property (nonatomic,weak)UIView *middle;

@property (nonatomic,weak)UILabel *two;


@property (nonatomic,weak)UITextField *Three;
@property (nonatomic,weak)UIView *line3;

@property (nonatomic,weak)UILabel *four;
@property (nonatomic,weak)UILabel *five;


@property (nonatomic,weak)UIButton *next;


@property (nonatomic,weak)UIView *backBottom;

@property (nonatomic,strong)bankOne *bank_type;

@end

@implementation WithdrawalApplicationVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现申请";
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提现明细" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];

    UIView *back =[UIView new];
    self.back = back;
    [self.view addSubview:back];

    
    UILabel *one1 = [UILabel new];
    self.one1 = one1;
    [self.view addSubview:one1];
    
    UIImageView *bankIcon = [UIImageView new];
    self.bankIcon = bankIcon;
    [self.view addSubview:bankIcon];
    
    UILabel *bankName = [UILabel new];
    self.bankName = bankName;
    [self.view addSubview:bankName];
    
    UIImageView *bankmore = [UIImageView new];
    self.bankmore = bankmore;
    [self.view addSubview:bankmore];
    
    UIButton *bankSelect = [UIButton new];
    self.bankSelect = bankSelect;
    [self.view addSubview:bankSelect];
    
    UIView *middle =[UIView new];
    self.middle = middle;
    [self.view addSubview:middle];
    
    
    UILabel *two =[UILabel new];
    self.two = two;
    [self.view addSubview:two];
    
    UIView *line3 =[UIView new];
    self.line3 = line3;
    [self.view addSubview:line3];
    UITextField *Three =[UITextField new];
    self.Three = Three;
    [self.view addSubview:Three];
    

    UILabel *four =[UILabel new];
    self.four = four;
    [self.view addSubview:four];
    
    UILabel *five =[UILabel new];
    self.five = five;
    [self.view addSubview:five];
    
    
    UIButton *next =[UIButton new];
    self.next = next;
    [self.view addSubview:next];
    
    UIView *backBottom =[UIView new];
    self.backBottom = backBottom;
    [self.view addSubview:backBottom];
    
    [back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.view).offset(15);
        make.height.equalTo(@(60));
    }];
    
    [one1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.back).offset(10);
        make.top.equalTo(self.back);
        make.bottom.equalTo(self.back);
    }];
    
    [bankIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.one1.mas_right).offset(10);
        make.centerY.equalTo(self.one1);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    
    [bankName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bankIcon.mas_right).offset(5);
        make.right.equalTo(self.bankmore.mas_left).offset(-5);
        make.centerY.equalTo(self.one1);
    }];
    
    [bankmore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.back).offset(-15);
        make.centerY.equalTo(self.one1);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    
    [bankSelect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bankmore);
        make.left.equalTo(self.bankIcon);
        make.top.equalTo(self.one1);
        make.bottom.equalTo(self.one1);
    }];
    
    [middle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.back);
        make.right.equalTo(self.back);
        make.top.equalTo(self.back.mas_bottom);
    }];

    [two mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.one1).offset(10);
        make.top.equalTo(self.back.mas_bottom).offset(15);
    }];

    [Three mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.two);
        make.top.equalTo(self.two.mas_bottom).offset(5);
        make.height.equalTo(@40);
    }];

    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.back).offset(5);
        make.right.equalTo(self.back).offset(-5);
        make.top.equalTo(self.Three.mas_bottom).offset(5);
        make.height.equalTo(@0.5);
    }];
    
    [four mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.one1);
        make.top.equalTo(self.line3.mas_bottom).offset(5);
    }];

    [five mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.line3).offset(-10);
        make.top.equalTo(self.line3.mas_bottom).offset(5);
    }];
    
    [next mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line3).offset(10);
        make.right.equalTo(self.line3).offset(-10);
        make.top.equalTo(self.line3.mas_bottom).offset(23);
        make.height.equalTo(@44);
        make.bottom.equalTo(middle).offset(-10);
    }];
    [backBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.back);
        make.right.equalTo(self.back);
        make.top.equalTo(self.next.mas_bottom).offset(10);
        make.height.equalTo(@5);
    }];
    backBottom.backgroundColor = MainColor;
    back.backgroundColor = [UIColor lightGrayColor];
    middle.backgroundColor = [UIColor whiteColor];
    self.line3.backgroundColor = BackGroundColor;

    
    [next setTitle:@"申请提现" forState:UIControlStateNormal];
    [next setBackgroundColor:MainColor];
    [next  setTintColor:[UIColor whiteColor]];
    next.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    
    one1.font = [UIFont systemFontOfSize:15];
    one1.textColor = [UIColor lightTextColor];
    one1.text = @"到账银行";
    bankIcon.image = [UIImage imageNamed:bank_tidai];
    
    bankmore.image = [UIImage imageNamed:bank_select_right];
    
    bankName.font = [UIFont systemFontOfSize:15];
    bankName.textColor = MainColor;
    bankName.text = @"请选择银行卡";
    
    [bankSelect addTarget:self action:@selector(bankSelectClick) forControlEvents:UIControlEventTouchUpInside];
    [next addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    
    two.font = [UIFont systemFontOfSize:13];
    two.textColor = [UIColor darkTextColor];
    two.text = @"提现金额";

    Three.font = [UIFont systemFontOfSize:15];
    Three.textColor = [UIColor darkTextColor];
    Three.placeholder = @"请输入金额";
    Three.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)bankSelectClick{
    MyBankCardVc *vc =[MyBankCardVc new];
    [self OPenVc:vc];
}
- (void)nextClick{
    if (!self.bank_type) {
        [MBProgressHUD showPrompt:@"请先选择银行卡" toView:self.view];
        return;
    }
    if (!self.Three.text.length) {
        [MBProgressHUD showPrompt:@"请输入金额" toView:self.view];
        return;
    }
    kWeakSelf(self);
    [MBProgressHUD showLoadingMessage:@"提现中..." toView:self.view];
    [[ToolHelper shareToolHelper] submitCashWithbank_type:self.bank_type.bankType cardNumber:self.bank_type.cardNumber trueName:self.bank_type.trueName phone:self.bank_type.phone amount:self.Three.text success:^(id dataDict, NSString *msg, NSInteger code) {
        [MBProgressHUD hideHUDForView:weakself.view];
        [MBProgressHUD showPrompt:msg];
    } failure:^(NSInteger errorCode, NSString *msg) {
        [MBProgressHUD hideHUDForView:weakself.view];
        [MBProgressHUD showPrompt:msg];
    }];
}

- (void)rightClick{
    CashWithdrawalDetailsVc *vc =[CashWithdrawalDetailsVc new];
    [self OPenVc:vc];
}
@end
