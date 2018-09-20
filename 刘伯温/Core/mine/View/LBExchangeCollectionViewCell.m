//
//  LBExchangeCollectionViewCell.m
//  Core
//
//  Created by mac on 2017/11/12.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LBExchangeCollectionViewCell.h"
@interface LBExchangeCollectionViewCell ()
@property (nonatomic,strong)UIImageView *backImageView;
@property(nonatomic, strong)UILabel *nameLabel;
@property(nonatomic, strong)UILabel *stateLabel;
@property(nonatomic, strong)UILabel *goldNunLabel;
@property(nonatomic, strong)UILabel *timeLabel;

@end
@implementation LBExchangeCollectionViewCell

-(void)setModel:(LBExchangeModel *)model{
    if([model.goodsThumb rangeOfString:@"http"].location !=NSNotFound){
        [self.backImageView sd_setImageWithURL:[NSURL URLWithString:model.goodsThumb] placeholderImage:[UIImage imageNamed:@"ys_channel_defult_up"]];
    }else{
        [self.backImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageHead,model.goodsThumb]] placeholderImage:[UIImage imageNamed:@"ys_channel_defult_up"]];
    }
    
    self.nameLabel.text = model.goodsName;
    if ([model.status intValue] ==1){
        self.stateLabel.text = @"已经邮寄出去";
    }else{
        self.stateLabel.text = @"正在处理";
    }
    
    self.goldNunLabel.text = [NSString stringWithFormat:@"消费：%@",model.xfIntegral];
    
    self.timeLabel.text = model.createTime;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGFloat leftPading = 10;
        CGFloat cellW = (kFullWidth-leftPading*2)/2;
        
        
        self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(leftPading, leftPading, cellW-leftPading*2, cellW-leftPading*2)];
        self.backImageView.userInteractionEnabled = YES;
        [self addSubview:self.backImageView];
        
        
        
        self.nameLabel = [UILabel new];
        self.nameLabel.font = CustomUIFont(14);
        self.nameLabel.textColor = [UIColor lightGrayColor];
        [self  addSubview:self.nameLabel];
        self.nameLabel.frame = CGRectMake(self.backImageView.left, self.backImageView.bottom+leftPading, self.backImageView.width, 20);
        
        self.stateLabel = [UILabel new];
        self.stateLabel.font = CustomUIFont(12);
        self.stateLabel.textColor = [UIColor redColor];
        [self  addSubview:self.stateLabel];
        self.stateLabel.frame = CGRectMake(self.nameLabel.left, self.nameLabel.bottom, self.nameLabel.width, self.nameLabel.height);

        
        self.goldNunLabel = [UILabel new];
        self.goldNunLabel.font = CustomUIFont(12);
        self.goldNunLabel.textColor = [UIColor lightGrayColor];
        [self  addSubview:self.goldNunLabel];
        self.goldNunLabel.frame = CGRectMake(self.nameLabel.left, self.stateLabel.bottom, self.nameLabel.width, self.nameLabel.height);

        self.timeLabel = [UILabel new];
        self.timeLabel.font = CustomUIFont(12);
        self.timeLabel.textColor = [UIColor lightGrayColor];
        [self  addSubview:self.timeLabel];
        self.timeLabel.frame = CGRectMake(self.nameLabel.left, self.goldNunLabel.bottom, self.nameLabel.width, self.nameLabel.height);

    }
    return self;
}
@end
