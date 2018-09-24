//
//  NetworkStateTool.m
//  base
//
//  Created by 开发者最好的 on 2018/8/15.
//  Copyright © 2018年 开发者最好的. All rights reserved.
//

#import "ToolHelper.h"
#import "Header.h"
#import "HeaderBase.h"
#import "AFNetworking.h"
#import "NSDictionary+Add.h"
#import "LBToolModel.h"

#define REAUESRTIMEOUT      60    //网络请求超时时间

#define PROMPT_FAIL          @"加载失败,请重试～"
#define PROMPT_NOTCONNECT   @"网络连接异常,请检查手机网络~"
#define PROMPT_NOTJSON      @"服务器返回数据有误"



@interface ToolHelper ()
@property (strong, nonatomic) Reachability *reachability;
//公共请求参数
//@property (strong, nonatomic) NSString *accessToken;
//。。。。。可以按需求添加
@end


@implementation ToolHelper
//- (void)addArry:(NSArray *)arry{
//    if (arry) {
//        [self.list addObjectsFromArray:arry];
//    }
//    if (self.list.count>50) {
//        self.list = [[self.list subarrayWithRange:NSMakeRange(self.list.count-50, 50)] mutableCopy];
//    }
//    NSLog(@"%ld",self.list.count);
//}
- (instancetype)init
{
    self = [super init];
    if (self) {
#ifdef DEBUG
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(networkStateChange) name:kReachabilityChangedNotification object:nil];
#endif
        self.reachability = [Reachability reachabilityForInternetConnection];
        [self.reachability startNotifier];
//        self.list = [NSMutableArray array];
    }
    return self;
}

singleM(ToolHelper);

- (void)postJsonWithPath:(NSString *)path
              parameters:(NSMutableDictionary *)parameters
                 success:(RequestSuccess)successBlock
                 failure:(RequestFailure)failureBlock
{
    if (![self.reachability isReachable]) {
        failureBlock(KRespondCodeNotConnect, PROMPT_NOTCONNECT);
    } else {
        NSMutableDictionary *muDic = parameters;
        if (!muDic) {
            muDic = [NSMutableDictionary new];
        }
        
        //TODO
//        if (!self.accessToken) {
//
//        } else {
//
//        }
//        [muDic setObject:@"accessToken" forKey:self.accessToken];  //添加公共参数 按需添加
        //......
        NSString *urlStr = [NSString stringWithFormat:@"%@%@", URLBASIC, path];

        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];

        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 15.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.cachePolicy =  NSURLRequestReloadIgnoringCacheData;

        kWeakSelf(self);
        [manager POST:urlStr parameters:[NSMutableDictionary dictionaryWithDictionary:muDic] progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (responseObject) {
                id result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:NULL];
                [weakself parseResponseData:result success:successBlock failure:failureBlock];
            }else{
                failureBlock(KRespondCodeNone, @"服务器返回数据为空");
            }
#ifdef DEBUG
            NSLog(@"-------Start--------");
            NSLog(@"请求成功：参数=%@  path=%@",[muDic DicToJsonstr],urlStr);
            NSLog(@"-------End--------");
#endif
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
#ifdef DEBUG
            NSLog(@"-------Start--------");
            NSLog(@"请求失败：参数=%@ \n 路径=%@ \n 错误信息=%@\n",[muDic DicToJsonstr],urlStr,[error description]);
            NSLog(@"-------End--------");
#endif
            NSDictionary *tmp = error.userInfo;
            NSString *tmpStr = tmp[@"NSLocalizedDescription"];
            failureBlock(KRespondCodeFail, tmpStr);
        }];
        AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
        [securityPolicy setAllowInvalidCertificates:YES];
        [manager setSecurityPolicy:securityPolicy];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
    }
}

