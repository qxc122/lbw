//
//  ChatRecordCell.h
//  Core
//
//  Created by heiguohua on 2018/9/12.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "baseCell.h"
#import "JCHATChatModel.h"

@interface ChatRecordCell : baseCell
@property (nonatomic,strong) chatRecodOne *one;
@property (nonatomic,strong) JCHATChatModel *model;




@property (nonatomic,strong) id oneMsg;

+ (instancetype)returnCellWith:(UITableView *)tableView;
@end
