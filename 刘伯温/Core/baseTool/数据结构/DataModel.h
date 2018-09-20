//
//  DataModel.h
//  base
//
//  Created by 开发者最好的 on 2018/8/22.
//  Copyright © 2018年 开发者最好的. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface DataModel : NSObject
@property (nonatomic,strong) NSString *arrDate;
@property (nonatomic,strong) NSURL *bankIcon;
@property (nonatomic,strong) NSString *bankName;
@property (nonatomic,strong) NSString *calDate;
@property (nonatomic,strong) NSNumber *cardNo;
@property (nonatomic,strong) NSString *fee;
@property (nonatomic,strong) NSString *price;
@end


@interface msgList : NSObject
@property (nonatomic,strong) NSMutableArray *arry;
@end

@interface msgOne : NSObject
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *msg;
@property (nonatomic,strong) NSNumber *msg_id;
@property (nonatomic,strong) NSNumber *state;
@property (nonatomic,strong) NSString *userID;
@end


@interface bankList : NSObject
@property (nonatomic,strong) NSMutableArray *arry;
@end

@interface bankOne : NSObject
@property (nonatomic,strong) NSString *userID;
@property (nonatomic,strong) NSString *bankType;
@property (nonatomic,strong) NSString *cardNumber;
@property (nonatomic,strong) NSString *trueName;
@property (nonatomic,strong) NSString *state;
@property (nonatomic,strong) NSString *phone;
@end


@interface WithdrawalList : NSObject
@property (nonatomic,strong) NSMutableArray *arry;
@end

@interface WithdrawalOne : NSObject
@property (nonatomic,strong) NSString *amount;
@property (nonatomic,strong) NSString *balance;
@property (nonatomic,strong) NSString *bank;
@property (nonatomic,strong) NSString *cardNumber;
@property (nonatomic,strong) NSString *trueName;
@property (nonatomic,strong) NSString *memo;
@property (nonatomic,strong) NSString *state;
@end


@interface chatRecodList : NSObject
@property (nonatomic,strong) NSMutableArray *arry;
@end

@interface chatRecodOne : NSObject
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *msg;
@end
     



@interface LBGetVerCodeModel : NSObject

@property (nonatomic, copy)NSString *payfor_url;

@property (nonatomic, copy)NSString *freeTimes;
@property (nonatomic, copy)NSString *appxy;
@property (nonatomic, copy)NSString *inviteRewardDay;
@property (nonatomic, copy)NSString *sale_card_url;
@property (nonatomic, copy)NSString *msg;
@property (nonatomic, copy)NSString *ios_update_check;
@property (nonatomic, copy)NSString *android_update_check;
@property (nonatomic, copy)NSString *isStop;
@property (nonatomic, copy)NSString *shareMsg;
@property (nonatomic, copy)NSString *publishMsg;
@property (nonatomic, copy)NSString *shareVcode;
@property (nonatomic, copy)NSString *LHBW;
@property (nonatomic, copy)NSString *CFLT;
@property (nonatomic, copy)NSString *WBW;
@property (nonatomic, copy)NSString *isFree;
@property (nonatomic, copy)NSString *tab_liveTitle;
@property (nonatomic, copy)NSString *tab_lbwTitle;
@property (nonatomic, copy)NSString *tab_ltTitle;
@property (nonatomic, copy)NSString *tab_cpTitle;
@property (nonatomic, copy)NSString *goodsHelpUrl;
@property (nonatomic, copy)NSString *singReward;
@property (nonatomic, copy)NSString *regeidtReward;
@property (nonatomic, copy)NSString *shareReward;
@property (nonatomic, copy)NSString *invitationReward;
@property (nonatomic, copy)NSString *liveTipMsg;
@property (nonatomic, copy)NSString *invitationCode;
@property (nonatomic,copy)NSString *live_of;
@property (nonatomic,copy)NSString *live_adv_user;
@property (nonatomic,copy)NSString *live_adv_vip_user;
@property (nonatomic,copy)NSString *live_adv_image;
@property (nonatomic,copy)NSString *main_room_forbidden;
@property (nonatomic,copy)NSString *splash_inage_url;
@property (nonatomic,copy)NSString *main_room_id;
@end