//验证返回数据是否正确
- (void)parseResponseData:(id)responseData
                  success:(RequestSuccess)successBlock
                  failure:(RequestFailure)failureBlock{
    NSDictionary *jsonRootObject = (NSDictionary *)responseData;
    if (jsonRootObject == nil) {
        failureBlock(kRespondCodeNotJson, PROMPT_NOTJSON);
    }else {
        NSNumber * code = [jsonRootObject valueForKeyPath:@"result"];
        NSString *msg = [jsonRootObject valueForKeyPath:@"info"];
        id data = [jsonRootObject objectForKey:@"data"];
        if ([code integerValue] == kRespondCodeSuccess) {
            successBlock(data, msg, [code integerValue]);
        }else if ([code integerValue] == KRespondCodeFail) {
            failureBlock([code integerValue], msg);
        }else {
            failureBlock([code integerValue], msg);
        }
    }
}


- (void)CP_getMyMsgWithlastId:(NSNumber *)lastId
                     success:(RequestSuccess)successBlock
                           failure:(RequestFailure)failureBlock{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    if (lastId) {
        params[@"last_id"] = lastId ;
    }
    params[@"token"] = TOKEN;
    params[@"sign"] = [[LBToolModel sharedInstance] getSign:params];
    params[@"last_id"] = @"0";
    [self postJsonWithPath:url_getMyMsg parameters:params success:successBlock failure:failureBlock];
}


- (void)CP_url_buyCardWithvipType:(NSNumber *)vipType
                      success:(RequestSuccess)successBlock
                      failure:(RequestFailure)failureBlock{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    if (vipType) {
        params[@"vipType"] = vipType ;
    }
    params[@"token"] = TOKEN;
    params[@"sign"] = [[LBToolModel sharedInstance] getSign:params];

    [self postJsonWithPath:url_buyCard parameters:params success:successBlock failure:failureBlock];
}

- (void)CP_url_loginWithaccount:(NSString *)account
                        password:(NSString *)password
                        clientType:(NSString *)clientType
                        version:(NSString *)version
                        sign:(NSString *)sign
                          success:(RequestSuccess)successBlock
                          failure:(RequestFailure)failureBlock{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    

    params[@"account"] = account ;
    params[@"clientType"] = clientType ;
    params[@"password"] = password ;
    params[@"version"] = version ;
    params[@"sign"] = [[LBToolModel sharedInstance] getSign:params];
    
    [self postJsonWithPath:url_login parameters:params success:successBlock failure:failureBlock];
}


-(BOOL)isReachable{
    return self.reachability.isReachable;
}

- (void)getUserInfosuccess:(RequestSuccess)successBlock
                   failure:(RequestFailure)failureBlock{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"timestamp"] = [[LBToolModel sharedInstance] getTimestamp];
    paramDict[@"token"] = TOKEN;
    paramDict[@"sign"] = [[LBToolModel sharedInstance] getSign:paramDict];
    [VBHttpsTool postWithURL:@"getMyInfo" params:paramDict success:^(id json) {
        if ([json[@"result"] intValue] ==1){
            successBlock(json,json[@"info"],[json[@"result"] intValue]);
        }else{
            failureBlock([json[@"result"] intValue],json[@"info"]);
        }
    } failure:^(NSError *error) {
        failureBlock(error.code,error.userInfo.description);
    }];
}


- (void)bindBankWithbank_type:(NSString *)bank_type
                   cardNumber:(NSString *)cardNumber
                     trueName:(NSString *)trueName
                        phone:(NSString *)phone
                        vcode:(NSString *)vcode
                      success:(RequestSuccess)successBlock
                   failure:(RequestFailure)failureBlock{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"token"] = TOKEN;
    paramDict[@"bank_type"] = bank_type;
    paramDict[@"cardNumber"] = cardNumber;
    paramDict[@"trueName"] = trueName;
    paramDict[@"phone"] = phone;
    paramDict[@"vcode"] = vcode;
    paramDict[@"sign"] = [[LBToolModel sharedInstance] getSign:paramDict];
    [VBHttpsTool postWithURL:@"bindBank" params:paramDict success:^(id json) {
        if ([json[@"result"] intValue] ==1){
            successBlock(json,json[@"info"],[json[@"result"] intValue]);
        }else{
            failureBlock([json[@"result"] intValue],json[@"info"]);
        }
    } failure:^(NSError *error) {
        failureBlock(error.code,error.userInfo.description);
    }];
}


