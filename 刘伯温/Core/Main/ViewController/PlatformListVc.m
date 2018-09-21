//
//  PlatformListVc.m
//  Core
//
//  Created by heiguohua on 2018/9/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "PlatformListVc.h"
#import "LBMainRootCell.h"
#import "LBRemendToolView.h"
#import "LBRechargerViewController.h"
@interface PlatformListVc ()
@property(nonatomic, strong)NSMutableArray *arry;
@end

@implementation PlatformListVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arry = [NSMutableArray array];
    self.registerCoCells  =@[@"LBMainRootCell"];
    [self.header beginRefreshing];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(twoloadNewData)
                                                 name:@"two"
                                               object:nil];
}
-(void)twoloadNewData{
//    [MBProgressHUD showLoadingMessage:@"刷新中..." toView:self.view];
    [self.header beginRefreshing];
}
- (void)loadNewData{
    WeakSelf
    [[ToolHelper shareToolHelper] getLivePlatListSuccess:^(id json, NSString *msg, NSInteger code) {
        NSArray *arr = [NSArray modelArrayWithClass:[LBGetLivePlatModel class] json:json[@"data"]];
        [weakSelf.arry removeAllObjects];
        [weakSelf.arry addObjectsFromArray:arr];
        [weakSelf ColoadNewDataEndHeadsuccessSet:nil code:[json[@"result"] intValue]  footerIsShow:NO hasMore:nil];
//        [MBProgressHUD hideHUDForView:weakSelf.view];
    } failure:^(NSInteger errorCode, NSString *msg) {
        [weakSelf ColoadNewDataEndHeadfailureSet:nil errorCode:errorCode];
//        [MBProgressHUD hideHUDForView:weakSelf.view];
    }];
}

#pragma mark----UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arry.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LBMainRootCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LBMainRootCell" forIndexPath:indexPath];
    cell.liveModel = self.arry[indexPath.row];
    return cell;
}

#pragma mark----UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellW = (kFullWidth-10*2)/3;
    return CGSizeMake(cellW,cellW+20);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10.0;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (!ISLOGIN){
        [self login];
        return;
    }
    LBGetLivePlatModel *model = self.arry[indexPath.row];
    LBAnchorListViewController *VC = [LBAnchorListViewController new];
    VC.title = model.livePlatTitle;
    VC.livePlatID = model.livePlatID;
    [self.navigationController pushViewController:VC animated:YES];
}
@end
