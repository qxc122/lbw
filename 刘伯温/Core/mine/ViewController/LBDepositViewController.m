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
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UITextField *accontTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *listButton;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (nonatomic,strong)NSArray *listArr;
@property (nonatomic,assign)BOOL isSelectPlate;
@property (nonatomic,assign)NSInteger   selectIndex;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TopSpaceing;

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
    if (!self.isSelectPlate){
        message = @"请选择转入平台";
    }else if ([self.amount intValue] < [self.moneyTextField.text intValue]){
        message = @"余额不足";
    }else if (!self.accontTextField.text.length){
        message = @"请输入平台账号";
    }else if (!self.nameTextField.text.length){
        message = @"请输入姓名";
    }else if ([self.moneyTextField.text floatValue] <= 0){
        message = @"转入金额必须大于0";
    }else if (!self.nameTextField.text.length){
        message = @"请输入平台密码";
    }
    
    
    if (message.length){
        [MBProgressHUD showMessage:message finishBlock:nil]; return;
    }
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"token"] = TOKEN;
    paramDict[@"amount"] = self.moneyTextField.text;
    paramDict[@"plate"] = self.listButton.titleLabel.text;
    paramDict[@"plateAccount"] = self.accontTextField.text;
    paramDict[@"trueName"] = self.nameTextField.text;
    paramDict[@"platePassword"] = @"";
    paramDict[@"sign"] = [[LBToolModel sharedInstance] getSign:paramDict];
    LBGetHappyPlateListModel *model = self.listArr[self.selectIndex];

    WeakSelf
    [LBRemendToolView showRemendViewText:[NSString stringWithFormat:@"您将%@元转入平台[%@]，平台账号[%@]，确定信息正确？",self.moneyTextField.text,model.plate_name,self.accontTextField.text] andTitleText:@"转账" andEnterText:@"确定转账" andCancelText:@"取消" andEnterBlock:^{
        [VBHttpsTool postWithURL:@"happyPay" params:paramDict success:^(id json) {
            if ([json[@"result"] intValue] ==1){
                [[NSUserDefaults standardUserDefaults] setObject:self.accontTextField.text forKey:@"plateAccount"];
                [[NSUserDefaults standardUserDefaults] setObject:self.nameTextField.text forKey:@"trueName"];
                
                [[NSUserDefaults standardUserDefaults] setObject:self.passwordTextField.text forKey:@"platePassword"];

                [LBShowRemendView showRemendViewText:@"提交成功！请稍待几分钟，后台在审核处理" andTitleText:@"转帐" andEnterText:@"知道了" andEnterBlock:^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
            }
        } failure:^(NSError *error) {
            
        }];
    } andCancelBlock:^{
        
    }];

    

}

- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu{
    if (!self.listArr.count)return;
    self.isSelectPlate = YES;
    self.selectIndex = index;
    LBGetHappyPlateListModel *model = self.listArr[index];
    [self.listButton setTitle:model.plate_name forState:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    if (IS_iPhoneX) {
//        self.TopSpaceing.constant = 104;
//    }
            self.TopSpaceing.constant = 20;
    
    self.title = @"转换现金";
    self.backView.layer.borderWidth = 1;
    self.backView.layer.borderColor = CustomColor(240, 240, 240, 1).CGColor;
    self.amountLabel.text = [NSString stringWithFormat:@"%@元",self.amount];
    
    self.accontTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"plateAccount"];
    self.nameTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"trueName"];
    
    self.passwordTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"platePassword"];
    
    self.moneyTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    self.passwordTextField.keyboardType = UIKeyboardTypeAlphabet;
    [self getHappyPlateList];
    // Do any additional setup after loading the view from its nib.
}

- (void)getHappyPlateList{
    WeakSelf
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"token"] = TOKEN;
    paramDict[@"sign"] = [[LBToolModel sharedInstance] getSign:paramDict];
    [VBHttpsTool postWithURL:@"getHappyPlateList" params:paramDict success:^(id json) {
         if ([json[@"result"] intValue] ==1){
             weakSelf.listArr = [NSArray modelArrayWithClass:[LBGetHappyPlateListModel class] json:json[@"data"]];
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

@implementation LBGetHappyPlateListModel
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return@{@"ID" :@"id"};
}
@end