- (void)submitCashWithbank_type:(NSString *)bank_type
                   cardNumber:(NSString *)cardNumber
                     trueName:(NSString *)trueName
                        phone:(NSString *)phone
                        amount:(NSString *)amount
                      success:(RequestSuccess)successBlock
                      failure:(RequestFailure)failureBlock{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"bankType"] = bank_type;
    paramDict[@"token"] = TOKEN;
    paramDict[@"cardNumber"] = cardNumber;
    paramDict[@"trueName"] = trueName;
    paramDict[@"amount"] = amount;
    paramDict[@"sign"] = [[LBToolModel sharedInstance] getSign:paramDict];
    [VBHttpsTool postWithURL:@"submitCash" params:paramDict success:^(id json) {
        if ([json[@"result"] intValue] ==1){
            successBlock(json,json[@"info"],[json[@"result"] intValue]);
        }else{
            failureBlock([json[@"result"] intValue],json[@"info"]);
        }
    } failure:^(NSError *error) {
        failureBlock(error.code,error.userInfo.description);
    }];
}


- (void)getVerCodeWithphone:(NSString *)phone
                   type:(NSNumber *)type
                      success:(RequestSuccess)successBlock
                      failure:(RequestFailure)failureBlock{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"phone"] = phone;
    paramDict[@"type"] = type;
    paramDict[@"sign"] = [[LBToolModel sharedInstance] getSign:paramDict];
    [VBHttpsTool postWithURL:@"getVerCode" params:paramDict success:^(id json) {
        if ([json[@"result"] intValue] ==1){
            successBlock(json,json[@"info"],[json[@"result"] intValue]);
        }else{
            failureBlock([json[@"result"] intValue],json[@"info"]);
        }
    } failure:^(NSError *error) {
        failureBlock(error.code,error.userInfo.description);
    }];
}

- (void)myBankCardListsuccess:(RequestSuccess)successBlock
                    failure:(RequestFailure)failureBlock{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"token"] = TOKEN;
    paramDict[@"sign"] = [[LBToolModel sharedInstance] getSign:paramDict];
    [VBHttpsTool postWithURL:@"myBankCardList" params:paramDict success:^(id json) {
        if ([json[@"result"] intValue] ==1){
            successBlock(json,json[@"info"],[json[@"result"] intValue]);
        }else{
            failureBlock([json[@"result"] intValue],json[@"info"]);
        }
    } failure:^(NSError *error) {
        failureBlock(error.code,error.userInfo.description);
    }];
}

- (void)submitCashLogWithpage:(NSNumber *)page
                          row:(NSNumber *)row
                      success:(RequestSuccess)successBlock
                      failure:(RequestFailure)failureBlock{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"page"] = page;
    paramDict[@"row"] = row;;
    paramDict[@"token"] = TOKEN;
    paramDict[@"sign"] = [[LBToolModel sharedInstance] getSign:paramDict];
    [VBHttpsTool postWithURL:@"submitCashLog" params:paramDict success:^(id json) {
        if ([json[@"result"] intValue] ==1){
            successBlock(json,json[@"info"],[json[@"result"] intValue]);
        }else{
            failureBlock([json[@"result"] intValue],json[@"info"]);
        }
    } failure:^(NSError *error) {
        failureBlock(error.code,error.userInfo.description);
    }];
}

- (void)complaintsanchorID:(NSString *)anchorID
                    type:(NSNumber *)type
                    memo:(NSString *)memo
                    success:(RequestSuccess)successBlock
                    failure:(RequestFailure)failureBlock{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"anchorID"] = anchorID;
    paramDict[@"type"] = type;
    paramDict[@"memo"] = memo;
    paramDict[@"token"] = TOKEN;
    paramDict[@"sign"] = [[LBToolModel sharedInstance] getSign:paramDict];
    [VBHttpsTool postWithURL:@"complaints" params:paramDict success:^(id json) {
        if ([json[@"result"] intValue] ==1){
            successBlock(json,json[@"info"],[json[@"result"] intValue]);
        }else{
            failureBlock([json[@"result"] intValue],json[@"info"]);
        }
    } failure:^(NSError *error) {
        failureBlock(error.code,error.userInfo.description);
    }];
}

