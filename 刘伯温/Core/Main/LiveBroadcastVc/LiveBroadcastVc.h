//
//  LiveBroadcastVc.h
//  Core
//
//  Created by heiguohua on 2018/9/14.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "basicVc.h"

@interface LiveBroadcastVc : basicVc
@property (nonatomic,strong) NSString *anchorLiveUrl;
@property(nonatomic, strong)NSString *anchorID;

@property(nonatomic, strong)NSString *livePlatID;

@property(nonatomic, strong)NSString *iconUrl;
@property(nonatomic, strong)NSString *nickname;

@end
