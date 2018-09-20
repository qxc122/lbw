//
//  LBMainTootHeadView.h
//  Core
//
//  Created by mac on 2017/9/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSPaoMaView.h"

@interface LBMainTootHeadView : UIView
@property(nonatomic, strong)LSPaoMaView *maView;

@property (nonatomic, strong)void(^selectIndexBlock)(NSInteger index);
@property(nonatomic, strong)NSArray *getAdvListArr;
-(instancetype)initWithFrame:(CGRect)frame andSelectIndex:(NSInteger)selectIndex;
@property (nonatomic, strong)void(^clickSearchBlock)();

@property (nonatomic, strong)void(^clickBannerBlock)(NSString *linkUrl);
@end
