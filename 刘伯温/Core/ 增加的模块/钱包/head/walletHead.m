//
//  walletHead.m
//  Core
//
//  Created by heiguohua on 2018/9/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "walletHead.h"


@interface walletHead ()
@property(nonatomic, weak)UILabel *one;
@property (nonatomic,weak)UILabel *two;
@property (nonatomic,weak)UILabel *three;
@end



@implementation walletHead

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = MainColor;
        
        UILabel *one = [UILabel new];
        one.text = @"钱包账户(元)";
        self.one = one;
        [self addSubview:one];
        one.font = [UIFont systemFontOfSize:14];
        one.textColor = [UIColor whiteColor];
        
        [one mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.top.equalTo(self).offset(15);
        }];
        
        UILabel *two = [UILabel new];
        self.two = two;
        [self addSubview:two];
        two.font = [UIFont boldSystemFontOfSize:24];
        two.textColor = [UIColor whiteColor];
        
        [two mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.centerY.equalTo(self);
        }];
        
        UILabel *three = [UILabel new];
        self.three = three;
        [self addSubview:three];
        three.font = [UIFont systemFontOfSize:14];
        three.textColor = [UIColor whiteColor];
        
        [three mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.bottom.equalTo(self).offset(-15);
        }];
        

        self.two.text = [NSString stringWithFormat:@"%.2f",[[ChatTool shareChatTool].User.amount floatValue]+[[ChatTool shareChatTool].User.freezing floatValue]];
        self.three.text = [NSString stringWithFormat:@"不可提现金额(%.2f)",[[ChatTool shareChatTool].User.freezing floatValue]];
    }
    return self;
}
- (void)setData:(LBGetMyInfoModel *)data{
    _data = data;
    self.two.text = [NSString stringWithFormat:@"%.2f",[data.amount floatValue]+[data.freezing floatValue]];
    self.three.text = [NSString stringWithFormat:@"不可提现金额(%.2f)",[data.freezing floatValue]];
}
@end
