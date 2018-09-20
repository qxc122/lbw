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

@interface LBSearchViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong)UITextField *textField;
@property(nonatomic, strong)UICollectionView *myCollectionView;
@property(nonatomic, strong)NSMutableArray *anchorListArray;

@end

@implementation LBSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BackGroundColor;
    
    self.anchorListArray = [NSMutableArray array];

    
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

- (BOOL)textFieldShouldReturn:(UITextField *)textFiel{
    [self serachAnchor];
    return YES;
}

- (void)serachAnchor{
    [self.textField resignFirstResponder];
    if (!self.textField.text.length){
        [MBProgressHUD showMessage:@"搜索不能为空" finishBlock:nil];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    WeakSelf
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"keyword"] = self.textField.text;
    paramDict[@"sign"] = [[LBToolModel sharedInstance] getSign:paramDict];
    [VBHttpsTool postWithURL:@"serachAnchor" params:paramDict success:^(id json) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if ([json[@"result"] intValue] == 1){
            [weakSelf.anchorListArray removeAllObjects];
            LBAnchorListModelList *dataList = [LBAnchorListModelList mj_objectWithKeyValues:json];
            if (!dataList.data.count){
                [MBProgressHUD showMessage:@"暂无改主播" finishBlock:nil];
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


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textField resignFirstResponder];
}

- (void)searchButtonClick{
    [self serachAnchor];
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
