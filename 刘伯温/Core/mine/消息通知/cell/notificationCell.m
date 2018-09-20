//
//  notificationCell.m
//  Core
//
//  Created by heiguohua on 2018/9/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "notificationCell.h"
#import "Masonry.h"
#import "Header.h"

@interface notificationCell ()
@property (nonatomic,weak) UILabel *title;
@property (nonatomic,weak) UILabel *time;
@property (nonatomic,weak) UIView *line;

@end

@implementation notificationCell

+ (instancetype)returnCellWith:(UITableView *)tableView
{
    notificationCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (cell == nil) {
        cell = [[notificationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 2;
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        label.textColor = [UIColor colorWithRed:30/255.0 green:46/255.0 blue:71/255.0 alpha:1/1.0];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView).offset(-15);
        }];
        self.title = label;
        
        UILabel *time = [[UILabel alloc] init];
        time.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        time.textColor = [UIColor darkTextColor];
        [self.contentView addSubview:time];
        [time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.title.mas_bottom).offset(10);
            make.right.equalTo(self.contentView).offset(-15);
        }];
        self.time = time;
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor =BackGroundColor;
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.time.mas_bottom).offset(10);
            make.bottom.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-15);
            make.height.equalTo(@0.5);
        }];
        self.time = time;
    }
    return self;
}

- (void)setOne:(msgOne *)one{
    _one = one;
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc]
                                           initWithData:[one.msg dataUsingEncoding:
                                                         NSUnicodeStringEncoding]
                                           options:@{
                                                     NSDocumentTypeDocumentAttribute:
                                                         NSHTMLTextDocumentType
                                                     }
                                           documentAttributes:nil error:nil];
    self.title.text = [attrStr string];
    self.time.text = one.createTime;
}
@end
