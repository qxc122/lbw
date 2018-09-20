//
//  LBGiftStoreCollectionViewCell.h
//  Core
//
//  Created by mac on 2017/11/11.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBGiftStoreCollectionViewCell : UICollectionViewCell
@property(nonatomic, strong)LBGetGoodsListModel *listModel;
@property (nonatomic, strong)void(^buyButtonBlock)();

@end
