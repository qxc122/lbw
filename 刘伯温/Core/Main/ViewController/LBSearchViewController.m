//
//  LBSearchViewController.m
//  Core
//
//  Created by mac on 2017/9/26.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LBSearchViewController.h"
#import "LBMainRootCell.h"
#import "LBRemendToolView.h"
#import "LBRechargerViewController.h"
#import "LiveBroadcastVc.h"

@interface LBSearchViewController ()<UITextFieldDelegate>
@property (nonatomic, strong)UITextField *textField;


@end

@implementation LBSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0,CGHeightMT(200) , 35)];
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.returnKeyType = UIReturnKeySearch;
    self.textField.delegate = self;
    self.textField.layer.cornerRadius = 15;
    self.textField.clipsToBounds = YES;
    self.navigationItem.titleView = self.textField;
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 35)];
    self.textField.leftView = leftView;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.tintColor= [UIColor lightGrayColor];

    
    UIButton *searchButton = [UIButton buttonWithType:0];
    searchButton.frame = CGRectMake(0, 0, 40, 40);
    [searchButton addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [searchButton setImage:[UIImage imageNamed:@"搜索"] forState:0];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.NodataTitle = @" ";
    self.empty_type = succes_empty_num;
    self.header.hidden = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textFiel{
    [self serachAnchor];
    return YES;
}

- (void)serachAnchor{
    [self.textField resignFirstResponder];
    if (!self.textField.text.length){
        [MBProgressHUD showMessage:@"搜索不能为空" view:self.view];
        return;
    }
    [MBProgressHUD showLoadingMessage:@"搜索中..." toView:self.view];
    WeakSelf
    [[ToolHelper shareToolHelper] serachAnchorWithkeyword:self.textField.text success:^(id json, NSString *msg, NSInteger code) {
        [weakSelf.arry removeAllObjects];
        LBAnchorListModelList *dataList = [LBAnchorListModelList mj_objectWithKeyValues:json];
        [weakSelf.arry addObjectsFromArray:dataList.data];
        if (weakSelf.arry.count) {
            weakSelf.NodataTitle = @"";
        } else {
            weakSelf.NodataTitle = @"暂无该主播";
        }
        [weakSelf ColoadNewDataEndHeadsuccessSet:nil code:[json[@"result"] intValue]  footerIsShow:NO hasMore:nil];
        [weakSelf.collectionView reloadData];
        [MBProgressHUD hideHUDForView:weakSelf.view];
    } failure:^(NSInteger errorCode, NSString *msg) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
        [weakSelf ColoadNewDataEndHeadfailureSet:nil errorCode:errorCode];
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textField resignFirstResponder];
}

- (void)searchButtonClick{
    [self serachAnchor];
}
@end
