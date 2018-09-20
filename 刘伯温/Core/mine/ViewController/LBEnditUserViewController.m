//
//  LBEnditUserViewController.m
//  Core
//
//  Created by mac on 2017/9/25.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LBEnditUserViewController.h"
#import "LBLoginViewController.h"
#import "LBForgetPassWorldViewController.h"
#import "OSSImageUploader.h"
#import <JMessage/JMessage.h>
@interface LBEnditUserViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(nonatomic, strong)NSArray *sectionArr1;
@property(nonatomic, strong)NSArray *sectionArr2;


@property(nonatomic, strong)UILabel *nickNameLabel;
@property(nonatomic, strong)LBGetMyInfoModel *myinfoModel;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)UIImageView *iconImageView;

@end

@implementation LBEnditUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改个人信息";
    
    self.sectionArr1 = @[@"头像",@"昵称",@"修改密码"];
    self.sectionArr2 = @[@"真实姓名",@"邮寄地址",@"微信号",@"QQ号码",@"手机号码"];


    self.view.backgroundColor = BackGroundColor;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kFullWidth, self.view.height)];
    tableView.rowHeight = 60;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:(self.tableView=tableView)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = BackGroundColor;
    
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFullWidth, 15)];
    tableView.tableHeaderView = headView;
    
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFullWidth, 80)];
    UIButton *signoutButton = [UIButton buttonWithType:0];
    [signoutButton setTitle:@"退出登录" forState:0];
    [signoutButton setTitleColor:[UIColor whiteColor] forState:0];
    signoutButton.titleLabel.font = CustomUIFont(15);
    [signoutButton addTarget:self action:@selector(signoutButtonClick) forControlEvents:UIControlEventTouchUpInside];
    signoutButton.frame = CGRectMake(15, 30, footView.width-30, 50);
    tableView.tableFooterView = footView;
    [footView addSubview:signoutButton];
    signoutButton.backgroundColor = CustomColor(240, 73, 76, 1);
    signoutButton.layer.cornerRadius = 7;
    signoutButton.clipsToBounds = YES;
    
    [self getMyInfo];
}

- (void)signoutButtonClick{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window removeAllSubviews];
    window = nil;
    
    LBLoginViewController *vc = [[LBLoginViewController alloc] initWithNibName:@"LBLoginViewController" bundle:nil];
    LBNavigationController *nav = [[LBNavigationController alloc]initWithRootViewController:vc];
    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
    
//    [UIApplication sharedApplication].keyWindow.rootViewController = [[LBLoginViewController alloc] initWithNibName:@"LBLoginViewController" bundle:nil];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
    
    //退出当前登录的用户
    [JMSGUser logout:^(id resultObject, NSError *error) {
        if (!error) {
            //退出登录成功
            [[ToolHelper shareToolHelper].list  removeAllObjects];
        } else {
            //退出登录失败
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section ==0){
        return self.sectionArr1.count;
    }else{
        return self.sectionArr2.count;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFullWidth, 5)];
    sectionView.backgroundColor =BackGroundColor;
    return sectionView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *myCell = @"mineCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myCell];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:myCell];
        UILabel *lineLabel = [UILabel new];
        lineLabel.backgroundColor = BackGroundColor;
        [cell  addSubview:lineLabel];
        lineLabel.frame = CGRectMake(0, 58, kFullWidth, 1);
    }
    if (indexPath.section == 0){
        cell.textLabel.text = self.sectionArr1[indexPath.row];
        if (indexPath.row == 0){
            if (!self.iconImageView){
                self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kFullWidth-80, 7, 45, 45)];
                self.iconImageView.layer.cornerRadius = self.iconImageView.width/2;
                self.iconImageView.clipsToBounds = YES;
                [cell addSubview:self.iconImageView];
                if([self.infoModel.avatar rangeOfString:@"http"].location !=NSNotFound){
                    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.infoModel.avatar] placeholderImage:[UIImage imageNamed:@"头像"]];
                }else{
                    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageHead,self.infoModel.avatar]] placeholderImage:[UIImage imageNamed:@"头像"]];
                }
            }
        }else if (indexPath.row == 1){
            cell.detailTextLabel.text = self.myinfoModel.name;
        }else if (indexPath.row == 2){
        }
    }else if (indexPath.section == 1){
        cell.textLabel.text = self.sectionArr2[indexPath.row];
        if (indexPath.row == 0){
            cell.detailTextLabel.text = self.myinfoModel.surname;
        }else if (indexPath.row == 1){
            cell.detailTextLabel.text = self.myinfoModel.address;
        }else if (indexPath.row == 2){
            cell.detailTextLabel.text = self.myinfoModel.postcode;
        }else if (indexPath.row == 3){
            cell.detailTextLabel.text = self.myinfoModel.qq;
        }else if (indexPath.row == 4){
            cell.detailTextLabel.text = self.myinfoModel.phone;
        }
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0){
        if (indexPath.row == 0){
            [self getImageFromIpc];
        }else if (indexPath.row == 1){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入新的昵称" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 0;
            alertView.alertViewStyle=UIAlertViewStylePlainTextInput;
            [alertView show];
        }else if (indexPath.row == 2){
            
            LBForgetPassWorldViewController *VC = [[LBForgetPassWorldViewController alloc] initWithNibName:@"LBForgetPassWorldViewController" bundle:nil];
            VC.title = @"修改密码";
            [self.navigationController pushViewController:VC animated:YES];
//            [self presentViewController:VC animated:YES completion:nil];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入您的真实姓名" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 1;
            alertView.alertViewStyle=UIAlertViewStylePlainTextInput;
            [alertView show];
        }else if (indexPath.row == 1){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入您的邮寄地址" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 4;
            alertView.alertViewStyle=UIAlertViewStylePlainTextInput;
            [alertView show];
        }else if (indexPath.row == 2){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入您的微信号" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 5;
            alertView.alertViewStyle=UIAlertViewStylePlainTextInput;
            [alertView show];
        }else if (indexPath.row == 3){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入您的QQ号码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 3;
            alertView.alertViewStyle=UIAlertViewStylePlainTextInput;
            [alertView show];
        }else if (indexPath.row == 4){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入您的手机号码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 2;
            alertView.alertViewStyle=UIAlertViewStylePlainTextInput;
            [alertView show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        UITextField *textField = [alertView textFieldAtIndex:0];
        if (!textField.text.length)
        {
            [MBProgressHUD showMessage:@"信息不能为空" finishBlock:nil];
        }else{
            if (alertView.tag == 0){
                [self updateMyInfo:textField.text andType:@"0"];
            }else if (alertView.tag == 1){
                [self updateMyInfo:textField.text andType:@"2"];
            }else if (alertView.tag == 2){
                [self updateMyInfo:textField.text andType:@"3"];
            }else if (alertView.tag == 3){
                [self updateMyInfo:textField.text andType:@"4"];
            }else if (alertView.tag == 4){
                [self updateMyInfo:textField.text andType:@"5"];
            }else if (alertView.tag == 5){
                [self updateMyInfo:textField.text andType:@"6"];
            }
        }
        
    }
}

#pragma mark -- <UIImagePickerControllerDelegate>--
// 获取图片后的操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 销毁控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 设置图片
    
    [OSSImageUploader asyncUploadImage:info[UIImagePickerControllerOriginalImage] complete:^(NSArray<NSString *> *names, UploadImageState state) {
        if (state == UploadImageFailed) return ;
        NSMutableArray *formatImageArr = [NSMutableArray array];
        for (NSString *url in names)
        {
            [formatImageArr addObject:[NSString stringWithFormat:@"http://%@.%@%@",BucketName,AliYunHost,url]];
        }
        [self updateMyInfo:[formatImageArr firstObject] andType:@"1"];
    }];
}





