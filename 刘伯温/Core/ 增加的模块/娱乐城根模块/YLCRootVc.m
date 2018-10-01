//
//  YLCRootVc.m
//  Core
//
//  Created by heiguohua on 2018/10/1.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "YLCRootVc.h" 
#import "Masonry.h"
#import "HeaderBase.h"
#import "LBShowRemendView.h"
#import "LBLoginViewController.h"
#import "JCHATConversationViewController.h"
#import "ChatRoom.h"
#import "LBShowBannerView.h"
#import "zhiboAndWebVc.h"
@interface baseWkVc ()

@property(nonatomic, weak)UIButton *guanggPng;
@property(nonatomic, weak)UIButton *CPButtom;
@property(nonatomic, weak)UIButton *ChatRoomButton;
@property(nonatomic, weak)LBShowBannerView *guangaoView;
@property(nonatomic, strong)zhiboAndWebVc *zhiboAndWebVcvc;
@property(nonatomic, strong)JCHATConversationViewController *chatRoom;
@end


@implementation YLCRootVc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"娱乐城";
    NSString *reqUrl = reqUrl = [ChatTool shareChatTool].basicConfig.WBW;
    self.title = [ChatTool shareChatTool].basicConfig.tab_cpTitle;
    self.islogSuccessfully = YES;
    [self addBottomView];
    [self AddguangaoView];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:reqUrl]];
    [self.webView loadRequest:request];
}





- (void)addBottomView{
    UIButton *ChatRoomButton = [UIButton buttonWithType:0];
    self.ChatRoomButton= ChatRoomButton;
    ChatRoomButton.imageView.contentMode = UIViewContentModeScaleToFill;
    [ChatRoomButton setBackgroundImage:[UIImage imageNamed:IM_VIEW_swith_WEB] forState:0];
    [ChatRoomButton setBackgroundImage:[UIImage imageNamed:IM_VIEW_swith_WEB] forState:UIControlStateHighlighted];
    [ChatRoomButton addTarget:self action:@selector(ChatRoomButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ChatRoomButton];
    [ChatRoomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-(SCREENWIDTH/5-width_zhibo)*0.5);
        make.bottom.equalTo(self.view).offset(-10-49);
        make.width.equalTo(@(width_zhibo));
        make.height.equalTo(@(width_zhibo));
    }];
    
    
    UIButton *likeButton = [UIButton buttonWithType:0];
    self.CPButtom= likeButton;
    likeButton.imageView.contentMode = UIViewContentModeScaleToFill;
    [likeButton setBackgroundImage:[UIImage imageNamed:zhiboAndWebVcToWeb] forState:0];
    [likeButton setBackgroundImage:[UIImage imageNamed:zhiboAndWebVcToWeb] forState:UIControlStateHighlighted];
    [likeButton addTarget:self action:@selector(likeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:likeButton];
    [likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-(SCREENWIDTH/5-width_zhibo)*0.5);
        make.bottom.equalTo(ChatRoomButton.mas_top).offset(-15);
        make.width.equalTo(@(width_zhibo));
        make.height.equalTo(@(width_zhibo));
    }];
    
    
    
    UIButton *guanggPng = [UIButton buttonWithType:0];
    guanggPng.imageView.contentMode = UIViewContentModeScaleToFill;
    [guanggPng setBackgroundImage:[UIImage imageNamed:zhiboAndWebVcMoney] forState:0];
    [guanggPng setBackgroundImage:[UIImage imageNamed:zhiboAndWebVcMoney] forState:UIControlStateHighlighted];
    [guanggPng addTarget:self action:@selector(guanggPngClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:(self.guanggPng=guanggPng)];
    [guanggPng mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(likeButton);
        make.bottom.equalTo(likeButton.mas_top).offset(-15);
        make.width.equalTo(@(width_zhibo));
        make.height.equalTo(@(width_zhibo));
    }];
}


- (void)likeBtnClick{
    UIViewController *zhiboAndWebVcvc;
    for (UIViewController *tmp  in self.navigationController.childViewControllers) {
        if ([tmp isKindOfClass:[zhiboAndWebVc class]]) {
            zhiboAndWebVcvc = tmp;
            break;
        }
    }
    if (zhiboAndWebVcvc) {
        [self.navigationController popToViewController:zhiboAndWebVcvc animated:YES];
    } else {
        if (!self.zhiboAndWebVcvc) {
            self.zhiboAndWebVcvc =[zhiboAndWebVc new];
        }
        [self.navigationController pushViewController:self.zhiboAndWebVcvc animated:YES];
    }
}


#pragma mark 打开聊天室
- (void)ChatRoomButtonClick{
    UIViewController *chatRoom;
    for (UIViewController *tmp  in self.navigationController.childViewControllers) {
        if ([tmp isKindOfClass:[JCHATConversationViewController class]]) {
            chatRoom = tmp;
            break;
        }
    }
    if (chatRoom) {
        [self.navigationController popToViewController:chatRoom animated:YES];
    } else {
        if (!self.chatRoom) {
            self.chatRoom = [JCHATConversationViewController new];
            self.chatRoom.gotoZhiBoVc = YES;
        }
        [self.navigationController pushViewController:self.chatRoom animated:YES];
    }
}

- (void)guanggPngClick{
    self.guangaoView.isNeedDaoJiShi = @"1";
    [self.guangaoView show];
}

- (void )AddguangaoView{
    LBShowBannerView *guangaoView =[LBShowBannerView new];
    //    kWeakSelf(self);
    //    guangaoView.doneSomething = ^{
    //        [weakself setTopBtnEnable:YES];
    //    };
    self.guangaoView = guangaoView;
    [self.view addSubview:guangaoView];
    [guangaoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}
@end
