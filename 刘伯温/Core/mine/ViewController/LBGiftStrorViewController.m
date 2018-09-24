//
//  LBGiftStrorViewController.m
//  Core
//
//  Created by mac on 2017/11/11.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LBGiftStrorViewController.h"
#import "LBGiftStoreCollectionViewCell.h"
#import <MJRefresh.h>
#import "LBRemendToolView.h"
#import "LBShowRemendView.h"
#import "LBExchangeRecordViewController.h"
#import "LBEnditUserViewController.h"

@interface LBGiftStrorViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property(nonatomic, strong)UICollectionView *myCollectionView;
@property(nonatomic, strong)NSMutableArray *contentArr;
@property(nonatomic, assign)int page;

@end

@implementation LBGiftStrorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"礼品商城";
    
    self.view.backgroundColor = BackGroundColor;
    self.contentArr = [NSMutableArray array];
    [self setupView];
    
    [self getContentData];

}

- (void)setupView{
    UIButton *listButton = [UIButton buttonWithType:0];
    listButton.size = CGSizeMake(40, 20);
    [listButton setTitle:@"兑换记录" forState:0];
    listButton.titleLabel.font = CustomUIFont(14);
    [listButton addTarget:self action:@selector(listButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:listButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kFullWidth, 100)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    
    UIButton *goldButton = [UIButton buttonWithType:0];
    [goldButton setImage:[UIImage imageNamed:@""] forState:0];
    [goldButton setTitle:[NSString stringWithFormat:@"我的金币：%@",Integral] forState:0];
    [goldButton setTitleColor:MainColor forState:0];
    goldButton.titleLabel.font = CustomUIFont(16);
    [topView addSubview:goldButton];
    goldButton.frame = CGRectMake(40, (topView.height-20)/2, 120, 20);
    
    UILabel *lineLabel = [UILabel new];
    lineLabel.backgroundColor = BackGroundColor;
    [topView addSubview:lineLabel];
    lineLabel.frame = CGRectMake(topView.width/3*2, 0, 0.7, topView.height);
    
    UIButton *signButton = [UIButton buttonWithType:0];
    signButton.frame = CGRectMake(lineLabel.left+10, 20, kFullWidth/3-20, 35);
    [signButton setTitle:@"签到" forState:0];
    [signButton setTitleColor:[UIColor whiteColor] forState:0];
    signButton.titleLabel.font = CustomUIFont(14);
    [signButton addTarget:self action:@selector(signButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:signButton];
    signButton.backgroundColor = CustomColor(239, 72, 76, 1);
    signButton.layer.cornerRadius = 4;
    signButton.clipsToBounds = YES;
    
    UILabel *descLabel = [UILabel new];
    descLabel.text = @"签到送金币";
    descLabel.font = CustomUIFont(13);
    descLabel.textColor = MainColor;
    [topView  addSubview:descLabel];
    descLabel.frame = signButton.frame;
    descLabel.top = signButton.bottom +10;
    descLabel.textAlignment = 1;
    
    
    CGFloat leftPading = 10;
    
    CGFloat cellW = (kFullWidth-leftPading*2)/2;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(cellW, cellW+50);
    layout.minimumInteritemSpacing = leftPading;
    layout.minimumLineSpacing = leftPading;
    _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, topView.bottom, kFullWidth, kFullHeight-topView.bottom) collectionViewLayout:layout];
    _myCollectionView.backgroundColor = [UIColor whiteColor];
    _myCollectionView.delegate = self;
    _myCollectionView.dataSource = self;
    _myCollectionView.showsVerticalScrollIndicator = NO;
    _myCollectionView.showsHorizontalScrollIndicator = NO;
    [_myCollectionView registerClass:[LBGiftStoreCollectionViewCell class] forCellWithReuseIdentifier:@"LBGiftStoreCollectionViewCell"];
    [self.view addSubview:_myCollectionView];
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.contentArr.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LBGiftStoreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LBGiftStoreCollectionViewCell" forIndexPath:indexPath];
    LBGetGoodsListModel *model = self.contentArr[indexPath.row];
    if (model){
        cell.listModel = model;
    }
    WeakSelf
    cell.buyButtonBlock = ^{
        [weakSelf buyGoods:model.goodsID andGoldNum:model.goodsInventory];
    };
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

- (void)buyGoods:(NSString *)goodsID andGoldNum:(NSString *)goldStr{
    WeakSelf
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hasFullInfo"]){
        [LBRemendToolView showRemendViewText:@"请先完善邮寄地址、手机号、真实姓名相关信息，现在去完善吗" andTitleText:@"刘伯温" andEnterText:@"确认" andCancelText:@"取消" andEnterBlock:^{
            LBEnditUserViewController *VC = [LBEnditUserViewController new];
            [weakSelf.navigationController pushViewController:VC animated:YES];
        } andCancelBlock:^{
            
        }];
        return;
    }
    
    [LBRemendToolView showRemendViewText:[NSString stringWithFormat:@"该商品需要%@个金币，确认兑换吗？",goldStr] andTitleText:@"刘伯温" andEnterText:@"确认兑换" andCancelText:@"取消兑换" andEnterBlock:^{
        [weakSelf postBuyGoods:goodsID andGoldNum:goldStr];
    } andCancelBlock:^{
        
    }];
    
    
    
}

-(void)postBuyGoods:(NSString *)goodsID andGoldNum:(NSString *)goldStr{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"timestamp"] = [[LBToolModel sharedInstance] getTimestamp];
    paramDict[@"token"] = TOKEN;
    paramDict[@"goodsID"] = goodsID;
    paramDict[@"count"] = @"1";
    paramDict[@"sign"] = [[LBToolModel sharedInstance]getSign:paramDict];
    WeakSelf
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [VBHttpsTool postWithURL:@"buyGoods" params:paramDict success:^(id json) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showMessage:json[@"info"] finishBlock:nil];
        if ([json[@"result"] intValue] ==1){
            dispatch_async(dispatch_get_main_queue(), ^{
                [LBShowRemendView showRemendViewText:[NSString stringWithFormat:@"兑换成功，我们将安排发货到下面的地址:%@",DeliveryAddress] andTitleText:@"恭喜你" andEnterText:@"确定" andEnterBlock:^{
                }];
                
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",[Integral intValue]-[goldStr intValue]] forKey:@"integral"];
            });
        }
        [MBProgressHUD showMessage:json[@"info"] finishBlock:nil];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
}

- (void)getGoodsList:(BOOL)isHead{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    WeakSelf
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"token"] = TOKEN;
    paramDict[@"row"] = @"20";
    paramDict[@"page"] = [NSString stringWithFormat:@"%d",self.page];
    paramDict[@"timestamp"] = [[LBToolModel sharedInstance]getTimestamp];
    paramDict[@"categoryID"] = @"-1";
    paramDict[@"sortType"] = @"2";
    paramDict[@"sign"] = [[LBToolModel sharedInstance]getSign:paramDict];
    [VBHttpsTool postWithURL:@"getGoodsList" params:paramDict success:^(id json) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if ([json[@"result"] intValue] == 1){
            if (isHead){
                [weakSelf.contentArr removeAllObjects];
            }
            NSArray *arr = [NSArray modelArrayWithClass:[LBGetGoodsListModel class] json:json[@"data"]];
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

- (void)signButtonClick{
    [self basicVcsignButtonClick];
}

- (void)listButtonClick{
    LBExchangeRecordViewController *VC = [LBExchangeRecordViewController new];
    [self.navigationController pushViewController:VC animated:YES];
}

@end
