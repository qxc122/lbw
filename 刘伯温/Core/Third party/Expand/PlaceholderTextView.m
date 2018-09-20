//
//  PlaceholderTextView.m
//  readchen
//
//  Created by readchen on 15/11/5.
//  Copyright © 2015年 readchen. All rights reserved.
//

#import "PlaceholderTextView.h"
@interface PlaceholderTextView()<UITextViewDelegate>
{
    UILabel *PlaceholderLabel;
}
@end
@implementation PlaceholderTextView



- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DidChange:) name:UITextViewTextDidChangeNotification object:self];
        
        float left=5,top=2,hegiht=30;
    
        self.placeholderColor = CustomColor(160, 160, 160,1);
        PlaceholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(left, top, self.frame.size.width-2*left, hegiht)];
        PlaceholderLabel.font=self.placeholderFont?self.placeholderFont:self.font;
        PlaceholderLabel.textColor = self.placeholderColor;
        [self addSubview:PlaceholderLabel];
        PlaceholderLabel.numberOfLines = 2;
        PlaceholderLabel.text=self.placeholder;
        }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    float left=5,top=2,hegiht=30;
    PlaceholderLabel.frame = CGRectMake(left, top, self.frame.size.width-2*left, hegiht);
}


-(void)setPlaceholder:(NSString *)placeholder{
    if (placeholder.length == 0 || [placeholder isEqualToString:@""]) {
        PlaceholderLabel.hidden=YES;
    }else{
        PlaceholderLabel.text= placeholder;
    }
    _placeholder=placeholder;
    
}
-(void)setFont:(UIFont *)font
{
    [super setFont:font];
    PlaceholderLabel.font = font;
}

-(void)setPlaceholderFont:(UIFont *)placeholderFont
{
    _placeholderFont = placeholderFont;
    PlaceholderLabel.font = placeholderFont;
    
}

-(void)setText:(NSString *)text
{
    [super setText:text];

    [self DidChange:nil];
    
}

-(void)DidChange:(NSNotification*)noti{
    
    if (self.placeholder.length == 0 || [self.placeholder isEqualToString:@""]) {
        PlaceholderLabel.hidden=YES;
    }
    
    if (self.text.length > 0) {
        PlaceholderLabel.hidden = YES;
    }
    else{
        PlaceholderLabel.hidden = NO;
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [PlaceholderLabel removeFromSuperview];
}

@end
