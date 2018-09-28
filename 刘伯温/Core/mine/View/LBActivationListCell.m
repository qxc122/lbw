//
//  LBActivationListCell.m
//  Core
//
//  Created by mac on 2017/10/1.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LBActivationListCell.h"
@interface LBActivationListCell ()
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end
@implementation LBActivationListCell
-(void)setModel:(LBGetActivationCardListModel *)model{
    self.numberLabel.text = model.cardNumber;
    self.timeLabel.text = model.saleTime;
    if ([model.vipType intValue] ==0){
        self.imageView.image = [UIImage imageNamed:@"月会员-高亮"];
        self.longLabel.text = @"点卡时长：30天";
    }else if ([model.vipType intValue] ==1){
        self.longLabel.text = @"点卡时长：90天";
        self.imageView.image = [UIImage imageNamed:@"季会员-高亮"];
    }else if ([model.vipType intValue] ==2){
        self.longLabel.text = @"点卡时长：180天";
        self.imageView.image = [UIImage imageNamed:@"半年会员-高亮"];
    }else if ([model.vipType intValue] ==3){
        self.longLabel.text = @"点卡时长：365天";
        self.imageView.image = [UIImage imageNamed:@"年会员-高亮"];

    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