- (void)getImageFromIpc
{
    // 1.判断相册是否可以打开
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
    // 2. 创建图片选择控制器
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    /**
     typedef NS_ENUM(NSInteger, UIImagePickerControllerSourceType) {
     UIImagePickerControllerSourceTypePhotoLibrary, // 相册
     UIImagePickerControllerSourceTypeCamera, // 用相机拍摄获取
     UIImagePickerControllerSourceTypeSavedPhotosAlbum // 相簿
     }
     */
    // 3. 设置打开照片相册类型(显示所有相簿)
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    // ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    // 照相机
    // ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    // 4.设置代理
    ipc.delegate = self;
    // 5.modal出这个控制器
    [self presentViewController:ipc animated:YES completion:nil];
}


- (void)updateMyInfo:(NSString *)text andType:(NSString *)type{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"timestamp"] = [[LBToolModel sharedInstance] getTimestamp];
    paramDict[@"value"] = text;
    paramDict[@"token"] = TOKEN;
    paramDict[@"type"] = type;
    paramDict[@"sign"] = [[LBToolModel sharedInstance] getSign:paramDict];
    WeakSelf
    [VBHttpsTool postWithURL:@"updateMyInfo" params:paramDict success:^(id json) {
        if ([json[@"result"] intValue] ==1){
            if ([type intValue] == 0){// 0:昵称 1:头像 2:真实姓名 3:电话 4:QQ号 5:地址 6:邮编
                [[NSNotificationCenter defaultCenter] postNotificationName:@"chageUserInfoNotifi" object:nil];
                
            }else if ([type intValue] == 1){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"chageUserInfoNotifi" object:nil];
            }else if ([type intValue] == 5){
                [[NSUserDefaults standardUserDefaults] setObject:text forKey:@"DeliveryAddress"];
            }

            
            [weakSelf getMyInfo];
        }else{
            [MBProgressHUD showMessage:json[@"info"] finishBlock:nil];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)getMyInfo{
    WeakSelf
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"timestamp"] = [[LBToolModel sharedInstance] getTimestamp];
    paramDict[@"token"] = TOKEN;
    paramDict[@"sign"] = [[LBToolModel sharedInstance] getSign:paramDict];
    [VBHttpsTool postWithURL:@"getMyInfo" params:paramDict success:^(id json) {
        if ([json[@"result"] intValue] ==1){
            weakSelf.myinfoModel = [LBGetMyInfoModel modelWithJSON:json[@"data"]];
            [weakSelf.tableView reloadData];
            [[NSUserDefaults standardUserDefaults] setBool:(weakSelf.myinfoModel.address.length ||weakSelf.myinfoModel.phone.length||weakSelf.myinfoModel.surname.length) forKey:@"hasFullInfo"];
        }else{
            [MBProgressHUD showMessage:json[@"info"] finishBlock:nil];
        }
    } failure:^(NSError *error) {
        
    }];
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
