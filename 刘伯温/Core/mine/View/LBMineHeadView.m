//
//  LBMineHeadView.m
//  Core
//
//  Created by mac on 2017/9/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LBMineHeadView.h"
@interface LBMineHeadView ()
@property (nonatomic, strong)UIImageView *iconImageView;
@property (nonatomic, strong)UILabel *nickNameLabel;
@property (nonatomic, strong)UIImageView *levelImageView;
@property (nonatomic, strong)UIButton *rightImageView;
@property (nonatomic, strong)UILabel *timeLabel;
@property (nonatomic, strong)UILabel *isVipLabel;
@property(nonatomic, strong)UILabel *fixInfoLabel;
@property (nonatomic,strong)UILabel *moneyLabel;
@property (nonatomic,strong)UILabel *glodLabel;

@end
@implementation LBMineHeadView
-(void)setInfoModel:(LBGetMyInfoModel *)infoModel{
    _infoModel = infoModel;
    self.nickNameLabel.text = infoModel.name;
    
    if([infoModel.avatar rangeOfString:@"http"].location !=NSNotFound){
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.infoModel.avatar] placeholderImage:[UIImage imageNamed:@"头像"]];
    }else{
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageHead,infoModel.avatar]] placeholderImage:[UIImage imageNamed:@"头像"]];
    }
    self.fixInfoLabel.hidden = !(infoModel.avatar.length || infoModel.name.length ||infoModel.surname.length || infoModel.address.length ||infoModel.qq.length || infoModel.postcode.length || infoModel.phone.length);

    if ([infoModel.type isEqualToString:@"0"]) {
        self.isVipLabel.text = @"您还没有开通会员";
        self.levelImageView.hidden = YES;
    } else {
        self.levelImageView.hidden = NO;
        self.isVipLabel.text = infoModel.expirationDate;
    }
    int teee = [Integral intValue];
    self.glodLabel.text = [NSString stringWithFormat:@"%d个",teee];
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f元",[infoModel.amount floatValue]+[infoModel.freezing floatValue]];
    
    if (infoModel.name.length && infoModel.phone.length && infoModel.address.length && infoModel.qq.length && infoModel.surname.length && infoModel.avatar.length && infoModel.postcode.length) {
        self.fixInfoLabel.text = @"修改个人信息";
    } else {
        self.fixInfoLabel.text = @"请完善个人信息";
    }
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = MainColor;
        
        UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kFullWidth, 0)];
        navLabel.text = @"我的";
        navLabel.hidden = YES;
        navLabel.textColor = [UIColor whiteColor];
        navLabel.font = CustomUIFont(17);
        [self addSubview:navLabel];
        navLabel.textAlignment = 1;
        navLabel.userInteractionEnabled = YES;
        UIButton *settingButton = [UIButton buttonWithType:0];
        [settingButton setImage:[UIImage imageNamed:@"more_setting"] forState:0];
        [settingButton addTarget:self action:@selector(settingButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [navLabel addSubview:settingButton];
        settingButton.frame = CGRectMake(navLabel.width-40, 10, 0, 0);
        settingButton.hidden = YES;
        //        settingButton.backgroundColor = [UIColor orangeColor];
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-100-navLabel.bottom)];
        [self addSubview:topView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickEndit)];
        [topView addGestureRecognizer:tap];
        
        
        self.iconImageView = [UIImageView new];
        self.iconImageView.image = [UIImage imageNamed:@"头像"];
        self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.iconImageView.clipsToBounds = YES;
        [topView addSubview:self.iconImageView];
        
        CGFloat leftPading = 15;
        self.iconImageView.frame = CGRectMake(leftPading, leftPading, topView.height-leftPading*2.5, topView.height-leftPading*2.5);
        self.iconImageView.layer.cornerRadius = self.iconImageView.width/2;
        
        
        self.nickNameLabel = [UILabel new];
        self.nickNameLabel.text = NICKNAME;
        self.nickNameLabel.font = CustomUIFont(14);
        self.nickNameLabel.textColor = [UIColor whiteColor];
        [topView  addSubview:self.nickNameLabel];
        self.nickNameLabel.frame = CGRectMake(self.iconImageView.right+leftPading, self.iconImageView.centerY-20, 180, 20);
        
        
        self.levelImageView = [UIImageView new];
        self.levelImageView.image = [UIImage imageNamed:@"等级"];
        [topView addSubview:self.levelImageView];
        self.levelImageView.frame = CGRectMake(self.nickNameLabel.left, self.nickNameLabel.bottom, 30, 30);
        
        self.rightImageView = [UIButton new];
        [self.rightImageView setImage:[UIImage imageNamed:@"右边箭头-2"] forState:0];
        [topView addSubview:self.rightImageView];
        self.rightImageView.frame = CGRectMake(topView.width-40, (topView.height-20)/2, 30, 30);
        [self.rightImageView addTarget:self action:@selector(clickEndit) forControlEvents:UIControlEventTouchUpInside];
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, topView.bottom, kFullWidth, 0.5)];
        line.backgroundColor = [BackGroundColor colorWithAlphaComponent:0.3];
        [self addSubview:line];
        
        
        
        self.fixInfoLabel = [UILabel new];
        self.fixInfoLabel.text = @"请完善个人信息";
        self.fixInfoLabel.font = CustomUIFont(12);
        self.fixInfoLabel.textColor = [UIColor whiteColor];
        [topView  addSubview:self.fixInfoLabel];
        self.fixInfoLabel.frame = CGRectMake(self.rightImageView.left-100, self.rightImageView.top, 100, self.rightImageView.height);
        
        self.timeLabel = [UILabel new];
        self.timeLabel.text = @"到期时间";
        self.timeLabel.font = CustomUIFont(14);
        self.timeLabel.textColor = [UIColor whiteColor];
        [self  addSubview:self.timeLabel];
        self.timeLabel.frame = CGRectMake(leftPading, line.bottom, 100, 40);
        
        
        self.isVipLabel = [UILabel new];
        self.isVipLabel.font = CustomUIFont(14);
        self.isVipLabel.textColor = [UIColor whiteColor];
        [self  addSubview:self.isVipLabel];
        self.isVipLabel.frame = CGRectMake(kFullWidth-150, line.bottom, 150, 40);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chageUserInfoNotifi) name:@"chageUserInfoNotifi" object:nil];
        
        
        UIButton *moneyButton = [UIButton buttonWithType:0];
        moneyButton.frame = CGRectMake(0, self.timeLabel.bottom, self.width/2, 60);
                [moneyButton addTarget:self action:@selector(moneyButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:moneyButton];
        moneyButton.backgroundColor = [UIColor whiteColor];
        
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(moneyButton.width-0.5, 0, 0.5, moneyButton.height)];
        lineLabel.backgroundColor = CustomColor(240, 240, 240, 1);
        [moneyButton addSubview:lineLabel];
        UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, moneyButton.width, moneyButton.height/2)];
        moneyLabel.textColor = CustomColor(64, 150, 213, 1);
        moneyLabel.font = [UIFont boldSystemFontOfSize:17];
        moneyLabel.text = @"0.00元";
        [moneyButton addSubview:(self.moneyLabel=moneyLabel)];
        moneyLabel.textAlignment = 1;
        UILabel *moneyRemendLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, moneyButton.height-20, moneyButton.width, 15)];
        moneyRemendLabel.textColor = [UIColor lightGrayColor];
        moneyRemendLabel.font = [UIFont systemFontOfSize:13];
        moneyRemendLabel.text = @"钱包";
        [moneyButton addSubview:moneyRemendLabel];
        moneyRemendLabel.textAlignment = 1;
        
        
        
        
        UIButton *glodButton = [UIButton buttonWithType:0];
        glodButton.frame = CGRectMake(moneyButton.right, moneyButton.top, moneyButton.width, moneyButton.height);
        [glodButton addTarget:self action:@selector(glodButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:glodButton];
        glodButton.backgroundColor = [UIColor whiteColor];
        UILabel *glodLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, glodButton.width, glodButton.height/2)];
        glodLabel.textColor = CustomColor(240, 132, 91, 1);
        glodLabel.font = [UIFont boldSystemFontOfSize:17];
        glodLabel.text = @"0个";
        [glodButton addSubview:(self.glodLabel=glodLabel)];
        glodLabel.textAlignment = 1;
        UILabel *goldRemendLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, glodButton.height-20, glodButton.width, 15)];
        goldRemendLabel.textColor = [UIColor lightGrayColor];
        goldRemendLabel.font = [UIFont systemFontOfSize:13];
        goldRemendLabel.text = @"金币";
        [glodButton addSubview:goldRemendLabel];
        goldRemendLabel.textAlignment = 1;
        
        if (!ISLOGIN){
            self.nickNameLabel.text = @"游客";
            self.isVipLabel.text = @"尚未开通会员";
            self.levelImageView.hidden = YES;
            self.nickNameLabel.top = self.iconImageView.centerY-10;
        }else{
            self.isVipLabel.text = EXPIRATIONDATE;
            if (!self.isVipLabel.text.length){
                self.isVipLabel.text = @"尚未开通会员";
                self.levelImageView.hidden = YES;
                self.nickNameLabel.top = self.iconImageView.centerY-10;
            }else{
                self.levelImageView.hidden = NO;
                self.nickNameLabel.top = self.iconImageView.centerY-20;
            }
        }
        
    }
    return self;
}

- (void)chageUserInfoNotifi{
    self.nickNameLabel.text = NICKNAME;
}

- (void)moneyButton{
    if (self.moneyButtonBlock){
        self.moneyButtonBlock();
    }
}

- (void)clickEndit{
    if (self.clickEnditBlock){
        self.clickEnditBlock();
    }
}
- (void)settingButtonClick{
    if (self.clickSettingBlock){
        self.clickSettingBlock();
    }
}

- (void)glodButtonClick{
    if (self.clickGoldBlock){
        self.clickGoldBlock();
    }
}

@end

