//
//  LBDepositViewController.m
//  Core
//
//  Created by Jan on 2018/4/6.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "LBDepositViewController.h"
#import "VBHttpsTool.h"
#import "YBPopupMenu.h"
#import "LBShowRemendView.h"
#import "LBRemendToolView.h"
@interface LBDepositViewController ()<YBPopupMenuDelegate>
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UITextField *accontTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *listButton;
@property (weak, nonatomic) IBOutlet UIButton *next;
@property (weak, nonatomic) IBOutlet UILabel *dqye;

@property (weak, nonatomic) IBOutlet UILabel *line;

@property (nonatomic,strong)NSArray *listArr;
@property (nonatomic,assign)NSInteger   selectIndex;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TopSpaceing;

@property (nonatomic,strong)LBGetHappyPlateListModel *Selemodel;
@end

@implementation LBDepositViewController
- (IBAction)listClick:(id)sender {
    NSMutableArray *titleArr = [NSMutableArray array];
    for (LBGetHappyPlateListModel *model in self.listArr) {
        [titleArr addObject:model.plate_name];
    }
    if (!titleArr.count)return;

    CGRect absoluteRect = [self.listButton convertRect:self.listButton.bounds toView:WINDOW];
    CGPoint relyPoint = CGPointMake(absoluteRect.origin.x + absoluteRect.size.width, absoluteRect.origin.y + absoluteRect.size.height);
    [YBPopupMenu showAtPoint:relyPoint titles:titleArr icons:titleArr menuWidth:200 delegate:self];
}
- (IBAction)enterClick:(id)sender {
    NSString *message;
    NSString *tmp = self.moneyTextField.text;//转入的金额
    if (!self.Selemodel){
        message = @"请选择转入平台";
    }else if ([self.amount intValue] <= 0){
        message = @"余额不足";
    }else if ([self.amount intValue] < [self.moneyTextField.text intValue] || [self.moneyTextField.text intValue] <= 0){
        if (self.Selemodel.plate_account.length) {
            if ([self.amount intValue] < [self.moneyTextField.text intValue]){
                message = @"余额不足";
            }else if([self.moneyTextField.text intValue] <= 0){
                message = @"请输入有效金额";
            }
        }
    }else if (!self.accontTextField.text.length){
        if (![self.Selemodel.plate_reg_type isEqualToString:@"1"]) {
            message = @"请输入平台账号";
        }
    }
    if (message.length){
        [MBProgressHUD showPrompt:message toView:self.view];
         return;
    }
    [self.view endEditing:NO];
    
    if (!self.Selemodel.plate_account.length && [self.Selemodel.plate_reg_type isEqualToString:@"1"]) {
        tmp = self.amount;
    }
    
    WeakSelf
    
    [LBRemendToolView showRemendViewText:[NSString stringWithFormat:@"您将%@元转入平台[%@]，平台账号[%@]，确定信息正确？",tmp,self.Selemodel.plate_name,self.accontTextField.text] andTitleText:@"转账" andEnterText:@"确定转账" andCancelText:@"取消" andEnterBlock:^{
        [weakSelf loadData];
    } andCancelBlock:^{
        
    }];
}

