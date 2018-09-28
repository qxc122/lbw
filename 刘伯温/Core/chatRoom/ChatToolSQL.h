//
//  ChatToolSQL.h
//  Core
//
//  Created by heiguohua on 2018/9/26.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ChatToolSQLOK)(id msg);

NS_ASSUME_NONNULL_BEGIN


@interface ChatToolSQL : NSObject
singleH(ChatToolSQL);
- (void)insertDataFormArry:(NSArray *)arry;


- (void)countDatasuccess:(ChatToolSQLOK)successBlock;
- (void)selectForId:(NSInteger)index success:(ChatToolSQLOK)successBlock;
@end

NS_ASSUME_NONNULL_END
