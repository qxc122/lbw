//
//  windosView.m
//  TourismT
//
//  Created by Store on 16/12/15.
//  Copyright © 2016年 qxc122@126.com. All rights reserved.
//

#import "windosView.h"
#import "UIImageView+WebCache.h"
#import "WHC_GestureUnlockScreenVC.h"
#import "mainTableVc.h"
@interface windosView ()
@property (nonatomic,weak) UIImageView *png;

@property (nonatomic,weak) UIButton *skip;

@property (nonatomic,strong) NSTimer *scrollTimer;
@property (nonatomic,assign) NSInteger num;
@end


@implementation windosView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *png = [[UIImageView alloc] init];
        [self addSubview:png];
        [png mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(0);
            make.right.equalTo(self).offset(-0);
            make.top.equalTo(self).offset(0);
            make.bottom.equalTo(self).offset(-0);
        }];
        self.png = png;
        self.png.userInteractionEnabled = YES;
        self.png.contentMode = UIViewContentModeScaleToFill;
        
        
        [self getBaseConfig];
        if ([ChatTool shareChatTool].basicConfig) {
            [self setSkip];
            [self.png sd_setImageWithURL:[NSURL URLWithString:[ChatTool shareChatTool].basicConfig.splash_inage_url] placeholderImage:[UIImage imageNamed:@"splash2"]];
            [self creatTimer];
        } else {
            self.png.image = [UIImage imageNamed:@"splash2"];
        }
    }
    return self;
}

- (void)setSkip{
    UIButton *skip = [[UIButton alloc] init];
    [self addSubview:skip];
    [skip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-30);
        make.top.equalTo(self).offset(40);
        make.width.equalTo(@60);
        make.height.equalTo(@30);
    }];
    self.skip = skip;
    skip.layer.cornerRadius = 15.0f;
    skip.layer.masksToBounds = YES;
    
    [skip setTitle:@"6 跳过" forState:UIControlStateNormal];
    [skip setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    skip.titleLabel.font = [UIFont systemFontOfSize:14];
    skip.backgroundColor = [UIColor grayColor];
    [skip addTarget:self action:@selector(skipClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)skipClick{
    [self removeTimer];
    [self closeClisck];
}


#pragma mark----创建定时器
-(void)creatTimer
{
    self.num = 6;
    _scrollTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(daojishiRunning) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_scrollTimer forMode:NSRunLoopCommonModes];
    [self.skip setTitle:@"6 跳过" forState:UIControlStateDisabled];
}
#pragma mark----倒计时
-(void)daojishiRunning{
    self.num--;
    if (self.num <= 0) {
        [self skipClick];
        [self removeTimer];
    }else{
        [self.skip setTitle:[NSString stringWithFormat:@"%ld 跳过",(long)self.num] forState:UIControlStateNormal];
    }
}
#pragma mark----移除定时器
-(void)removeTimer
{
    if (_scrollTimer) {
        [_scrollTimer invalidate];
        _scrollTimer = nil;
    }
}

- (void)dealloc{
    NSLog(@"销毁广告控制器");
    [self removeTimer];
}

- (void)getBaseConfig{
    kWeakSelf(self);
    [[ToolHelper shareToolHelper]getBaseConfigSuccess:^(id dataDict, NSString *msg, NSInteger code) {
        NSLog(@"在广告页 基础信息获取成功");
        
        LBGetVerCodeModel *model = [LBGetVerCodeModel mj_objectWithKeyValues:dataDict[@"data"]];
        if(![ChatTool shareChatTool].basicConfig){
            [weakself  setSkip];
            [weakself.png sd_setImageWithURL:[NSURL URLWithString:model.splash_inage_url] placeholderImage:[UIImage imageNamed:@"splash2"]];
            [weakself creatTimer];
        }
        [ChatTool shareChatTool].basicConfig = model;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getBaseConfigSuccess" object:nil];
    } failure:^(NSInteger errorCode, NSString *msg) {
        [weakself performSelector:@selector(getBaseConfig) withObject:nil afterDelay:0.3];
    }];
}




- (void)closeClisck{
    [self removeFromSuperview];
}
- (void)windosViewshow{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(window);
        make.right.equalTo(window);
        make.top.equalTo(window);
        make.bottom.equalTo(window);
    }];
}
@end