- (void)getSimpleChatRoomRecanchor_id:(NSString *)anchor_id
                   success:(RequestSuccess)successBlock
                   failure:(RequestFailure)failureBlock{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"anchor_id"] = anchor_id;
    paramDict[@"token"] = TOKEN;
    paramDict[@"sign"] = [[LBToolModel sharedInstance] getSign:paramDict];
    [VBHttpsTool postWithURL:@"getSimpleChatRoomRec" params:paramDict success:^(id json) {
        if ([json[@"result"] intValue] ==1){
            successBlock(json,json[@"info"],[json[@"result"] intValue]);
        }else{
            failureBlock([json[@"result"] intValue],json[@"info"]);
        }
    } failure:^(NSError *error) {
        failureBlock(error.code,error.userInfo.description);
    }];
}


- (void)getReAnchorListSuccess:(RequestSuccess)successBlock
                              failure:(RequestFailure)failureBlock{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"timestamp"] = [[LBToolModel sharedInstance] getTimestamp];
    paramDict[@"sign"] = [[LBToolModel sharedInstance]getSign:paramDict];
    [VBHttpsTool postWithURL:@"getReAnchorList" params:paramDict success:^(id json) {
        if ([json[@"result"] intValue] ==1){
            successBlock(json,json[@"info"],[json[@"result"] intValue]);
        }else{
            failureBlock([json[@"result"] intValue],json[@"info"]);
        }
    } failure:^(NSError *error) {
        failureBlock(error.code,error.userInfo.description);
    }];
}

#pragma --mark 获取广告列表
- (void)getAdvListSuccess:(RequestSuccess)successBlock
                       failure:(RequestFailure)failureBlock{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"timestamp"] = [[LBToolModel sharedInstance]getTimestamp];
    paramDict[@"sign"] = [[LBToolModel sharedInstance]getSign:paramDict];
    [VBHttpsTool postWithURL:@"getAdvList" params:paramDict success:^(id json) {
        if ([json[@"result"] intValue] ==1){
            successBlock(json,json[@"info"],[json[@"result"] intValue]);
        }else{
            failureBlock([json[@"result"] intValue],json[@"info"]);
        }
    } failure:^(NSError *error) {
        failureBlock(error.code,error.userInfo.description);
    }];
}
#pragma --mark 我喜欢的主播列表
- (void)getFcousListWithPage:(NSString *)page
                              success:(RequestSuccess)successBlock
                              failure:(RequestFailure)failureBlock{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"token"] = TOKEN;
    paramDict[@"row"] = @"20";
    paramDict[@"page"] = [NSNumber numberWithInt:[page intValue]];
    paramDict[@"sign"] = [[LBToolModel sharedInstance]getSign:paramDict];
    [VBHttpsTool postWithURL:@"getFcousList" params:paramDict success:^(id json) {
        if ([json[@"result"] intValue] ==1){
            successBlock(json,json[@"info"],[json[@"result"] intValue]);
        }else{
            failureBlock([json[@"result"] intValue],json[@"info"]);
        }
    } failure:^(NSError *error) {
        failureBlock(error.code,error.userInfo.description);
    }];
}

#pragma --mark 平台的 主播列表
- (void)getFcousListWithPage:(NSString *)page
                  livePlatID:(NSString *)livePlatID
                     success:(RequestSuccess)successBlock
                     failure:(RequestFailure)failureBlock{

    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"timestamp"] = [[LBToolModel sharedInstance] getTimestamp];
    paramDict[@"livePlatID"] = livePlatID;
    paramDict[@"page"] = [NSNumber numberWithInt:[page intValue]];
    paramDict[@"sign"] = [[LBToolModel sharedInstance]getSign:paramDict];
    [VBHttpsTool postWithURL:@"getAnchorList" params:paramDict success:^(id json) {
        if ([json[@"result"] intValue] ==1){
            successBlock(json,json[@"info"],[json[@"result"] intValue]);
        }else{
            failureBlock([json[@"result"] intValue],json[@"info"]);
        }
    } failure:^(NSError *error) {
        failureBlock(error.code,error.userInfo.description);
    }];
}


