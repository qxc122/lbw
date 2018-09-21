//
//  NetworkStateTool.h
//  base
//
//  Created by 开发者最好的 on 2018/8/15.
//  Copyright © 2018年 开发者最好的. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "single.h"
#import "MACRO_URL.h"

//数据请求码
typedef NS_ENUM(NSInteger, RespondCode)
{
    kRespondCodeNotJson             = 3,
    KRespondCodeNone                = 9,
    KRespondCodeabc                = 999,
    KRespondCodeFail                = 0, /** 失败 */
    kRespondCodeSuccess            = 1,/** 成功 */
    KRespondCodeNotConnect         = -12315,    //网络无连接
};


typedef void (^RequestSuccess)(id dataDict, NSString *msg, NSInteger code);
typedef void (^RequestFailure)(NSInteger errorCode, NSString *msg);
typedef void (^RequestProgress)(NSProgress *uploadProgress);


@interface ToolHelper : NSObject
@property (strong, nonatomic) NSMutableArray *list;
@property (assign, nonatomic) BOOL IskJMSGNetworkOK;
- (void)addArry:(NSArray *)arry;

singleH(ToolHelper);

-(BOOL)isReachable;

- (void)CP_getMyMsgWithlastId:(NSNumber *)lastId
                      success:(RequestSuccess)successBlock
                      failure:(RequestFailure)failureBlock;

- (void)CP_url_buyCardWithvipType:(NSNumber *)vipType
                          success:(RequestSuccess)successBlock
                          failure:(RequestFailure)failureBlock;

- (void)CP_url_loginWithaccount:(NSString *)account
                       password:(NSString *)password
                     clientType:(NSString *)clientType
                        version:(NSString *)version
                           sign:(NSString *)sign
                        success:(RequestSuccess)successBlock
                        failure:(RequestFailure)failureBlock;

- (void)getUserInfosuccess:(RequestSuccess)successBlock
                   failure:(RequestFailure)failureBlock;

- (void)bindBankWithbank_type:(NSString *)bank_type
                   cardNumber:(NSString *)cardNumber
                     trueName:(NSString *)trueName
                        phone:(NSString *)phone
                        vcode:(NSString *)vcode
                      success:(RequestSuccess)successBlock
                      failure:(RequestFailure)failureBlock;

- (void)getVerCodeWithphone:(NSString *)phone
                       type:(NSNumber *)type
                    success:(RequestSuccess)successBlock
                    failure:(RequestFailure)failureBlock;

- (void)myBankCardListsuccess:(RequestSuccess)successBlock
                      failure:(RequestFailure)failureBlock;

- (void)submitCashLogWithpage:(NSNumber *)page
                          row:(NSNumber *)row
                      success:(RequestSuccess)successBlock
                      failure:(RequestFailure)failureBlock;

- (void)submitCashWithbank_type:(NSString *)bank_type
                     cardNumber:(NSString *)cardNumber
                       trueName:(NSString *)trueName
                          phone:(NSString *)phone
                         amount:(NSString *)amount
                        success:(RequestSuccess)successBlock
                        failure:(RequestFailure)failureBlock;

- (void)complaintsanchorID:(NSString *)anchorID
                      type:(NSNumber *)type
                      memo:(NSString *)memo
                   success:(RequestSuccess)successBlock
                   failure:(RequestFailure)failureBlock;

- (void)getSimpleChatRoomRecanchor_id:(NSString *)anchor_id
                              success:(RequestSuccess)successBlock
                              failure:(RequestFailure)failureBlock;

- (void)getReAnchorListSuccess:(RequestSuccess)successBlock
                       failure:(RequestFailure)failureBlock;

#pragma --mark 获取广告列表
- (void)getAdvListSuccess:(RequestSuccess)successBlock
                  failure:(RequestFailure)failureBlock;

#pragma --mark 我喜欢的主播列表
- (void)getFcousListWithPage:(NSString *)page
                     success:(RequestSuccess)successBlock
                     failure:(RequestFailure)failureBlock;

#pragma mark 获取直播平台
- (void)getLivePlatListSuccess:(RequestSuccess)successBlock
                       failure:(RequestFailure)failureBlock;

#pragma mark 获取基本配置信息
- (void)getBaseConfigSuccess:(RequestSuccess)successBlock
                     failure:(RequestFailure)failureBlock;

#pragma --mark 平台的 主播列表
- (void)getFcousListWithPage:(NSString *)page
                  livePlatID:(NSString *)livePlatID
                     success:(RequestSuccess)successBlock
                     failure:(RequestFailure)failureBlock;

#pragma --mark 搜索主播
- (void)serachAnchorWithkeyword:(NSString *)keyword
                        success:(RequestSuccess)successBlock
                        failure:(RequestFailure)failureBlock;
@end
