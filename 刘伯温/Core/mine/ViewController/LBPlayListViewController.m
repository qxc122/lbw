//
//  LBPlayListViewController.m
//  Core
//
//  Created by mac on 2017/9/30.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LBPlayListViewController.h"
#import "LBMainRootCell.h"
#import <MJRefresh.h>
#import "LiveBroadcastVc.h"
#import "LBRemendToolView.h"
#import "LBRechargerViewController.h"
@interface LBPlayListViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property(nonatomic, strong)UICollectionView *myCollectionView;
@property(nonatomic, strong)NSMutableArray *anchorListArray;
@property(nonatomic, assign)int page;

@end

@implementation LBPlayListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.anchorListArray = [NSMutableArray array];
    
    [self setupView];
    
    [self getContentData]; // 获取主播列表
}

- (void)getContentData{
    self.page = 1;

    [self getAnchorList:YES];
    WeakSelf
    self.myCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [self getAnchorList:YES];
        [weakSelf.myCollectionView.mj_header endRefreshing];
    }];
    
    //    //上拉加载
    self.myCollectionView.mj_footer=[MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf getAnchorList:NO];
        [weakSelf.myCollectionView.mj_footer endRefreshing];
    }];
    
    
}



- (void)reloadButtonClick{
    [self getAnchorList:YES]; // 获取主播列表
}

- (void)setupView{
    UIButton *reloadButton = [UIButton buttonWithType:0];
    reloadButton.frame = CGRectMake(0, 0, 20, 20);
    [reloadButton setImage:[UIImage imageNamed:@"action_refresh"] forState:0];
    [reloadButton addTarget:self action:@selector(reloadButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:reloadButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    CGFloat leftPading = 10;
    
    CGFloat cellW = (kFullWidth-leftPading*2)/3;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(cellW, cellW+20);
    layout.minimumInteritemSpacing = leftPading;
    layout.minimumLineSpacing = leftPading;
    
    _myCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _myCollectionView.backgroundColor = [UIColor whiteColor];
    _myCollectionView.delegate = self;
    _myCollectionView.dataSource = self;
    _myCollectionView.showsVerticalScrollIndicator = NO;
    _myCollectionView.showsHorizontalScrollIndicator = NO;
    [_myCollectionView registerClass:[LBMainRootCell class] forCellWithReuseIdentifier:@"LBMainRootCell"];
    
    [self.view addSubview:_myCollectionView];
}

#pragma mark 获取主播列表
- (void)getAnchorList:(BOOL)isHead{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    WeakSelf
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"token"] = TOKEN;
    paramDict[@"row"] = @"20";
    paramDict[@"page"] = [NSString stringWithFormat:@"%d",self.page];
    paramDict[@"sign"] = [[LBToolModel sharedInstance]getSign:paramDict];
    [VBHttpsTool postWithURL:self.inerName params:paramDict success:^(id json) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if ([json[@"result"] intValue] == 1){
            if (isHead){
                [weakSelf.anchorListArray removeAllObjects];
            }
            LBAnchorListModelList *dataList = [LBAnchorListModelList mj_objectWithKeyValues:json];
            if (!dataList.data.count || dataList.data.count<20){
                self.myCollectionView.mj_footer.hidden = YES;
            }
            [weakSelf.anchorListArray addObjectsFromArray:dataList.data];
            [weakSelf.myCollectionView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.anchorListArray.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LBMainRootCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LBMainRootCell" forIndexPath:indexPath];
    cell.anchorModel = self.anchorListArray[indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    LBAnchorListModel *model = self.anchorListArray[indexPath.row];
//    LBPlayViewController *VC = [LBPlayViewController new];
//    VC.url = model.anchorLiveUrl;
//    VC.anchorID = model.anchorID;
//    VC.livePlatID = model.livePlatID;
//    VC.iconUrl = model.anchorThumb;
//    VC.nickname = model.anchorName;
//    [self.navigationController pushViewController:VC animated:YES];

    LBGetVerCodeModel *data =  [NSKeyedUnarchiver unarchiveObjectWithFile:PATH_base];
    if ([data.isFree intValue]){
//        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
//        dateFormatter.dateFormat=@"yyyy-MM-dd hh:mm:ss";
        NSString *expirationDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"expirationDate"];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *oneDate = [format dateFromString:expirationDate];
        NSString *type = [[NSUserDefaults standardUserDefaults] objectForKey:@"type"];

        WeakSelf
        if ([type isEqualToString:@"0"]){
            [LBRemendToolView showRemendViewText:[NSString stringWithFormat:@"您的会员已经到期，现在去充值吗"] andTitleText:@"刘伯温" andEnterText:@"确认" andCancelText:@"取消" andEnterBlock:^{
                LBRechargerViewController *VC = [[LBRechargerViewController alloc] initWithNibName:@"LBRechargerViewController" bundle:nil];
                [weakSelf.navigationController pushViewController:VC animated:YES];
            } andCancelBlock:^{
                
            }];
            return;
        }
    }
    LiveBroadcastVc *vc =[LiveBroadcastVc new];
    vc.anchorLiveUrl = model.anchorLiveUrl;
    
    vc.anchorID = model.anchorID;
    vc.livePlatID = model.livePlatID;
    vc.iconUrl = model.anchorThumb;
    vc.nickname = model.anchorName;
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay

{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    
    NSComparisonResult result = [dateA compare:dateB];
    
    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    
    if (result == NSOrderedDescending) {
        
        //NSLog(@"Date1  is in the future");
        
        return 1;
        
    }
    
    else if (result ==NSOrderedAscending){
        
        //NSLog(@"Date1 is in the past");
        
        return -1;
        
    }
    
    //NSLog(@"Both dates are the same");
    
    return 0;
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
