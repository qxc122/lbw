//
//  LBShowBannerView.m
//  Core
//
//  Created by Jan on 2018/4/7.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "LBShowBannerView.h"


@interface LBShowBannerView ()
@property (nonatomic,weak) UIImageView *bannerImageView;
@property (nonatomic,weak) UILabel *timeLabel;
@property (nonatomic,weak) UIButton *close;




@property (nonatomic,strong) NSTimer *scrollTimer;
@property (nonatomic,strong) LBGetVerCodeModel *data;
@end


@implementation LBShowBannerView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.data =  [ChatTool shareChatTool].basicConfig;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        UIImageView *bannerImageView = [UIImageView new];
        bannerImageView.userInteractionEnabled = YES;
        self.bannerImageView = bannerImageView;
        bannerImageView.contentMode = UIViewContentModeScaleAspectFill;
        bannerImageView.clipsToBounds = YES;
        [self addSubview:bannerImageView];
        CGFloat leftPading = 40;
        CGFloat showViewWidth = kFullWidth-leftPading*2;
        CGFloat showViewHeight = showViewWidth*1.5;
        bannerImageView.frame = CGRectMake((kFullWidth-showViewWidth)/2, (kFullHeight-showViewHeight)/2, showViewWidth, showViewHeight);
        
        LBGetAdvListModelAll *data =  [NSKeyedUnarchiver unarchiveObjectWithFile:PATH_guanggao];
        NSString *urrl;
        for (LBGetAdvListModel *one in data.arry) {
            if ([one.advType isEqualToString:@"2"]) {
                if ([one.advImageUrl rangeOfString:@"http"].location ==NSNotFound){
                    urrl = [NSString stringWithFormat:@"%@%@",ImageHead,one.advImageUrl];
                }else{
                    urrl = one.advImageUrl;
                }
                break;
            }
        }
        if (urrl) {
            [bannerImageView setImageURL:[NSURL URLWithString:urrl]];
        } else {
            [bannerImageView setImageURL:[NSURL URLWithString:self.data.live_adv_image]];
        }
        
        NSString *timeStr;
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"type"] intValue] ==1 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"type"] intValue] ==2){
            timeStr = self.data.live_adv_vip_user;
        }else{
            timeStr = self.data.live_adv_user;
        }
    
        UIButton *close = [UIButton new];
        self.close = close;
        [close setImage:[UIImage imageNamed:ZHIBOGUANBI] forState:UIControlStateNormal];
        [bannerImageView addSubview:close];
        close.frame = CGRectMake(bannerImageView.width-50, 10, 40, 40);
        [close addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        UILabel *timeLabel = [UILabel new];
        self.timeLabel = timeLabel;
        timeLabel.textAlignment = 1;
        timeLabel.textColor = [UIColor whiteColor];
        timeLabel.font = [UIFont systemFontOfSize:14];
        timeLabel.text = [NSString stringWithFormat:@"%@S",timeStr];
        timeLabel.backgroundColor = [UIColor lightGrayColor];
        [bannerImageView addSubview:timeLabel];
        timeLabel.frame = CGRectMake(bannerImageView.width-50, 10, 40, 20);
        if ([self.isNeedDaoJiShi isEqualToString:@"1"]) {
            self.timeLabel.hidden = YES;
            self.close.hidden = NO;
        } else {
            self.timeLabel.hidden = NO;
            self.close.hidden = YES;
        }
        self.hidden = YES;
    }
    return self;
}
- (void)setIsNeedDaoJiShi:(NSString *)isNeedDaoJiShi{
    _isNeedDaoJiShi = isNeedDaoJiShi;
    if ([self.isNeedDaoJiShi isEqualToString:@"1"]) {
        self.timeLabel.hidden = YES;
        self.close.hidden = NO;
    } else {
        self.timeLabel.hidden = NO;
        self.close.hidden = YES;
    }
}
- (void)show{
    self.hidden = NO;
    NSString *timeStr;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"type"] intValue] ==1 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"type"] intValue] ==2){
        timeStr = self.data.live_adv_vip_user;
    }else{
        timeStr = self.data.live_adv_user;
    }
    self.num = [timeStr integerValue];
    if(![self.isNeedDaoJiShi isEqualToString:@"1"]){
        if (self.num) {
            [self creatTimer];
        } else {
            [self closeView];
        }
    }
}
-(void)closeView{
    self.hidden = YES;
}

#pragma mark----创建定时器
-(void)creatTimer
{
    _scrollTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(daojishiRunning) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_scrollTimer forMode:NSRunLoopCommonModes];
    self.timeLabel.text = [NSString stringWithFormat:@"%ldS",self.num];;
}
#pragma mark----倒计时
-(void)daojishiRunning{
    self.num--;
    if (self.num <= 0) {
        [self removeTimer];
        [self closeView];
    }else{
        self.timeLabel.text = [NSString stringWithFormat:@"%ldS",self.num];;
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
    NSLog(@"广告销毁了");
    [self removeTimer];
}
@end
