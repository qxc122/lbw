//
//  PlatformListVc.m
//  Core
//
//  Created by heiguohua on 2018/9/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "PlatformListVc.h"
#import "LBMainRootCell.h"
@interface PlatformListVc ()

@end

@implementation PlatformListVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.header beginRefreshing];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(twoloadNewData)
                                                 name:@"two"
                                               object:nil];
}
-(void)twoloadNewData{
    [self.header beginRefreshing];
}
- (void)loadNewData{
    WeakSelf
    [[ToolHelper shareToolHelper] getLivePlatListSuccess:^(id json, NSString *msg, NSInteger code) {
        NSArray *arr = [NSArray modelArrayWithClass:[LBGetLivePlatModel class] json:json[@"data"]];
        [weakSelf.arry removeAllObjects];
        [weakSelf.arry addObjectsFromArray:arr];
        [weakSelf ColoadNewDataEndHeadsuccessSet:nil code:[json[@"result"] intValue]  footerIsShow:NO hasMore:nil];
    } failure:^(NSInteger errorCode, NSString *msg) {
        [weakSelf ColoadNewDataEndHeadfailureSet:nil errorCode:errorCode];
    }];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LBMainRootCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LBMainRootCell" forIndexPath:indexPath];
    cell.liveModel = self.arry[indexPath.row];
    return cell;
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
