//
//  LBRegisterViewController.m
//  Core
//
//  Created by mac on 2017/9/25.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LBRegisterViewController.h"

@interface LBRegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *invataCodeTextField;
@property(nonatomic, strong)UIButton *codeButton;
@property(nonatomic, strong)UIButton *invaicodeButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backHeight;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation LBRegisterViewController
- (IBAction)backClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    self.nextBtn.backgroundColor = MainColor;
    UIButton *codeButton = [UIButton buttonWithType:0];
    codeButton.frame = CGRectMake(0, 4, 100, self.codeTextField.height-8);
    self.codeButton = codeButton;
    codeButton.backgroundColor = MainColor;
    [codeButton setTitle:@"获取验证码" forState:0];
    [codeButton setTitleColor:[UIColor whiteColor] forState:0];
    codeButton.titleLabel.font = CustomUIFont(15);
    [codeButton addTarget:self action:@selector(codeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.codeTextField.rightView = codeButton;
    self.codeTextField.rightViewMode = UITextFieldViewModeAlways;
    
    
    UIButton *invaicodeButton = [UIButton buttonWithType:0];
    invaicodeButton.frame = CGRectMake(0, 4, 140, self.invataCodeTextField.height-8);
    self.invaicodeButton = invaicodeButton;
    [invaicodeButton setTitle:@"邀请码(可以不填)" forState:0];
    [invaicodeButton setTitleColor:CustomColor(186, 99, 4, 1) forState:0];
    invaicodeButton.titleLabel.font = CustomUIFont(16);
    [invaicodeButton addTarget:self action:@selector(invaiCodeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.invataCodeTextField.leftView = invaicodeButton;
    self.invataCodeTextField.leftViewMode = UITextFieldViewModeAlways;
    
}
- (IBAction)enterClick:(id)sender {
    if (!self.phoneTextField.text.length){
        [MBProgressHUD showMessage:@"手机号不能为空" finishBlock:nil];
        return;
    }else if (!self.passwordTextField.text.length){
        [MBProgressHUD showMessage:@"密码不能为空" finishBlock:nil];
        return;
    }else if (!self.codeTextField.text.length){
        [MBProgressHUD showMessage:@"验证码不能为空" finishBlock:nil];
        return;
    }
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"phone"] = self.phoneTextField.text;
    paramDict[@"password"] = [self.passwordTextField.text md5String];
    paramDict[@"verCode"] = self.codeTextField.text;
    paramDict[@"invitationCode"] = self.invataCodeTextField.text;
    paramDict[@"timestamp"] = [[LBToolModel sharedInstance] getTimestamp];
    paramDict[@"sign"] = [[LBToolModel sharedInstance]getSign:paramDict];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:nil];
    [VBHttpsTool postWithURL:@"regedit" params:paramDict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([json[@"result"] intValue] ==1){
            [MBProgressHUD showMessage:@"注册成功" finishBlock:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [MBProgressHUD showMessage:json[@"info"] finishBlock:nil];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)invaiCodeButtonClick{
    
}

- (void)codeButtonClick{
    if (self.phoneTextField.text.length !=11){
        [MBProgressHUD showMessage:@"手机号码格式不正确" finishBlock:nil];
        return;
    }
    [self countDownWithTime:120 countDownBlock:^(int timeLeft) {
        int seconds = timeLeft % 120;
        NSString *strTime = [[NSString stringWithFormat:@"%.2ds",seconds] copy];
        [self.codeButton setTitle:strTime forState:UIControlStateNormal];
        self.codeButton.enabled = NO;
    } endBlock:^{
        [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.codeButton.enabled = YES;
    }];
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"phone"] = self.phoneTextField.text;
    paramDict[@"type"] = @"0";
    paramDict[@"sign"] = [[LBToolModel sharedInstance] getSign:paramDict];
    [VBHttpsTool postWithURL:@"getVerCode" params:paramDict success:^(id json) {
        if ([json[@"result"] intValue] ==1){
        }else{
            [MBProgressHUD showMessage:json[@"info"] finishBlock:nil];
        }
    } failure:^(NSError *error) {
        
    }];
}


- (void)countDownWithTime:(int)time
           countDownBlock:(void (^)(int timeLeft))countDownBlock
                 endBlock:(void (^)())endBlock{
    __block int timeout = time; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (endBlock) {
                    endBlock();
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                timeout--;
                if (countDownBlock) {
                    countDownBlock(timeout);
                }
            });
        }
    });
    dispatch_resume(_timer);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
