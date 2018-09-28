//
//  ChatRecordCell.m
//  Core
//
//  Created by heiguohua on 2018/9/12.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ChatRecordCell.h"
#import "Masonry.h"
#import "Header.h"

@interface ChatRecordCell ()
@property (nonatomic,weak) UILabel *title;
@property (nonatomic,weak) UILabel *time;
@property (nonatomic,weak) UIView *back;
@end

@implementation ChatRecordCell

+ (instancetype)returnCellWith:(UITableView *)tableView
{
    ChatRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (cell == nil) {
        cell = [[ChatRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UILabel *back = [[UILabel alloc] init];
        back.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [self.contentView addSubview:back];
        self.back = back;
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
        label.textColor = [UIColor orangeColor];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.contentView).offset(5);
            make.bottom.equalTo(self.contentView).offset(-5);
            make.centerY.equalTo(self.contentView);
//            make.width.equalTo(@60);
        }];
        self.title = label;

        
        UILabel *time = [[UILabel alloc] init];
        time.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
        time.textColor = [UIColor whiteColor];
        [self.contentView addSubview:time];
        [time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.title.mas_right).offset(10);
//            make.right.equalTo(self.contentView).offset(-100);
            make.top.equalTo(self.title);
            make.bottom.equalTo(self.title);
            make.centerY.equalTo(self.contentView);
            make.width.mas_lessThanOrEqualTo(@(SCREENWIDTH -  self.title.width - 35));
        }];
        self.time = time;
        [back mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.time).offset(8);
            make.left.equalTo(self.title).offset(-8);
            make.top.equalTo(self.time).offset(-0);
            make.bottom.equalTo(self.time).offset(0);
        }];
        back.layer.cornerRadius = 15/2.0;
        back.layer.masksToBounds = YES;
        
        [self.title setContentHuggingPriority:UILayoutPriorityRequired
                                  forAxis:UILayoutConstraintAxisHorizontal];
        [self.time setContentHuggingPriority:UILayoutPriorityDefaultLow
                                  forAxis:UILayoutConstraintAxisHorizontal];
    }
    return self;
}


- (void)setOneMsg:(id)oneMsg{
    _oneMsg = oneMsg;
    if ([oneMsg isKindOfClass:[JMSGMessage class]]) {
        JMSGMessage *tmp = (JMSGMessage *)oneMsg;
        if (tmp.fromName && tmp.fromName.length) {
            self.title.text = [NSString stringWithFormat:@"%@：",tmp.fromName];
        } else {
            self.title.text = @"✔：";
        }
        self.time.text = ((JMSGTextContent *)tmp.content).text;
    }else{
        self.title.text = nil;
        self.time.text = nil;
    }
}
- (void)setOne:(chatRecodOne *)one{
    _one = one;
    if (one.name && one.name.length) {
        self.title.text = [NSString stringWithFormat:@"%@：",one.name];
    } else {
        self.title.text = @"✔：";
    }
    self.time.text = one.msg;
}
@end