#pragma mark 获取直播平台
- (void)getLivePlatListSuccess:(RequestSuccess)successBlock
                  failure:(RequestFailure)failureBlock{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"timestamp"] = [[LBToolModel sharedInstance] getTimestamp];
    
    paramDict[@"sign"] = [[LBToolModel sharedInstance] getSign:paramDict];
    
    [VBHttpsTool postWithURL:@"getLivePlatList" params:paramDict success:^(id json) {
        if ([json[@"result"] intValue] ==1){
            successBlock(json,json[@"info"],[json[@"result"] intValue]);
        }else{
            failureBlock([json[@"result"] intValue],json[@"info"]);
        }
    } failure:^(NSError *error) {
        failureBlock(error.code,error.userInfo.description);
    }];
}



#pragma mark 获取基本配置信息
- (void)getBaseConfigSuccess:(RequestSuccess)successBlock
                       failure:(RequestFailure)failureBlock{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"apiKey"] = APIKEY;
    paramDict[@"timestamp"] = [[LBToolModel sharedInstance]getTimestamp];
    paramDict[@"sign"] = [[LBToolModel sharedInstance] getSign:paramDict];
    [VBHttpsTool postWithURL:@"getBaseConfig" params:paramDict success:^(id json) {
        if ([json[@"result"] intValue] ==1){
            successBlock(json,json[@"info"],[json[@"result"] intValue]);
        }else{
            failureBlock([json[@"result"] intValue],json[@"info"]);
        }
    } failure:^(NSError *error) {
        failureBlock(error.code,error.userInfo.description);
    }];
}


#pragma --mark 搜索主播
- (void)serachAnchorWithkeyword:(NSString *)keyword
                     success:(RequestSuccess)successBlock
                     failure:(RequestFailure)failureBlock{
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"keyword"] = keyword;
    paramDict[@"sign"] = [[LBToolModel sharedInstance] getSign:paramDict];
    [VBHttpsTool postWithURL:@"serachAnchor" params:paramDict success:^(id json) {
        if ([json[@"result"] intValue] ==1){
            successBlock(json,json[@"info"],[json[@"result"] intValue]);
        }else{
            failureBlock([json[@"result"] intValue],json[@"info"]);
        }
    } failure:^(NSError *error) {
        failureBlock(error.code,error.userInfo.description);
    }];
}


#pragma --mark 获取播放历史
- (void)getPlayeListWithPage:(NSString *)page
                        success:(RequestSuccess)successBlock
                        failure:(RequestFailure)failureBlock{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"token"] = TOKEN;
    paramDict[@"row"] = @"20";
    paramDict[@"page"] = page;
    paramDict[@"sign"] = [[LBToolModel sharedInstance]getSign:paramDict];
    [VBHttpsTool postWithURL:@"getPlayeList" params:paramDict success:^(id json) {
        if ([json[@"result"] intValue] ==1){
            successBlock(json,json[@"info"],[json[@"result"] intValue]);
        }else{
            failureBlock([json[@"result"] intValue],json[@"info"]);
        }
    } failure:^(NSError *error) {
        failureBlock(error.code,error.userInfo.description);
    }];
}



#ifdef DEBUG
- (void)networkStateChange{
    if ([self.reachability currentReachabilityStatus] == ReachableViaWiFi) {
        NSLog(@"有wifi");
    }else if ([self.reachability currentReachabilityStatus] == ReachableViaWWAN) {
        NSLog(@"使用手机自带网络进行上网");
    }else {
        NSLog(@"没有网络");
    }
}
#endif
@end
