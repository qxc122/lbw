//
//  AddBankCardVc.m
//  Core
//
//  Created by heiguohua on 2018/9/11.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "AddBankCardVc.h"

@interface AddBankCardVc ()
@property (nonatomic,weak)UIView *back;

@property (nonatomic,weak)UILabel *one1;
@property (nonatomic,weak)UIImageView *bankIcon;
@property (nonatomic,weak)UILabel *bankName;
@property (nonatomic,weak)UIImageView *bankmore;
@property (nonatomic,weak)UIButton *bankSelect;
@property (nonatomic,weak)UIView *line1;
@property (nonatomic,weak)UIView *line11;

@property (nonatomic,weak)UIView *middle;
@property (nonatomic,weak)UITextField *two;
@property (nonatomic,weak)UIView *line2;

@property (nonatomic,weak)UITextField *Three;
@property (nonatomic,weak)UIView *line3;

@property (nonatomic,weak)UITextField *four;
@property (nonatomic,weak)UIView *line4;

@property (nonatomic,weak)UITextField *five;
@property (nonatomic,weak)UIButton *code;

@property (nonatomic,weak)UIButton *next;


@property (nonatomic,weak)UIView *backBottom;

@property (nonatomic,strong)NSString *bank_type;

@property (nonatomic,strong) NSTimer *scrollTimer;
@property (nonatomic,assign) NSInteger num;

@property (nonatomic,strong)NSArray *arryBankNmme;  //银行列表名字
@end

