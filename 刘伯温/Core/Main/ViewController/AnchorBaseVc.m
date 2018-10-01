//
//  AnchorBaseVc.m
//  Core
//
//  Created by heiguohua on 2018/9/22.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "AnchorBaseVc.h"
#import "LBMainRootCell.h"


@interface AnchorBaseVc ()

@end

@implementation AnchorBaseVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arry = [NSMutableArray array];
    self.registerCoCells  =@[@"LBMainRootCell"];
    
    UIButton *reloadButton = [UIButton buttonWithType:0];
    reloadButton.size = CGSizeMake(20, 20);
    [reloadButton setImage:[UIImage imageNamed:@"action_refresh"] forState:0];
    [reloadButton addTarget:self action:@selector(reloadButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:reloadButton];
    self.navigationItem.rightBarButtonItem = leftItem;
}
- (void)reloadButtonClick{
    [self.header beginRefreshing];
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
    CGFloat cellW = (kFullWidth-10*2)/2;
    return CGSizeMake(cellW,cellW+20);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10.0;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (!ISLOGIN){
        [self login];
        return;
    }
    if ([[ChatTool shareChatTool].basicConfig.live_of isEqualToString:@"1"]) {
        [MBProgressHUD showPrompt:@"直播暂时关闭"];
    } else {
        
        LBAnchorListModel *model = self.arry[indexPath.row];
        if ([[ChatTool shareChatTool].basicConfig.isFree intValue]){
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
        
        NSLog(@"model.anchorLiveUrl=%@",model.anchorLiveUrl);
        vc.anchorID = model.anchorID;
        vc.livePlatID = model.livePlatID;
        vc.iconUrl = model.anchorThumb;
        vc.nickname = model.anchorName;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
