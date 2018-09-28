//
//  WithdrawalCell.h
//  Core
//
//  Created by heiguohua on 2018/9/11.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "baseCell.h"

@interface WithdrawalCell : baseCell
@property (nonatomic,strong) WithdrawalOne *one;
+ (instancetype)returnCellWith:(UITableView *)tableView;
@end
