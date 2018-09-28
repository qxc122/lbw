//
//  WithdrawalCell.m
//  Core
//
//  Created by heiguohua on 2018/9/11.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "WithdrawalCell.h"
#import "Masonry.h"
#import "Header.h"

@interface WithdrawalCell ()

@property (nonatomic,weak) UILabel *amount;
@property (nonatomic,weak) UILabel *balance;
@property (nonatomic,weak) UILabel *bank;
@property (nonatomic,weak) UILabel *cardNumber;
@property (nonatomic,weak) UILabel *trueName;
@property (nonatomic,weak) UILabel *memo;
@property (nonatomic,weak) UILabel *state;

@property (nonatomic,weak) UIView *line;

@end

@implementation WithdrawalCell

+ (instancetype)returnCellWith:(UITableView *)tableView
{
    WithdrawalCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (cell == nil) {
        cell = [[WithdrawalCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        
        UILabel *amount = [[UILabel alloc] init];
        self.amount = amount;
        [self.contentView addSubview:amount];

        UILabel *balance = [[UILabel alloc] init];
        self.balance = balance;
        [self.contentView addSubview:balance];
        
        UILabel *bank = [[UILabel alloc] init];
        self.bank = bank;
        [self.contentView addSubview:bank];
        
        UILabel *cardNumber = [[UILabel alloc] init];
        self.cardNumber = cardNumber;
        [self.contentView addSubview:cardNumber];
        
        UILabel *trueName = [[UILabel alloc] init];
        self.trueName = trueName;
        [self.contentView addSubview:trueName];
        
        UILabel *memo = [[UILabel alloc] init];
        self.memo = memo;
        [self.contentView addSubview:memo];
        
        UILabel *state = [[UILabel alloc] init];
        self.state = state;
        [self.contentView addSubview:state];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor =BackGroundColor;
        [self.contentView addSubview:line];
        
        [amount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.top.equalTo(self.contentView).offset(15);
        }];
        [balance mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.top.equalTo(self.amount.mas_bottom).offset(15);
        }];
        [bank mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.top.equalTo(self.balance.mas_bottom).offset(15);
        }];
        [cardNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.top.equalTo(self.bank.mas_bottom).offset(15);
        }];
        [trueName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.top.equalTo(self.cardNumber.mas_bottom).offset(15);
        }];
        [memo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.top.equalTo(self.trueName.mas_bottom).offset(15);
        }];
        [state mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.top.equalTo(self.memo.mas_bottom).offset(15);
            make.bottom.equalTo(self.contentView).offset(-15);
        }];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.bottom.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-15);
            make.height.equalTo(@0.5);
        }];
        
        
        amount.font = [UIFont systemFontOfSize:15];
        amount.textColor = [UIColor darkTextColor];
        
        balance.font = [UIFont systemFontOfSize:15];
        balance.textColor = [UIColor darkTextColor];
        
        bank.font = [UIFont systemFontOfSize:15];
        bank.textColor = [UIColor darkTextColor];
        
        cardNumber.font = [UIFont systemFontOfSize:15];
        cardNumber.textColor = [UIColor darkTextColor];
        
        trueName.font = [UIFont systemFontOfSize:15];
        trueName.textColor = [UIColor darkTextColor];
        
        memo.font = [UIFont systemFontOfSize:15];
        memo.textColor = [UIColor darkTextColor];
        
        state.font = [UIFont systemFontOfSize:15];
        state.textColor = [UIColor darkTextColor];
    }
    return self;
}

- (void)setOne:(WithdrawalOne *)one{
    _one = one;
    self.amount.text = [NSString stringWithFormat:@"提现金额 %@",one.amount];
    self.balance.text = [NSString stringWithFormat:@"剩余金额 %@",one.balance];
    self.bank.text = [NSString stringWithFormat:@"银行名字 %@",one.bank];
    self.cardNumber.text = [NSString stringWithFormat:@"银行卡号 %@",one.cardNumber];
    self.trueName.text = [NSString stringWithFormat:@"持卡人 %@",one.trueName];
    self.memo.text = [NSString stringWithFormat:@"备注%@",one.memo];
    self.state.text = [NSString stringWithFormat:@"状态%@",one.state];
}
@end