- (void)loadData{
    LBGetMyInfoModel *data =  [NSKeyedUnarchiver unarchiveObjectWithFile:PATH_UESRINFO];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"token"] = TOKEN;
    
    if (!self.Selemodel.plate_account.length && [self.Selemodel.plate_reg_type isEqualToString:@"1"]) {
        paramDict[@"amount"] = self.amount;
    }else{
        paramDict[@"amount"] = self.moneyTextField.text;
    }
    paramDict[@"plate"] = self.listButton.titleLabel.text;
    paramDict[@"plateAccount"] = self.accontTextField.text;
    paramDict[@"trueName"] = self.nameTextField.text;
    paramDict[@"platePassword"] = @"";
    paramDict[@"phone"] = data.phone;
    paramDict[@"sign"] = [[LBToolModel sharedInstance] getSign:paramDict];
    WeakSelf
    [MBProgressHUD showLoadingMessage:@"提交中..." toView:self.view];
    [VBHttpsTool postWithURL:@"happyPay" params:paramDict success:^(id json) {
        if ([json[@"result"] intValue] ==1){
            [[NSUserDefaults standardUserDefaults] setObject:self.accontTextField.text forKey:@"plateAccount"];
            [[NSUserDefaults standardUserDefaults] setObject:self.nameTextField.text forKey:@"trueName"];
            [MBProgressHUD hideHUDForView:weakSelf.view];
            [LBShowRemendView showRemendViewText:@"提交成功！请稍待几分钟，后台在审核处理" andTitleText:@"转帐" andEnterText:@"知道了" andEnterBlock:^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
            
            if (!weakSelf.Selemodel.plate_account.length && [weakSelf.Selemodel.plate_reg_type isEqualToString:@"1"]) {
                weakSelf.amount = @"0";
            }else{
                weakSelf.amount = [NSString stringWithFormat:@"%.2f",[weakSelf.amount floatValue] - [self.moneyTextField.text floatValue]];
            }

            weakSelf.amountLabel.text = [NSString stringWithFormat:@"%@元",weakSelf.amount];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"chageUserInfoNotifi" object:nil];
        }else{
            [MBProgressHUD hideHUDForView:weakSelf.view];
//
//            [MBProgressHUD showPrompt:json[@"info"] toView:weakSelf.view];
            [weakSelf prompt:json[@"info"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
        [MBProgressHUD showPrompt:@"请重试" toView:weakSelf.view];
    }];
}

- (void)prompt:(NSString *)tmp{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:tmp preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"马上联系在线客服" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *url = @"https://kf1.learnsaas.com/chat/chatClient/chatbox.jsp?companyID=814050&configID=62885&jid=3341006926&s=1";
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu{
    if (!self.listArr.count)return;
    self.selectIndex = index;
    LBGetHappyPlateListModel *model = self.listArr[index];
    [self.listButton setTitle:model.plate_name forState:0];
    self.accontTextField.text = model.plate_account;
    self.Selemodel = model;
    
    if (model.plate_account.length) {
        self.accontTextField.hidden = YES;
        [self.next setTitle:@"确认提交" forState:UIControlStateNormal];
        self.moneyTextField.hidden = NO;
    } else {
        if ([model.plate_reg_type isEqualToString:@"1"]) {
            self.accontTextField.hidden = YES;
            [self.next setTitle:@"一键注册并全额度转入" forState:UIControlStateNormal];
            self.moneyTextField.hidden = YES;
        } else {
            self.accontTextField.hidden = NO;
            [self.next setTitle:@"确认提交" forState:UIControlStateNormal];
            self.moneyTextField.hidden = NO;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    if (IS_iPhoneX) {
//        self.TopSpaceing.constant = 104;
//    }
    self.TopSpaceing.constant = 20;
    self.title = @"转换现金";

    self.amountLabel.text = [NSString stringWithFormat:@"%@元",self.amount];
    
//    self.accontTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"plateAccount"];
//    self.nameTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"trueName"];
//
    LBGetMyInfoModel *data =  [NSKeyedUnarchiver unarchiveObjectWithFile:PATH_UESRINFO];
    self.accontTextField.text = data.plateAccount;
    self.nameTextField.text = data.surname;
//    self.moneyTextField.text = [NSString stringWithFormat:@"%@",self.amount];
    self.nameTextField.hidden = YES;
    self.moneyTextField.hidden = NO;
    self.accontTextField.hidden = NO;
    self.moneyTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.accontTextField.keyboardType = UIKeyboardTypeDefault;
    self.accontTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.moneyTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.moneyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dqye);
        make.right.equalTo(self.amountLabel);
        make.top.equalTo(self.line.mas_bottom).offset(20);
        make.height.equalTo(@50);
    }];
    
    [self.accontTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dqye);
        make.right.equalTo(self.amountLabel);
        make.top.equalTo(self.moneyTextField.mas_bottom).offset(5);
        make.height.equalTo(@50);
    }];
    
    [self.next mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dqye);
        make.right.equalTo(self.amountLabel);
        make.top.equalTo(self.accontTextField.mas_bottom).offset(20);
        make.height.equalTo(@50);
    }];
    [self getHappyPlateList];
}

- (void)getHappyPlateList{
    WeakSelf
    [MBProgressHUD showLoadingMessage:@"平台获取中..." toView:self.view];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"token"] = TOKEN;
    paramDict[@"sign"] = [[LBToolModel sharedInstance] getSign:paramDict];
    [VBHttpsTool postWithURL:@"getHappyPlateList" params:paramDict success:^(id json) {
         if ([json[@"result"] intValue] ==1){
             [MBProgressHUD hideHUDForView:weakSelf.view];
             weakSelf.listArr = [NSArray modelArrayWithClass:[LBGetHappyPlateListModel class] json:json[@"data"]];
         }
    } failure:^(NSError *error) {
        [weakSelf performSelector:@selector(getHappyPlateList) withObject:nil afterDelay:0.3];
    }];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:NO];
}
@end

@implementation LBGetHappyPlateListModel
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return@{@"ID" :@"id"};
}
@end
