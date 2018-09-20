//
//  LBForgetPassWorldViewController.m
//  Core
//
//  Created by mac on 2017/9/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LBForgetPassWorldViewController.h"

@interface LBForgetPassWorldViewController ()
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UIButton *enterButton;

@property(nonatomic, strong)UIButton *codeButton;

@end

@implementation LBForgetPassWorldViewController
- (IBAction)enterClick:(id)sender {
    if (self.isEnterVC){
        if (!self.passwordTextField.text.length ||!self.phoneNumTextField.text.length){
            [MBProgressHUD showMessage:@"密码不能为空" finishBlock:nil];
            return;
        }
        
        if (![self.passwordTextField.text isEqualToString:self.phoneNumTextField.text]){
            [MBProgressHUD showMessage:@"输入密码不一致" finishBlock:nil];
            return;
        }
        
        [self forgetPassword];
        
        
    }else{
        if (!self.phoneNumTextField.text.length){
            [MBProgressHUD showMessage:@"手机号不能为空" finishBlock:nil];
            return;
        }
        
        if (!self.passwordTextField.text.length){
            [MBProgressHUD showMessage:@"验证码不能为空" finishBlock:nil];
            return;
        }
        self.codeStr = self.passwordTextField.text;
        self.phoneNun = self.phoneNumTextField.text;
        
        LBForgetPassWorldViewController *VC = [[LBForgetPassWorldViewController alloc] initWithNibName:@"LBForgetPassWorldViewController" bundle:nil];
        VC.isEnterVC = YES;
        VC.codeStr = self.codeStr;
        VC.phoneNun = self.phoneNun;
        [self presentViewController:VC animated:YES completion:nil];
        
    }
}

- (void)forgetPassword{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"phone"] = self.phoneNun;

    paramDict[@"newPassword"] = [[self.passwordTextField.text dataUsingEncoding:NSUTF8StringEncoding] md5String];
    
//    paramDict[@"newPassword"] = [self.passwordTextField.text md5String];
    paramDict[@"verCode"] = self.codeStr;
    paramDict[@"sign"] = [[LBToolModel sharedInstance]getSign:paramDict];
    [VBHttpsTool postWithURL:@"forgetPassword" params:paramDict success:^(id json) {
        if ([json[@"result"] intValue] ==1){
            [MBProgressHUD showMessage:@"修改成功" finishBlock:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } failure:^(NSError *error) {
        
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.enterButton.backgroundColor = MainColor;
    if (self.isEnterVC){
        [self.enterButton setTitle:@"确定" forState:0];
        self.phoneNumTextField.placeholder = @"设置新密码";
        self.passwordTextField.placeholder = @"再次确认密码";

    }else{
        UIButton *codeButton = [UIButton buttonWithType:0];
        codeButton.frame = CGRectMake(0, 4, 100, 50-8);
        self.codeButton = codeButton;
        codeButton.backgroundColor = MainColor;
        [codeButton setTitle:@"获取验证码" forState:0];
        [codeButton setTitleColor:[UIColor whiteColor] forState:0];
        codeButton.titleLabel.font = CustomUIFont(15);
        [codeButton addTarget:self action:@selector(codeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        self.passwordTextField.rightView = codeButton;
        self.passwordTextField.rightViewMode = UITextFieldViewModeAlways;
    }

}


- (void)codeButtonClick{
    if (self.phoneNumTextField.text.length !=11){
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
    paramDict[@"phone"] = self.phoneNumTextField.text;
    paramDict[@"type"] = @"1";
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
