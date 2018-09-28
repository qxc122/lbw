//
//  baseCell.h
//  portal
//
//  Created by Store on 2017/9/25.
//  Copyright © 2017年 qxc122@126.com. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface baseCell : UITableViewCell
@property (nonatomic, copy) void (^doneSomething)(id data);
@property (nonatomic,strong)id data;
+ (instancetype)returnCellWith:(UITableView *)tableView;
@end
