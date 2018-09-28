//
//  LBMainRootCell.m
//  Core
//
//  Created by mac on 2017/9/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LBMainRootCell.h"
@interface LBMainRootCell ()
@property (nonatomic, strong)UIImageView *iconImageView;
@property (nonatomic, strong)UILabel *textLabel;
@property(nonatomic, strong)UIButton *numButton;

@end
@implementation LBMainRootCell

-(void)setLiveModel:(LBGetLivePlatModel *)liveModel{
    
    if([liveModel.livePlatThumb rangeOfString:@"http"].location !=NSNotFound){
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:liveModel.livePlatThumb] placeholderImage:[UIImage imageNamed:@"ys_channel_defult_up"]];
    }else{
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageHead,liveModel.livePlatThumb]] placeholderImage:[UIImage imageNamed:@"ys_channel_defult_up"]];
    }
    
    self.textLabel.text = liveModel.livePlatTitle;
    
    self.numButton.hidden = NO;

    [self.numButton setTitle:liveModel.anchorCount forState:0];

    CGFloat numButtonWidth = [self.numButton.titleLabel.text boundingRectWithSize:CGSizeMake(self.width, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:nil context:nil].size.width+30;
    self.numButton.width = numButtonWidth;
}

-(void)setAnchorModel:(LBAnchorListModel *)anchorModel{
    
    self.numButton.hidden = YES;
    
    if([anchorModel.anchorThumb rangeOfString:@"http"].location !=NSNotFound){
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:anchorModel.anchorThumb] placeholderImage:[UIImage imageNamed:@"ys_channel_defult_up"]];
    }else{
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageHead,anchorModel.anchorThumb]] placeholderImage:[UIImage imageNamed:@"ys_channel_defult_up"]];
    }
    

    
    self.textLabel.text = anchorModel.anchorName;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGFloat leftPading = 10;

        UIImageView *iconImageView = [UIImageView new];
        iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        iconImageView.clipsToBounds = YES;
        [self addSubview:(self.iconImageView=iconImageView)];
        iconImageView.frame = CGRectMake(leftPading, leftPading, frame.size.width-leftPading*2, frame.size.height-20-leftPading*2);
        iconImageView.layer.cornerRadius = 5;

        
        
        UILabel *textLabel = [UILabel new];
        textLabel.font = CustomUIFont(14);
        textLabel.textColor = [UIColor blackColor];
        [self  addSubview:(self.textLabel=textLabel)];
        textLabel.frame = CGRectMake(0, iconImageView.bottom, self.width, frame.size.height-iconImageView.bottom);
        textLabel.textAlignment = 1;
        
        
        UIButton *numButton = [UIButton buttonWithType:0];
        [numButton setImage:[UIImage imageNamed:@"直播数量"] forState:0];
        [numButton setTitleColor:[UIColor whiteColor] forState:0];
        numButton.titleLabel.font = CustomUIFont(12);
        [self addSubview:(self.numButton=numButton)];
        numButton.backgroundColor = CustomColor(33, 142, 27, 1);
        numButton.frame = CGRectMake(0, 0, 40, 20);
    }
    return self;
}
@end
