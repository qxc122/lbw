//
//  ChatToolSQL.m
//  Core
//
//  Created by heiguohua on 2018/9/26.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ChatToolSQL.h"
#import "FMDB.h"
@interface ChatToolSQL ()
@property(strong, nonatomic) FMDatabaseQueue *queue;
@end


@implementation ChatToolSQL
singleM(ChatToolSQL);

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 0.获取沙盒地址
        NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        // 拼接路径
        NSString * filePath = [path stringByAppendingPathComponent:@"JIM.sqlite"];
        

        // 1.创建一个FMDatabaseQueue对象
        // 只要创建数据库队列对象, FMDB内部就会自动给我们加载数据库对象
        self.queue = [FMDatabaseQueue databaseQueueWithPath:filePath];
        
        //2 .执行操作
        // 会通过block传递队列中创建好的数据库给我们
        [self.queue inDatabase:^(FMDatabase *db) {
            // 编写需要执行的代码
            BOOL success = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_IM (id INTEGER PRIMARY KEY AUTOINCREMENT, content TEXT NOT NULL);"];
            if (success) {
                NSLog(@"创建表成功");
                [self DeleteAll];
            }else
            {
                NSLog(@"创建表失败");
            }
        }];
    }
    return self;
}

- (void)DeleteAll{
    [self.queue inDatabase:^(FMDatabase *db) {
        BOOL success = [db executeUpdate:@"delete from t_IM"];
        if (success) {
            NSLog(@"删除成功");
        }else{
            NSLog(@"删除失败");
        }
    }];
}

- (void)insertDataFormArry:(NSArray *)arry{
    [self.queue inDatabase:^(FMDatabase *db) {
        for (JMSGMessage *content in arry) {
            BOOL success = [db executeUpdate:@"insert into t_IM(content) values(?);",content.toJsonString];
            if (success) {
                NSLog(@"插入成功");
            }else{
                NSLog(@"插入失败");
            }
        }
    }];
}


- (void)countDatasuccess:(ChatToolSQLOK)successBlock{
    [self.queue inDatabase:^(FMDatabase *db) {
        // 先查询表中行数的总个数
        NSUInteger count = [db intForQuery:@"select count(*) from t_IM"];
        successBlock([NSNumber numberWithInteger:count]);
    }];
}


- (void)selectForId:(NSInteger)index success:(ChatToolSQLOK)successBlock{
    [self.queue inDatabase:^(FMDatabase *db) {
        // FMResultSet结果集, 结果集其实和tablevivew很像
        FMResultSet *set = [db executeQuery:@"SELECT * FROM t_IM where id=(?);",index];
        while ([set next]) { // next方法返回yes代表有数据可取
            int ID = [set intForColumnIndex:0];
            NSString *content = [set stringForColumn:@"content"]; // 根据字段名称取出对应的值
            NSLog(@"%d %@", ID, content);
            successBlock([JMSGMessage fromJson:content]);
        }
    }];
}

@end
