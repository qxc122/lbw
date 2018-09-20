//
//  LBMainTootHeadView.m
//  Core
//
//  Created by mac on 2017/9/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "LBMainTootHeadView.h"
#import "CRImageTool.h"
#import "CRSearchBar.h"
#import "SDCycleScrollView.h"
#import "LBShowRemendView.h"
#import "LBLoginViewController.h"
@interface LBMainTootHeadView ()<UISearchBarDelegate,SDCycleScrollViewDelegate>
@property (nonatomic, strong)UIButton *tempButton;
@property(nonatomic, strong)UILabel *lineLabel;
@property(nonatomic, strong)UIImageView *textImageView;
@property(nonatomic, strong)UIView *topView;
@property(nonatomic, strong)UIView *sectionView;
@property(nonatomic, strong)SDCycleScrollView *scrollView;
@end
@implementation LBMainTootHeadView

-(void)setGetAdvListArr:(NSArray *)getAdvListArr{
    _getAdvListArr = getAdvListArr;
    NSMutableArray *advImageUrlArr = [NSMutableArray array];
    for (LBGetAdvListModel *model in _getAdvListArr) {
        if ([model.advImageUrl rangeOfString:@"http"].location ==NSNotFound){
            model.advImageUrl = [NSString stringWithFormat:@"%@%@",ImageHead,model.advImageUrl];
        }
        if([model.advType isEqualToString:@"1"]){
            [advImageUrlArr addObject:model.advImageUrl];
        }
    }
    self.scrollView.imageURLStringsGroup = advImageUrlArr;
}


-(instancetype)initWithFrame:(CGRect)frame andSelectIndex:(NSInteger)selectIndex{
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = BackGroundColor;
        
        
        SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kFullWidth, adjuctFloat(150)) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        [self addSubview:(self.scrollView=cycleScrollView2)];
        
        
        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, self.scrollView.bottom, frame.size.width, 60)];
        sectionView.backgroundColor = [UIColor whiteColor];
        [self addSubview:(self.sectionView=sectionView)];
        
        
        UIImageView *hornImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
        hornImageView.image = [UIImage imageNamed:@"喇叭"];
        [sectionView addSubview:hornImageView];
        
        CGFloat buttonWidth = 80;
        NSArray *arr = @[@"推荐主播",@"直播平台",@"我的关注"];
        for (int i =0; i <arr.count; i ++) {
            UIButton *button = [UIButton buttonWithType:0];
            [button setTitle:arr[i] forState:0];
            button.tag = i;
            button.frame = CGRectMake(i*buttonWidth, hornImageView.bottom-5, buttonWidth, sectionView.height-20);
            [button setTitleColor:[UIColor blackColor] forState:0];
            button.titleLabel.font = CustomUIFont(15);
            [button addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
            [sectionView addSubview:button];
            if (i ==selectIndex){
                self.tempButton = button;
                [self.tempButton setTitleColor:SecondColor forState:0];
                UILabel *lineLabel = [UILabel new];
                lineLabel.backgroundColor = SecondColor;
                [sectionView  addSubview:(self.lineLabel = lineLabel)];
                lineLabel.frame = CGRectMake(4, sectionView.height-5, button.width-8, 2);
                lineLabel.centerX = button.centerX;
            }
        }

        LBGetVerCodeModel *data =  [NSKeyedUnarchiver unarchiveObjectWithFile:PATH_base];
        if (data) {
            [self setPaoMaDeng];
        }else{
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(setPaoMaDeng)
                                                         name:@"getBaseConfigSuccess"
                                                       object:nil];
        }
    }
    return self;
}

- (void)setPaoMaDeng{
    if (!self.maView) {
        LBGetVerCodeModel *data =  [NSKeyedUnarchiver unarchiveObjectWithFile:PATH_base];
        LSPaoMaView *maView = [[LSPaoMaView alloc] initWithFrame:CGRectMake(30, 5, kFullWidth-30, 20) title:data.msg];
        self.maView = maView;
        maView.backgroundColor = [UIColor clearColor];
        [self.sectionView addSubview:(self.maView=maView)];
    }
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    LBGetAdvListModel *model = _getAdvListArr[index];
    if (   [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:model.linkUrl]]) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:model.linkUrl]];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    if (self.clickSearchBlock){
        self.clickSearchBlock();
    }
    return NO;
}

- (void)buttonTarget:(UIButton *)button{
    if (button.tag == 2 && !ISLOGIN) {
        [LBShowRemendView showRemendViewText:@"您还没有登录，请先登录" andTitleText:@"提示" andEnterText:@"确定" andEnterBlock:^{
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [window removeAllSubviews];
            window = nil;
            LBLoginViewController *vc = [[LBLoginViewController alloc] initWithNibName:@"LBLoginViewController" bundle:nil];
            LBNavigationController *nav = [[LBNavigationController alloc]initWithRootViewController:vc];
            [UIApplication sharedApplication].keyWindow.rootViewController = nav;
        }];
        return;
    }
    [self.tempButton setTitleColor:[UIColor blackColor] forState:0];
    self.tempButton = button;
    [self.tempButton setTitleColor:MainColor forState:0];
    
    WeakSelf
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.lineLabel.centerX = button.centerX;
    }];
 
    if (self.selectIndexBlock){
        self.selectIndexBlock(button.tag);
    }
}

@end
