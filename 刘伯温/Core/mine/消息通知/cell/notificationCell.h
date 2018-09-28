//
//  notificationCell.h
//  Core
//
//  Created by heiguohua on 2018/9/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface notificationCell : UITableViewCell
@property (nonatomic,strong) msgOne *one;
+ (instancetype)returnCellWith:(UITableView *)tableView;
@end
