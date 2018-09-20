//
//  LBFeedBackViewController.m
//  Core
//
//  Created by mac on 2017/9/23.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LBFeedBackViewController.h"
#import "PlaceholderTextView.h"

@interface LBFeedBackViewController ()
@property (nonatomic, strong)PlaceholderTextView *plachholderTextView;
@property(nonatomic, strong)UITextField *textField;

@end

@implementation LBFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackGroundColor;
    
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    CGFloat leftPading = 10;
    self.plachholderTextView = [[PlaceholderTextView alloc] initWithFrame:CGRectMake(leftPading, leftPading, kFullWidth-leftPading*2, 100)];
    self.plachholderTextView.placeholderFont = CustomUIFont(14);
    self.plachholderTextView.font = CustomUIFont(14);
    self.plachholderTextView.placeholder = @"欢迎留下您的反馈或申诉";
    [self.view addSubview:self.plachholderTextView];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(leftPading, self.plachholderTextView.bottom+leftPading, self.plachholderTextView.width, 50)];
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.placeholder = @"你的联系方式 手机号/QQ/邮箱";
    [self.view addSubview:self.textField];
    
    UIButton *sendButton = [UIButton buttonWithType:0];
    [sendButton setTitle:@"提交" forState:0];
    [sendButton setTitleColor:[UIColor whiteColor] forState:0];
    sendButton.titleLabel.font = CustomUIFont(15);
    [sendButton addTarget:self action:@selector(sendButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
    sendButton.backgroundColor = MainColor;
    sendButton.frame = CGRectMake(leftPading, self.textField.bottom+leftPading*3, self.textField.width, 45);
    sendButton.layer.cornerRadius = 5;
    sendButton.clipsToBounds = YES;
}

- (void)sendButtonClick{
    if (!self.plachholderTextView.text.length){
        [MBProgressHUD showMessage:@"反馈不能为空" finishBlock:nil];
        return;
    }
    if (!self.textField.text.length){
        [MBProgressHUD showMessage:@"联系方式不能为空" finishBlock:nil];
        return;
    }
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"token"] = TOKEN;
    paramDict[@"msg"] = self.plachholderTextView.text;
    paramDict[@"contact"] = self.textField.text;
    paramDict[@"sign"] = [[LBToolModel sharedInstance]getSign:paramDict];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [VBHttpsTool postWithURL:@"feedback" params:paramDict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([json[@"result"] intValue] ==1){
            [self.navigationController popViewControllerAnimated:YES];
            [MBProgressHUD showMessage:@"感谢您的意见" finishBlock:nil];
        }
    } failure:^(NSError *error) {
        
    }];
    
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
