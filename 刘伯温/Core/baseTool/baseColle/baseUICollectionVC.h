//
//  baseco.h
//  base
//
//  Created by 开发者最好的 on 2018/8/17.
//  Copyright © 2018年 开发者最好的. All rights reserved.
//

#import "baseUiTableView.h"

@interface baseUICollectionVC : baseUiTableView
@property (nonatomic,strong) NSArray  *registerCoCells; //需要注册的cell
@property (nonatomic,weak) UICollectionView *collectionView;

- (void)ColoadNewDataEndHeadsuccessSet:(UICollectionView *)TableView code:(NSInteger)code footerIsShow:(BOOL)footerIsShow  hasMore:(NSString *)hasMore;
- (void)ColoadNewDataEndHeadfailureSet:(UICollectionView *)TableView errorCode:(NSInteger)errorCode;

- (void)ColoadMoreDataEndFootsuccessSet:(UICollectionView *)TableView  hasMore:(NSString *)hasMore;
- (void)ColoadMoreDataEndFootfailureSet:(UICollectionView *)TableView errorCode:(NSInteger)errorCode msg:(NSString *)msg;
@end
