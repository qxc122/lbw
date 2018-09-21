//
//  zhuboVc.m
//  Core
//
//  Created by heiguohua on 2018/9/21.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "zhuboVc.h"
#import "LBMainRootCell.h"
#import "LBRemendToolView.h"

@interface zhuboVc ()
@property(nonatomic, strong)NSMutableArray *arry;
@end

@implementation zhuboVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arry = [NSMutableArray array];
    self.registerCoCells  =@[@"LBMainRootCell"];
    [self.header beginRefreshing];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(oneloadNewData)
                                                 name:@"one"
                                               object:nil];
}
-(void)oneloadNewData{
//    [MBProgressHUD showLoadingMessage:@"刷新中..." toView:self.view];
    [self.header beginRefreshing];
}
- (void)loadNewData{
    WeakSelf
    [[ToolHelper shareToolHelper] getReAnchorListSuccess:^(id json, NSString *msg, NSInteger code) {
        NSArray *arr = [NSArray modelArrayWithClass:[LBAnchorListModel class] json:json[@"data"]];
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
    cell.anchorModel = self.arry[indexPath.row];
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

    LBAnchorListModel *model = self.arry[indexPath.row];
    
    LBGetVerCodeModel *data =  [NSKeyedUnarchiver unarchiveObjectWithFile:PATH_base];
    if ([data.isFree intValue]){
        NSString *expirationDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"expirationDate"];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *oneData = [format dateFromString:expirationDate];
        NSString *type = [[NSUserDefaults standardUserDefaults] objectForKey:@"type"];

        if ([type isEqualToString:@"0"]){
            [self joinMembership];
            return;
        }else if([NSDate date].timeIntervalSince1970 >= oneData.timeIntervalSince1970){
            [self RenewalFee];
            return;
        }
    }
    NSLog(@"%@\n\n\n\n\n\nhhhhhhhhh",model.anchorLiveUrl);
    LiveBroadcastVc *vc =[LiveBroadcastVc new];
    vc.anchorLiveUrl = model.anchorLiveUrl;
    
    vc.anchorID = model.anchorID;
    vc.livePlatID = model.livePlatID;
    vc.iconUrl = model.anchorThumb;
    vc.nickname = model.anchorName;
    [self.navigationController pushViewController:vc animated:YES];

}
@end
