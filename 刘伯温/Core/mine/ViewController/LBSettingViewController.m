//
//  LB.m
//  Core
//
//  Created by Jan on 2018/3/17.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "LBSettingViewController.h"
#import "LBFeedBackViewController.h"
#import "WHC_GestureUnlockScreenVC.h"

@interface LBSettingViewController()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSArray *titleArr;
@property(nonatomic, strong)NSArray *imageArr;
@property (nonatomic,strong) NSString *appUrl;
@property(nonatomic, strong)UILabel *descLabel;
@property(nonatomic, strong)UISwitch   *openSwitch;

@end

@implementation LBSettingViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"设置";
    self.titleArr = @[@"开启密码锁",@"清除缓存",@"检查更新"];
    
    self.imageArr = @[@"",@"set_clear",@"wode_r15_c4"];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.rowHeight = 50;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:(self.tableView=tableView)];
    tableView.backgroundColor = BackGroundColor;
    tableView.tableFooterView = [UIView new];
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0){
        return 1;
    }else if (section == 1){
        return 2;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFullWidth, 10)];
    sectionView.backgroundColor = BackGroundColor;
    return sectionView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *myCell = @"mineCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myCell];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myCell];
        
        
    }
    cell.backgroundColor = [UIColor whiteColor];
    if (indexPath.section == 0){
        if (indexPath.row == 0){
            if (!self.openSwitch){
                self.openSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.width-65, 10, 50, 30)];
                [self.openSwitch addTarget:self action:@selector(openSwitchChanged) forControlEvents:UIControlEventValueChanged];
                [cell addSubview:self.openSwitch];

                MMKV *mmkv = [MMKV defaultMMKV];
                if ([mmkv getBoolForKey:@"bool"]){
                    self.openSwitch.on = YES;
                }else{
                    self.openSwitch.on = NO;
                }
            }
        }
        cell.imageView.image = [UIImage imageNamed:self.imageArr[indexPath.row]];
        cell.textLabel.text = self.titleArr[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else if (indexPath.section == 1){
        cell.imageView.image = [UIImage imageNamed:self.imageArr[indexPath.row+1]];
        cell.textLabel.text = self.titleArr[indexPath.row+1];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row ==1){
            if (!self.descLabel){
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                self.descLabel = [UILabel new];
                self.descLabel.text = [NSString stringWithFormat:@"当前版本：%@",app_Version];
                self.descLabel.font = CustomUIFont(14);
                self.descLabel.textColor = [UIColor lightGrayColor];
                [cell  addSubview:self.descLabel];
                self.descLabel.textAlignment = NSTextAlignmentRight;
                self.descLabel.frame = CGRectMake(kFullWidth-180, 10, 150, 30);
            }
        }
    }
    return cell;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section ==1){
        if (indexPath.row ==0){
            [self clearDisk];
        }else if (indexPath.row == 1){
            [self upadateApp];
        }
    }
}

- (void)clearDisk{
    [MBProgressHUD showMessage:@"清除中..." view:self.view];
    kWeakSelf(self);
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        [MBProgressHUD hideHUDForView:weakself.view];
        [MBProgressHUD showMessage:@"清除成功" view:weakself.view];
    }];
}

- (void)openSwitchChanged{
    MMKV *mmkv = [MMKV defaultMMKV];
    if (self.openSwitch.isOn){
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ConfigurationKey"]) {
            [mmkv setBool:YES forKey:@"bool"];
        } else {
            [WHC_GestureUnlockScreenVC setUnlockScreenWithType:ClickNumberType];
        }
    }else{
        [mmkv setBool:NO forKey:@"bool"];
//        [WHC_GestureUnlockScreenVC removeGesturePassword];
    }
}

#pragma mark - app更新检测
- (void)upadateApp{
    NSString *url = [ChatTool shareChatTool].basicConfig.ios_update_check;
    url = [url stringByTrimmingCharactersInSet:
           [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //1.获取一个全局串行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    
    //2.把任务添加到队列中执行
    dispatch_async(queue, ^{
        
        //3.从网络上下载图片
        NSURL *urlstr = [NSURL URLWithString:url];
        NSData *data = [NSData dataWithContentsOfURL:urlstr];
        
        
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc]
                                               initWithData:[str dataUsingEncoding:
                                                             NSUnicodeStringEncoding]
                                               options:@{
                                                         NSDocumentTypeDocumentAttribute:
                                                             NSHTMLTextDocumentType
                                                         }
                                               documentAttributes:nil error:nil];
        
        
        
        NSDictionary * json = [NSString dictionaryWithJsonString:attrStr];
        if (!data) {
            return ;
        }
        
        NSLog(@"status = %@",json);
        NSLog(@"version=%@",json[@"version"]);
        //UIImage *image=[UIImage imageWithData:data];
        //提示
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            
            NSString *currentVer = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            
            NSString *lastVer = json[@"version"];
            
            lastVer = [lastVer stringByReplacingOccurrencesOfString:@"." withString:@""];
            currentVer = [currentVer stringByReplacingOccurrencesOfString:@"." withString:@""];
            
            if ([lastVer intValue] <= [currentVer intValue]) {
                [MBProgressHUD showPrompt:@"您已经是最新版本"];
            }else{
                [self appUpdateWith:json[@"url"] with:json[@"description"]];
            }
            
        });
        
        
    });
}

#pragma mark - app更新
- (void) appUpdateWith:(NSString *)url with:(NSString *)info
{
    self.appUrl = url;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:info message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        
        NSURL *url = [NSURL URLWithString:self.appUrl];
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
