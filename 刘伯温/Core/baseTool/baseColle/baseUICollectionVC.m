//
//  baseco.m
//  base
//
//  Created by 开发者最好的 on 2018/8/17.
//  Copyright © 2018年 开发者最好的. All rights reserved.
//

#import "baseUICollectionVC.h"
#import "UIScrollView+EmptyDataSet.h"
#import "NSString+Add.h"
#import "ToolHelper.h"
#import <CoreTelephony/CTCellularData.h>

@interface baseUICollectionVC ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic,weak) UICollectionView *collectionView;
@end


@implementation baseUICollectionVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}
- (void)setTableView{
    UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc]init];
    flowLayOut.scrollDirection = UICollectionViewScrollDirectionVertical;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayOut];
    self.collectionView = collectionView;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:collectionView];

    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    self.collectionView.mj_header = self.header;
    collectionView.emptyDataSetSource = self;
    collectionView.emptyDataSetDelegate = self;
}
- (void)setRegisterCoCells:(NSArray *)registerCoCells{
    _registerCoCells = registerCoCells;
    for (NSString *tmp in registerCoCells) {
        if([tmp hasSuffix:@"xib"] || [tmp hasSuffix:@"Xib"]){
            [self.collectionView registerNib:[UINib nibWithNibName:tmp bundle:nil] forCellWithReuseIdentifier:tmp];
        }else{
            [self.collectionView registerClass:NSClassFromString(tmp) forCellWithReuseIdentifier:tmp];
        }
    }
}

//#pragma mark----UICollectionViewDelegateFlowLayout
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(150,150);
//}

//#pragma mark--<点击了cell>
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//
//}
//
//
//#pragma mark----UICollectionViewDataSource
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//    return 10;
//}
//
//- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return nil;
//}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.0;
}
- (void)reload{
    [self.collectionView reloadData];
}
@end