@interface LBGetLivePlatModel : NSObject
@property(nonatomic, copy)NSString *ID;
@property(nonatomic, copy)NSString *livePlatID;
@property(nonatomic, copy)NSString *livePlatTitle;
@property(nonatomic, copy)NSString *livePlatDesc;
@property(nonatomic, copy)NSString *livePlatThumb;
@property(nonatomic, copy)NSString *anchorCount;
@property(nonatomic, copy)NSString *lineAnchorCount;
@property(nonatomic, copy)NSString *updateTime;
@property(nonatomic, copy)NSString *recommend;


@end


@interface LBAnchorListModelList : NSObject
@property(nonatomic, copy)NSMutableArray *data;
@end


@interface LBAnchorListModel : NSObject
@property(nonatomic, copy)NSString *ID;
@property(nonatomic, copy)NSString *livePlatID;
@property(nonatomic, copy)NSString *anchorID;
@property(nonatomic, copy)NSString *anchorName;
@property(nonatomic, copy)NSString *anchorLiveUrl;
@property(nonatomic, copy)NSString *anchorThumb;
@property(nonatomic, copy)NSString *playerTimes;
@property(nonatomic, copy)NSString *lineState;
@end


@interface LBGetAdvListModelAll : NSObject
@property(nonatomic, copy)NSArray *arry;
@end

@interface LBGetAdvListModel : NSObject
@property(nonatomic, copy)NSString *ID;
@property(nonatomic, copy)NSString *advID;
@property(nonatomic, copy)NSString *advDesc;
@property(nonatomic, copy)NSString *advImageUrl;
@property(nonatomic, copy)NSString *linkUrl;
@property(nonatomic, copy)NSString *advType;
@end


@interface LBExchangeModel : NSObject
@property(nonatomic, copy)NSString *ID;
@property(nonatomic, copy)NSString *goodsID;
@property(nonatomic, copy)NSString *goodsName;
@property(nonatomic, copy)NSString *goodsThumb;
@property(nonatomic, copy)NSString *memo;
@property(nonatomic, copy)NSString *bayCount;
@property(nonatomic, copy)NSString *xfIntegral;
@property(nonatomic, copy)NSString *status;
@property(nonatomic, copy)NSString *createTime;
@end

@interface LBGetGoodsListModel : NSObject
@property(nonatomic, copy)NSString *ID;
@property(nonatomic, copy)NSString *goodsID;
@property(nonatomic, copy)NSString *categoryID;
@property(nonatomic, copy)NSString *goodsName;
@property(nonatomic, copy)NSString *goodsThumb;
@property(nonatomic, copy)NSString *goodsInventory;
@property(nonatomic, copy)NSString *goodsBayCount;
@property(nonatomic, copy)NSString *needIntegral;
@property(nonatomic, copy)NSString *memo;
@property(nonatomic, copy)NSString *createTime;
@end


@interface LBGetMyInfoModel : NSObject
@property(nonatomic, copy)NSString *userID;
@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *account;
@property(nonatomic, copy)NSString *phone;
@property(nonatomic, copy)NSString *address;
@property(nonatomic, copy)NSString *surname;
@property(nonatomic, copy)NSString *qq;
@property(nonatomic, copy)NSString *postcode;
@property(nonatomic, copy)NSString *birthday;
@property(nonatomic, copy)NSString *gender;
@property(nonatomic, copy)NSString *type;
@property(nonatomic, copy)NSString *avatar;
@property(nonatomic, copy)NSString *expirationDate;
@property(nonatomic, copy)NSString *integral;
@property(nonatomic, copy)NSString *token;
@property(nonatomic, copy)NSString *testLend;
@property(nonatomic, copy)NSString *invitationCode;
@property (nonatomic,copy)NSString *amount;
@property (nonatomic,copy)NSString *freezing;
@property (nonatomic,copy)NSString *plateAccount;
@end

@interface LBGetActivationCardListModel : NSObject
@property(nonatomic, copy)NSString *ID;
@property(nonatomic, copy)NSString *userID;
@property(nonatomic, copy)NSString *cardNumber;
@property(nonatomic, copy)NSString *vipType;
@property(nonatomic, copy)NSString *saleTime;
@property(nonatomic, copy)NSString *memo;
@end
