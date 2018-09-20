//
//  LBGiftStoreCollectionViewCell.m
//  Core
//
//  Created by mac on 2017/11/11.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LBGiftStoreCollectionViewCell.h"
#import "UIButton+SSEdgeInsets.h"

@interface LBGiftStoreCollectionViewCell ()
@property (nonatomic,strong)UIImageView *backImageView;
@property(nonatomic, strong)UILabel *goodsLabel;
@property(nonatomic, strong)UILabel *goldsLabel;
@property(nonatomic, strong)UILabel *numLabel;
@property(nonatomic, strong)UIButton *likeLabel;
@property(nonatomic, strong)UIButton *buyButton;

@end
@implementation LBGiftStoreCollectionViewCell

-(void)setListModel:(LBGetGoodsListModel *)listModel{
    if([listModel.goodsThumb rangeOfString:@"http"].location !=NSNotFound){
        [self.backImageView sd_setImageWithURL:[NSURL URLWithString:listModel.goodsThumb] placeholderImage:[UIImage imageNamed:@"ys_channel_defult_up"]];
    }else{
        [self.backImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageHead,listModel.goodsThumb]] placeholderImage:[UIImage imageNamed:@"ys_channel_defult_up"]];
    }
    
    self.goodsLabel.text = listModel.goodsName;
    
    self.goldsLabel.text = [NSString stringWithFormat:@"%@金币",listModel.needIntegral];
    self.numLabel.text = [NSString stringWithFormat:@"库存：%@件",listModel.goodsInventory];
    
    [self.likeLabel setTitle:listModel.goodsBayCount forState:0];;

    
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGFloat leftPading = 10;
        
        CGFloat cellW = (kFullWidth-leftPading*2)/2;
        self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(leftPading, leftPading, cellW-leftPading*2, cellW/3*2)];
//        self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.backImageView.userInteractionEnabled = YES;
        [self addSubview:self.backImageView];
        
        
        self.goodsLabel = [UILabel new];
        self.goodsLabel.font = CustomUIFont(15);
        self.goodsLabel.textColor = MainColor;
        [self  addSubview:self.goodsLabel];
        self.goodsLabel.frame = CGRectMake(0, self.backImageView.bottom+leftPading, self.backImageView.width, 20);
        self.goodsLabel.textAlignment = 1;
        
        self.goldsLabel = [UILabel new];
        self.goldsLabel.font = CustomUIFont(13);
        self.goldsLabel.textColor = [UIColor redColor];
        [self  addSubview:self.goldsLabel];
        self.goldsLabel.frame = CGRectMake(leftPading, self.goodsLabel.bottom+leftPading, self.backImageView.width/4*3, 20);
        
        self.numLabel = [UILabel new];
        self.numLabel.font = CustomUIFont(13);
        self.numLabel.textColor = [UIColor lightGrayColor];
        [self  addSubview:self.numLabel];
        self.numLabel.frame = CGRectMake(leftPading, self.goldsLabel.bottom, self.goldsLabel.width, self.goldsLabel.height);
        
        self.likeLabel = [UIButton new];
        self.likeLabel.titleLabel.font = CustomUIFont(13);
        [self.likeLabel setTitleColor:[UIColor lightGrayColor] forState:0];
        [self  addSubview:self.likeLabel];
        self.likeLabel.frame = CGRectMake(leftPading, self.numLabel.bottom, 30, self.goldsLabel.height);
        [self.likeLabel setImage:[UIImage imageNamed:@"ic_link"] forState:0];
        [self.likeLabel.titleLabel sizeToFit];

        self.buyButton = [UIButton buttonWithType:0];
        [self.buyButton setTitle:@"兑换" forState:0];
        [self.buyButton setTitleColor:MainColor forState:0];
        self.buyButton.titleLabel.font = CustomUIFont(14);
        [self.buyButton addTarget:self action:@selector(buyButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.buyButton];
        [self.buyButton setImage:[UIImage imageNamed:@"ic_buy"] forState:0];
        self.buyButton.frame = CGRectMake(cellW-50, self.goldsLabel.bottom, 50, 50);
        [self.buyButton setImagePositionWithType:SSImagePositionTypeTop spacing:3];
    }
    return self;
}

- (void)buyButtonClick{
    if (self.buyButtonBlock){
        self.buyButtonBlock();
    }
}


@end