@implementation AddBankCardVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定银行卡";
    UIView *back =[UIView new];
    self.back = back;
    [self.view addSubview:back];
    self.back.backgroundColor = [UIColor whiteColor];

    self.arryBankNmme =@[@"中国银行",@"中国工商银行",@"招商银行",@"中国建设银行",@"中国农业银行",@"中国邮政储蓄银行",@"中国民生银行",@"中国光大银行",@"中信银行",@"交通银行",@"兴业银行",@"上海浦东发展银行",@"中国人民银行",@"华夏银行",@"深圳发展银行",@"广东发展银行",@"国家开发银行",@"中国进出口银行",@"中国农业发展银行"];
    
    UIView *line1 =[UIView new];
    self.line1 = line1;
    [self.view addSubview:line1];
    self.line1.backgroundColor = BackGroundColor;

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

    UIView *line11 =[UIView new];
    self.line11 = line11;
    [self.view addSubview:line11];
    line11.layer.borderColor = BackGroundColor.CGColor;
    line11.layer.borderWidth = 0.5;
    
    UIView *line2 =[UIView new];
    self.line2 = line2;
    [self.view addSubview:line2];

    UITextField *two =[UITextField new];
    self.two = two;
    [self.view addSubview:two];
    
    UIView *line3 =[UIView new];
    self.line3 = line3;
    [self.view addSubview:line3];
    UITextField *Three =[UITextField new];
    self.Three = Three;
    [self.view addSubview:Three];
    
    UIView *line4 =[UIView new];
    self.line4 = line4;
    [self.view addSubview:line4];
    UITextField *four =[UITextField new];
    self.four = four;
    [self.view addSubview:four];
    
    UITextField *five =[UITextField new];
    self.five = five;
    [self.view addSubview:five];
    
    UIButton *code =[UIButton new];
    self.code = code;
    [self.view addSubview:code];
    
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
    }];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.back).offset(0);
        make.right.equalTo(self.back).offset(-0);
        make.top.equalTo(self.back).offset(60);
        make.height.equalTo(@0.5);
    }];

    [one1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.back).offset(10);
        make.top.equalTo(self.back);
        make.bottom.equalTo(self.line1.mas_top);
        make.width.equalTo(@70);
    }];
    
    [bankIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.one1.mas_right).offset(10);
        make.centerY.equalTo(self.one1);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    
    [bankName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bankIcon.mas_right).offset(5);
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
    
    [line11 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.back).offset(5);
        make.right.equalTo(self.back).offset(-5);
        make.top.equalTo(self.line1.mas_bottom).offset(5);
        make.bottom.equalTo(self.line4.mas_bottom).offset(50);
    }];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line11).offset(5);
        make.right.equalTo(self.line11).offset(-5);
        make.top.equalTo(self.line1.mas_bottom).offset(55);
        make.height.equalTo(@0.5);
    }];
    [two mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.back).offset(15);
        make.right.equalTo(self.back).offset(-15);
        make.top.equalTo(self.line1.mas_bottom).offset(5);
        make.bottom.equalTo(self.line2.mas_top);
    }];

    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line2);
        make.right.equalTo(self.line2);
        make.top.equalTo(self.line2.mas_bottom).offset(50);
        make.height.equalTo(@0.5);
    }];
    [Three mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line3).offset(10);
        make.right.equalTo(self.line3).offset(-10);
        make.top.equalTo(self.line2.mas_bottom);
        make.bottom.equalTo(self.line3.mas_top);
    }];
    
    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line3);
        make.right.equalTo(self.line3);
        make.top.equalTo(self.line3.mas_bottom).offset(50);

        make.height.equalTo(@0.5);
    }];
    [four mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line4).offset(10);
        make.right.equalTo(self.line4).offset(-10);
        make.top.equalTo(self.line3.mas_bottom);
        make.bottom.equalTo(self.line4.mas_top);
    }];
    
    [code mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.line4).offset(-10);
        make.top.equalTo(self.line4.mas_bottom).offset(5);
        make.bottom.equalTo(self.line11).offset(-5);
        make.width.equalTo(@100);
    }];
    
    [five mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line4).offset(10);
        make.right.equalTo(self.line4).offset(-10);
        make.top.equalTo(self.line4.mas_bottom);
        make.bottom.equalTo(self.line11);
    }];
    
    [next mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line4).offset(10);
        make.right.equalTo(self.line4).offset(-10);
        make.top.equalTo(self.line11.mas_bottom).offset(20);
        make.bottom.equalTo(self.back).offset(-5);
        make.height.equalTo(@44);
    }];
    [backBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.back);
        make.right.equalTo(self.back);
        make.top.equalTo(self.back.mas_bottom);
        make.height.equalTo(@5);
    }];
    backBottom.backgroundColor = MainColor;
    self.line2.backgroundColor = BackGroundColor;
    self.line3.backgroundColor = BackGroundColor;
    self.line4.backgroundColor = BackGroundColor;
    
    [code setTitle:@"获取验证码" forState:UIControlStateNormal];
    [code setBackgroundColor:MainColor];
    [code  setTintColor:[UIColor whiteColor]];
    code.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [next setTitle:@"绑定" forState:UIControlStateNormal];
    [next setBackgroundColor:MainColor];
    [next  setTintColor:[UIColor whiteColor]];
    next.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    
    one1.font = [UIFont systemFontOfSize:15];
    one1.textColor = [UIColor darkTextColor];
    one1.text = @"银行类型";
    bankIcon.image = [UIImage imageNamed:bank_tidai];
    
    bankmore.image = [UIImage imageNamed:bank_select_right];
    
    bankName.font = [UIFont systemFontOfSize:15];
    bankName.textColor = MainColor;
    bankName.text = @"请选择银行";
    
    [bankSelect addTarget:self action:@selector(bankSelectClick) forControlEvents:UIControlEventTouchUpInside];
        [next addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
        [code addTarget:self action:@selector(codeClick) forControlEvents:UIControlEventTouchUpInside];
    
    two.font = [UIFont systemFontOfSize:15];
    two.textColor = [UIColor darkTextColor];
    two.placeholder = @"银行卡号";
    two.keyboardType = UIKeyboardTypeNumberPad;
    
    
    Three.font = [UIFont systemFontOfSize:15];
    Three.textColor = [UIColor darkTextColor];
    Three.placeholder = @"持卡人签名";

    
    four.font = [UIFont systemFontOfSize:15];
    four.textColor = [UIColor darkTextColor];
    four.placeholder = @"验证手机号码";
    four.keyboardType = UIKeyboardTypeNumberPad;
    
    five.font = [UIFont systemFontOfSize:15];
    five.textColor = [UIColor darkTextColor];
    five.placeholder = @"请输入验证码";
    five.keyboardType = UIKeyboardTypeNumberPad;
    
    LBGetMyInfoModel *dataUserInfo =  [NSKeyedUnarchiver unarchiveObjectWithFile:PATH_UESRINFO];
    self.Three.text = dataUserInfo.surname;
    self.four.text = dataUserInfo.phone;
}
- (void)bankSelectClick{
    kWeakSelf(self);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择银行" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSString *type in self.arryBankNmme) {
        [alert addAction:[UIAlertAction actionWithTitle:type style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            weakself.bank_type = type;
            weakself.bankName.text = type;
            weakself.bankName.textColor = [UIColor darkTextColor];
        }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)codeClick{
    if (!self.four.text) {
        [MBProgressHUD showPrompt:@"请输入手机号" toView:self.view];
        return;
    }
    kWeakSelf(self);
    [MBProgressHUD showLoadingMessage:@"发送中..." toView:self.view];
    [[ToolHelper shareToolHelper] getVerCodeWithphone:self.four.text type:[NSNumber numberWithInt:2] success:^(id dataDict, NSString *msg, NSInteger code) {
        [MBProgressHUD hideHUDForView:weakself.view];
        [MBProgressHUD showPrompt:msg];
        [weakself creatTimer];
    } failure:^(NSInteger errorCode, NSString *msg) {
        [MBProgressHUD hideHUDForView:weakself.view];
        [MBProgressHUD showPrompt:msg];
    }];
}
- (void)nextClick{
    if (!self.bank_type) {
        [MBProgressHUD showPrompt:@"请先选择银行卡" toView:self.view];
        return;
    }
    if (!self.two.text.length) {
        [MBProgressHUD showPrompt:@"请输入银行卡号" toView:self.view];
        return;
    }
    if (!self.Three.text.length) {
        [MBProgressHUD showPrompt:@"请输入持卡人姓名" toView:self.view];
        return;
    }
    if (!self.four.text.length) {
        [MBProgressHUD showPrompt:@"请输入手机号" toView:self.view];
        return;
    }
    if (!self.five.text.length) {
        [MBProgressHUD showPrompt:@"请输入验证码" toView:self.view];
        return;
    }
    
    kWeakSelf(self);
    [MBProgressHUD showLoadingMessage:@"绑定中..." toView:self.view];
    [[ToolHelper shareToolHelper] bindBankWithbank_type:self.bank_type cardNumber:self.two.text trueName:self.Three.text phone:self.four.text vcode:self.five.text success:^(id dataDict, NSString *msg, NSInteger code) {
        [MBProgressHUD hideHUDForView:weakself.view];
        [MBProgressHUD showPrompt:msg];
    } failure:^(NSInteger errorCode, NSString *msg) {
        [MBProgressHUD hideHUDForView:weakself.view];
        [MBProgressHUD showPrompt:msg];
    }];
}



#pragma mark----创建定时器
-(void)creatTimer
{
    self.num = 60;
    _scrollTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(daojishiRunning) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_scrollTimer forMode:NSRunLoopCommonModes];
    self.code.enabled = NO;
    [self.code setTitle:@"60s" forState:UIControlStateDisabled];
}
#pragma mark----倒计时
-(void)daojishiRunning{
    self.num--;
    if (self.num == 0) {
        [self removeTimer];
    }else{
        [self.code setTitle:[NSString stringWithFormat:@"%lds",(long)self.num] forState:UIControlStateDisabled];
    }
}
#pragma mark----移除定时器
-(void)removeTimer
{
    self.code.enabled = YES;
    [self.code setTitle:NSLocalizedString(@"获取验证码", @"") forState:UIControlStateNormal];
    if (_scrollTimer) {
        [_scrollTimer invalidate];
        _scrollTimer = nil;
    }
}

- (void)dealloc{
    [self removeTimer];
}
@end
