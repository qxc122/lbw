//
//  LBExchangeRecordViewController.m
//  Core
//
//  Created by mac on 2017/11/12.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LBExchangeRecordViewController.h"
#import <MJRefresh.h>
#import "LBGiftStoreCollectionViewCell.h"
#import "LBExchangeCollectionViewCell.h"

@interface LBExchangeRecordViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property(nonatomic, strong)UICollectionView *myCollectionView;
@property(nonatomic, strong)NSMutableArray *contentArr;
@property(nonatomic, assign)int page;

@end

@implementation LBExchangeRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"兑换历史记录";
    
    self.view.backgroundColor = BackGroundColor;
    self.contentArr = [NSMutableArray array];
    [self setupView];
    
    [self getContentData];
}

- (void)setupView{
    CGFloat leftPading = 10;
    
    CGFloat cellW = (kFullWidth-leftPading*2)/2;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(cellW, cellW+80);
    layout.minimumInteritemSpacing = leftPading;
    layout.minimumLineSpacing = leftPading;
    _myCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _myCollectionView.backgroundColor = [UIColor whiteColor];
    _myCollectionView.delegate = self;
    _myCollectionView.dataSource = self;
    _myCollectionView.showsVerticalScrollIndicator = NO;
    _myCollectionView.showsHorizontalScrollIndicator = NO;
    [_myCollectionView registerClass:[LBExchangeCollectionViewCell class] forCellWithReuseIdentifier:@"LBExchangeCollectionViewCell"];
    [self.view addSubview:_myCollectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.contentArr.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LBExchangeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LBExchangeCollectionViewCell" forIndexPath:indexPath];
    LBExchangeModel *model = self.contentArr[indexPath.row];
    if (model){
        cell.model = model;
    }
    
    return cell;
}

- (void)getContentData{
    self.page = 1;
    
    [self getGoodsList:YES];
    WeakSelf
    self.myCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [self getGoodsList:YES];
        [weakSelf.myCollectionView.mj_header endRefreshing];
    }];
    
    //    //上拉加载
    self.myCollectionView.mj_footer=[MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf getGoodsList:NO];
        [weakSelf.myCollectionView.mj_footer endRefreshing];
    }];
    
    
}

- (void)getGoodsList:(BOOL)isHead{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    WeakSelf
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"token"] = TOKEN;
    paramDict[@"timestamp"] = [[LBToolModel sharedInstance]getTimestamp];
    paramDict[@"sign"] = [[LBToolModel sharedInstance]getSign:paramDict];
    [VBHttpsTool postWithURL:@"getMyBuyGoodsList" params:paramDict success:^(id json) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if ([json[@"result"] intValue] == 1){
            if (isHead){
                [weakSelf.contentArr removeAllObjects];
            }
            NSArray *arr = [NSArray modelArrayWithClass:[LBExchangeModel class] json:json[@"data"]];
            if (!arr.count || arr.count<20){
                self.myCollectionView.mj_footer.hidden = YES;
            }
            [weakSelf.contentArr addObjectsFromArray:arr];
            [weakSelf.myCollectionView reloadData];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
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
