//
//  LBToolModel.h
//  Core
//
//  Created by mac on 2017/9/22.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBToolModel : NSObject
+(LBToolModel *)sharedInstance;
-(NSString *)getTimestamp;

-(NSString *)getSign:(NSMutableDictionary *)paramDict;
@end
