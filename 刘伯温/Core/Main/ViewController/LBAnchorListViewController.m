//
//  LBAnchorListViewController.m
//  Core
//
//  Created by mac on 2017/9/22.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LBAnchorListViewController.h"

#import "LBMainRootCell.h"
#import <MJRefresh.h>
#import "SDCycleScrollView.h"
#import "LSPaoMaView.h"
#import "LiveBroadcastVc.h"
#import "LBRemendToolView.h"
#import "LBRechargerViewController.h"
@interface LBAnchorListViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,SDCycleScrollViewDelegate>
@property(nonatomic, strong)UICollectionView *myCollectionView;
@property(nonatomic, strong)NSMutableArray *anchorListArray;
@property(nonatomic, assign)int page;
@property(nonatomic, strong)SDCycleScrollView *scrollView;

@end

@implementation LBAnchorListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.anchorListArray = [NSMutableArray array];

    [self setupView];

    [self getAnchorList]; // 获取主播列表
    [self.myCollectionView.mj_header beginRefreshing];
}

- (void)reloadButtonClick{
    [self getAnchorList]; // 获取主播列表
}


- (void)getAnchorList{
    self.page = 1;
    
    [self getAnchorList:YES];
    WeakSelf
    self.myCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf getAnchorList:YES];

    }];
    
    //    //上拉加载
    self.myCollectionView.mj_footer=[MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
         [weakSelf getAnchorList:NO];
    }];
    self.myCollectionView.mj_footer.hidden = YES;
    
}

- (void)setupView{
    UIButton *reloadButton = [UIButton buttonWithType:0];
    reloadButton.size = CGSizeMake(20, 20);
    [reloadButton setImage:[UIImage imageNamed:@"action_refresh"] forState:0];
    [reloadButton addTarget:self action:@selector(reloadButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:reloadButton];
    self.navigationItem.rightBarButtonItem = rightItem;

    SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kFullWidth, adjuctFloat(150)) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [self.view addSubview:(self.scrollView=cycleScrollView2)];
    NSMutableArray *advImageUrlArr = [NSMutableArray array];
    for (LBGetAdvListModel *model in _getAdvListArr) {
        if ([model.advImageUrl rangeOfString:@"http"].location ==NSNotFound){
            model.advImageUrl = [NSString stringWithFormat:@"%@%@",ImageHead,model.advImageUrl];
        }
        if([model.advType isEqualToString:@"1"]){
            [advImageUrlArr addObject:model.advImageUrl];
        }
    }
    self.scrollView.imageURLStringsGroup = advImageUrlArr;
    
    UIImageView *hornImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5+cycleScrollView2.bottom, 20, 20)];
    hornImageView.image = [UIImage imageNamed:@"喇叭"];
    [self.view addSubview:hornImageView];
    
    LBGetVerCodeModel *data =  [NSKeyedUnarchiver unarchiveObjectWithFile:PATH_base];
    LSPaoMaView *maView = [[LSPaoMaView alloc] initWithFrame:CGRectMake(30, hornImageView.top, kFullWidth-30, 20) title:data.msg];
    maView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:maView];
    
    CGFloat leftPading = 10;
    
    CGFloat cellW = (kFullWidth-leftPading*2)/3;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(cellW, cellW+20);
    layout.minimumInteritemSpacing = leftPading;
    layout.minimumLineSpacing = leftPading;
    
    _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, maView.bottom, kFullWidth, self.view.height-maView.bottom) collectionViewLayout:layout];
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

    WeakSelf
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"timestamp"] = [[LBToolModel sharedInstance] getTimestamp];
    paramDict[@"livePlatID"] = self.livePlatID;
    paramDict[@"sign"] = [[LBToolModel sharedInstance]getSign:paramDict];
    [VBHttpsTool postWithURL:@"getAnchorList" params:paramDict success:^(id json) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if ([json[@"result"] intValue] == 1){
            [weakSelf.anchorListArray removeAllObjects];
            NSArray *arr = [NSArray modelArrayWithClass:[LBAnchorListModel class] json:json[@"data"]];
            [weakSelf.anchorListArray addObjectsFromArray:arr];
            if (isHead) {
                [weakSelf.anchorListArray removeAllObjects];
                 [weakSelf.myCollectionView.mj_header endRefreshing];
            } else {
                [weakSelf.myCollectionView.mj_footer endRefreshing];
            }
            if (arr.count >= 40) {
                weakSelf.myCollectionView.mj_footer.hidden = NO;
            } else {
                weakSelf.myCollectionView.mj_footer.hidden = YES;
            }
            [weakSelf.anchorListArray addObjectsFromArray:arr];
            [weakSelf.myCollectionView reloadData];
        }
    } failure:^(NSError *error) {
        if (!weakSelf.anchorListArray.count) {
            [MBProgressHUD showMessage:@"请重试" view:weakSelf.view];
             [weakSelf.myCollectionView.mj_header endRefreshing];
        }
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


- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    LBGetAdvListModel *model = _getAdvListArr[index];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:model.linkUrl]];
    
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
