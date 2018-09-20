//
//  PlaceholderTextView.h
//  readchen
//
//  Created by readchen on 15/11/5.
//  Copyright © 2015年 readchen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceholderTextView : UITextView
@property (nonatomic, strong)UIColor *placeholderColor;
@property(strong,nonatomic) UIFont * placeholderFont;
@property(copy,nonatomic) NSString *placeholder;
@end
