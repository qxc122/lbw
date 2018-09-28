//
//  bankCell.m
//  Core
//
//  Created by heiguohua on 2018/9/11.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "bankCell.h"
#import "Masonry.h"
#import "Header.h"

@interface bankCell ()
@property (nonatomic,weak) UILabel *bankType;
@property (nonatomic,weak) UILabel *cardNumber;

@property (nonatomic,weak) UILabel *trueName;
@property (nonatomic,weak) UILabel *state;

@property (nonatomic,weak) UILabel *phone;

@property (nonatomic,weak) UIView *line;

@end

@implementation bankCell

+ (instancetype)returnCellWith:(UITableView *)tableView
{
    bankCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (cell == nil) {
        cell = [[bankCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *bankType = [[UILabel alloc] init];
        self.bankType = bankType;
        [self.contentView addSubview:bankType];
        
        UILabel *cardNumber = [[UILabel alloc] init];
        self.cardNumber = cardNumber;
        [self.contentView addSubview:cardNumber];
        
        UILabel *trueName = [[UILabel alloc] init];
        self.trueName = trueName;
        [self.contentView addSubview:trueName];
        
        UILabel *state = [[UILabel alloc] init];
        self.state = state;
        [self.contentView addSubview:state];
        
        UILabel *phone = [[UILabel alloc] init];
        self.phone = phone;
        [self.contentView addSubview:phone];
        
        
        
        [bankType mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.contentView).offset(10);
        }];
        [cardNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15);
            make.centerY.equalTo(self.bankType);
        }];

        [trueName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bankType);
            make.top.equalTo(self.bankType.mas_bottom).offset(10);
        }];
        [state mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15);
            make.centerY.equalTo(self.trueName);
        }];
        [phone mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bankType);
            make.right.equalTo(self.contentView).offset(-15);
            make.top.equalTo(self.trueName.mas_bottom).offset(10);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        }];
        
        bankType.font = [UIFont systemFontOfSize:15];
        bankType.textColor = [UIColor darkTextColor];
        
        cardNumber.font = [UIFont systemFontOfSize:15];
        cardNumber.textColor = [UIColor darkTextColor];
        
        trueName.font = [UIFont systemFontOfSize:15];
        trueName.textColor = [UIColor darkTextColor];
        
        state.font = [UIFont systemFontOfSize:15];
        state.textColor = [UIColor darkTextColor];
        
        phone.font = [UIFont systemFontOfSize:15];
        phone.textColor = [UIColor darkTextColor];
        
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor =BackGroundColor;
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.bottom.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-15);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}

- (void)setOne:(bankOne *)one{
    _one = one;
    self.bankType.text = one.bankType;
    self.cardNumber.text = one.cardNumber;
    self.trueName.text = one.trueName;
    self.state.text = one.state;
    self.phone.text = one.phone;
}
@end
