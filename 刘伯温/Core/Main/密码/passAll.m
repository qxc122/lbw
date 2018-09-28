//
//  passAll.m
//  Core
//
//  Created by heiguohua on 2018/9/27.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "passAll.h"
#import "passWordView.h"
#import "UIView+WHC_ViewProperty.h"
#import "WHC_PswInputView.h"
#import "WHC_NumberPlateView.h"
#import "WHC_GestureDragPlateView.h"
#import "LBLoginViewController.h"

#define heightLabelPassLabel  (23.0)
#define heightLabelPass  (0.0)
#define bottomSpace  (5)
//#define KWHC_BackStartColor          ((id)[UIColor colorWithRed:56.0 / 255.0 green:34.0 / 255.0 blue:80.0 / 255.0 alpha:1.0].CGColor)
//#define KWHC_BackEndColor            ((id)[UIColor colorWithRed:56.0 / 255.0 green:34.0 / 255.0 blue:36.0 / 255.0 alpha:1.0].CGColor)

#define KWHC_BackStartColor          ((id)[UIColor colorWithRed:80.0 / 255.0 green:166.0 / 255.0 blue:242.0 / 255.0 alpha:1.0].CGColor)
#define KWHC_BackEndColor            ((id)[UIColor colorWithRed:169.0 / 255.0 green:202.0 / 255.0 blue:238.0 / 255.0 alpha:1.0].CGColor)

#define KWHC_InputPswLabY            (30.0)               //输入密码标签y坐标
#define KWHC_InputPswLabHeight       (30.0)               //输入密码标签高度
#define KWHC_BottomHeight            (40.0)               //底部高度
#define KWHC_DelBtnWidth             (60.0)               //删除按钮宽度
#define KWHC_Iphone4Height           (480.0)              //iphone4高度

#define KWHC_inputOldPswLabTxt       (@"请输入旧密码")
#define KWHC_inputNewPswLabTxt       (@"请输入新密码")
#define KWHC_inputOldGestureLabTxt   (@"请输入旧手势")
#define KWHC_inputNewGestureLabTxt   (@"请输入新手势")

#define KWHC_InputPswLabTxt          (@"请输入密码")        //输入密码标签文字
#define KWHC_InputPswLabAgTxt        (@"请再次输入密码")     //输入密码标签文字
#define KWHC_InputPswLabReTxt        (@"请重新输入密码")     //输入密码标签文字
#define KWHC_InputPswLabGestureTxt   (@"请输入手势")         //输入密码标签文字
#define KWHC_InputPswLabGestureAgTxt (@"请再次输入手势")      //输入密码标签文字
#define KWHC_InputPswLabGestureReTxt (@"请重新输入手势")      //输入密码标签文字
#define KWHC_UnlockSuccessTxt        (@"正在进入系统")       //解锁成功提示
#define KWHC_SetUnlockSuccessTxt     (@"设置密码成功")       //解锁成功提示
#define KWHC_DelBtnTxt               (@"删除")             //删除按钮文字
#define KWHC_CancelBtnTxt            (@"忘记密码？")             //取消按钮文字
#define KWHC_ConfigurationKey        (@"ConfigurationKey")//配置信息key
#define KWHC_SetStateKey             (@"SetStateKey")     //状态key
#define KWHC_PswKey                  (@"PswKey")          //密码key



@interface passAll ()<WHC_NumberPlateViewDelegate , WHC_GestureDragPlateViewDelegate>{
    NSMutableString             * _pswOnce;               //第一次密码
    NSMutableString             * _pswTwo;                //第二次密码
    NSString                    * _modifyPsw;             //修改的密码
    NSString                    * _didSavePsw;            //已经存储的密码
    UILabel                     * _inputPswLab;           //输入密码提示标签
    WHC_PswInputView            * _pswInputView;          //密码输入视图
    WHC_GestureDragPlateView    * _gestureInputView;      //手势密码输入视图
    passWordView         * _numberPlateView;       //数字按钮视图
    UIButton                    * _delBtn;                //删除按钮
    UIButton                    * _cancelBtn;             //取消按钮
    CAGradientLayer             * _defaultBackgroudLayer; //默认背景层
    BOOL                          _setState;              //设置状态
    BOOL                          _isAgainSetPsw;         //是否再次设置密码
    BOOL                          _isModifyPassword;      //是否修改密码
    BOOL                          _isRemovePassword;      //是否删除密码
}
@property (nonatomic , assign)WHCGestureUnlockType unlockType;
@end

@implementation passAll

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.unlockType = ClickNumberType;
        
        
        [self readConfigurationInfo];
        
        _inputPswLab = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0, self.width, heightLabelPassLabel)];
        _inputPswLab.backgroundColor = [UIColor clearColor];
        _inputPswLab.textAlignment = NSTextAlignmentCenter;
        if(_isModifyPassword){
            _inputPswLab.text = KWHC_inputOldPswLabTxt;
        }else{
            _inputPswLab.text = KWHC_InputPswLabTxt;
        }
        _inputPswLab.textColor = [UIColor whiteColor];
        [self addSubview:_inputPswLab];
        _inputPswLab.hidden = YES;
        
        _pswInputView = [[WHC_PswInputView alloc]initWithFrame:CGRectMake(0.0, 0, self.width, heightLabelPassLabel)];
        [self addSubview:_pswInputView];
        
        
        _numberPlateView =  [[passWordView alloc] initWithFrame:CGRectMake(frame.origin.x,heightLabelPass+heightLabelPassLabel, frame.size.width, frame.size.height-heightLabelPass-bottomSpace-heightLabelPassLabel)];
        _numberPlateView.delegate = self;
        [self addSubview:_numberPlateView];
        
        
        _delBtn = [self createButtonWithFrame:CGRectMake(self.width - KWHC_DelBtnWidth * 1.5, self.height - KWHC_BottomHeight, KWHC_DelBtnWidth, KWHC_BottomHeight) txt:KWHC_DelBtnTxt];
        [_delBtn addTarget:self action:@selector(clickDelBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_delBtn];
        
//        if (_didSavePsw) {
            //    if(_setState || _isModifyPassword || _isRemovePassword){
            _cancelBtn = [self createButtonWithFrame:CGRectMake(KWHC_DelBtnWidth / 2.0, self.height - KWHC_BottomHeight, KWHC_DelBtnWidth+30, KWHC_BottomHeight) txt:KWHC_CancelBtnTxt];
            [_cancelBtn addTarget:self action:@selector(clickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_cancelBtn];
//        }
        

        
        
        CAGradientLayer *defaultBackgroudLayer = [CAGradientLayer layer];
        defaultBackgroudLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        defaultBackgroudLayer.colors = @[KWHC_BackStartColor,KWHC_BackEndColor];
        defaultBackgroudLayer.locations = @[@(0.0),@(1.0)];
        [self.layer insertSublayer:defaultBackgroudLayer atIndex:0];
        
        [self initData];
    }
    return self;
}


- (void)initData{
    _pswOnce = [NSMutableString string];
    _pswTwo = [NSMutableString string];
}


- (void)readConfigurationInfo{
    NSUserDefaults   * ud = [NSUserDefaults standardUserDefaults];
    NSDictionary  * dict = [ud objectForKey:KWHC_ConfigurationKey];
    if(dict && dict.count > 0){
        NSDictionary  * typeDict = dict[@(_unlockType).stringValue];
        if(typeDict && typeDict.count > 0){
            _setState = [typeDict[KWHC_SetStateKey] boolValue];
            _setState = !_setState;
            _didSavePsw = typeDict[KWHC_PswKey];
        }else{
            _setState = YES;
            _didSavePsw = @"";
        }
    }else{
        _setState = YES;
        _didSavePsw = @"";
    }
}

- (void)setModifyPasswordState:(BOOL)state{
    _isModifyPassword = state;
}

- (void)setRemoveGesturePassword:(BOOL)state{
    _isRemovePassword = state;
}

- (void)saveConfigurationInfo{
    NSString  * gesturePsw = nil;
    if(_isModifyPassword){
        gesturePsw = _modifyPsw;
    }else{
        gesturePsw = _pswOnce;
    }
    _setState = YES;
    NSUserDefaults  * ud = [NSUserDefaults standardUserDefaults];
    NSDictionary    * dict = @{@(_unlockType).stringValue:@{KWHC_SetStateKey:@(_setState),KWHC_PswKey:gesturePsw}};
    [ud setObject:dict forKey:KWHC_ConfigurationKey];
    [ud synchronize];
}

- (UIButton *)createButtonWithFrame:(CGRect)frame txt:(NSString *)txt{
    UIButton  * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.backgroundColor = [UIColor clearColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [btn setTitle:txt forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return btn;
}


- (void)clickDelBtn:(UIButton *)sender{
    [_pswInputView clearPswCircle];
    [_numberPlateView decClickCount];
    if(_pswOnce.length > 0) {
        [_pswOnce deleteCharactersInRange:NSMakeRange(_pswOnce.length - 1, 1)];
    }
}

- (void)clickCancelBtn:(UIButton *)sender{
    if (self.forgetPassWord) {
        self.forgetPassWord();
    }
}

#pragma mark - WHC_NumberPlateViewDelegate
- (void)WHC_NumberPlateView:(WHC_NumberPlateView *)numberPlateView clickIndex:(NSInteger)index  didFinish:(BOOL)finish{
    if(_isAgainSetPsw){
        [_pswTwo appendString:@(index).stringValue];
    }else{
        [_pswOnce appendString:@(index).stringValue];
    }
    if(finish){
        __weak typeof(self)  sf = self;
        [_pswInputView addPswCircleFinish:^{
            if(_isAgainSetPsw){
                if(_isModifyPassword){
                    if(_modifyPsw){
                        if([_pswTwo isEqualToString:_modifyPsw]){
                            _inputPswLab.text = KWHC_SetUnlockSuccessTxt;
                            [_pswInputView clearAllPswCircle];
                            [sf saveConfigurationInfo];
                            [self removeFromSuperview];
                        }else{
                            [_pswInputView showMistakeMsg];
                            [_numberPlateView clearClickCount];
                            if(_isModifyPassword){
                                _inputPswLab.text = KWHC_inputOldPswLabTxt;
                            }else{
                                _inputPswLab.text = KWHC_InputPswLabTxt;
                            }
                            _modifyPsw = nil;
                            [_pswOnce deleteCharactersInRange:NSMakeRange(0, _pswOnce.length)];
                            [_pswTwo deleteCharactersInRange:NSMakeRange(0, _pswTwo.length)];
                            _isAgainSetPsw = NO;
                        }
                    }else{
                        _modifyPsw = _pswTwo.copy;
                        [_pswInputView clearAllPswCircle];
                        [_numberPlateView clearClickCount];
                        _inputPswLab.text = KWHC_InputPswLabTxt;
                        [_pswOnce deleteCharactersInRange:NSMakeRange(0, _pswOnce.length)];
                        [_pswTwo deleteCharactersInRange:NSMakeRange(0, _pswTwo.length)];
                    }
                }else{
                    if([_pswTwo isEqualToString:_pswOnce]){
                        _inputPswLab.text = KWHC_SetUnlockSuccessTxt;
                        [_pswInputView clearAllPswCircle];
                        [sf saveConfigurationInfo];
                        [self removeFromSuperview];
                    }else{
                        [_pswInputView showMistakeMsg];
                        [_numberPlateView clearClickCount];
                        if(_isModifyPassword){
                            _inputPswLab.text = KWHC_inputOldPswLabTxt;
                        }else{
                            _inputPswLab.text = KWHC_InputPswLabTxt;
                        }
                        [_pswOnce deleteCharactersInRange:NSMakeRange(0, _pswOnce.length)];
                        [_pswTwo deleteCharactersInRange:NSMakeRange(0, _pswTwo.length)];
                        _isAgainSetPsw = NO;
                    }
                }
            }else{
                if(_setState || _isModifyPassword){
                    _isAgainSetPsw = YES;
                    if(_isModifyPassword){
                        if([_didSavePsw isEqualToString:_pswOnce]){
                            _inputPswLab.text = KWHC_inputNewPswLabTxt;
                        }else{
                            _isAgainSetPsw = NO;
                            [_pswInputView showMistakeMsg];
                            _inputPswLab.text = KWHC_inputOldPswLabTxt;
                            [_pswOnce deleteCharactersInRange:NSMakeRange(0, _pswOnce.length)];
                        }
                    }else{
                        _inputPswLab.text = KWHC_InputPswLabAgTxt;
                        [MBProgressHUD showPrompt:KWHC_InputPswLabAgTxt];
                    }
                    [_pswInputView clearAllPswCircle];
                    [_numberPlateView clearClickCount];
                }else{
                    if([_didSavePsw isEqualToString:_pswOnce]){
                        _inputPswLab.text = KWHC_InputPswLabGestureReTxt;
                        [_pswInputView clearAllPswCircle];
                        [self removeFromSuperview];
                        if(_isRemovePassword){
//                            [WHC_GestureUnlockScreenVC removeGesturePassword];
                        }
                    }else{
                        [_pswInputView showMistakeMsg];
                        [_numberPlateView clearClickCount];
                        if(_isModifyPassword){
                            _inputPswLab.text = KWHC_inputOldPswLabTxt;
                        }else{
                            _inputPswLab.text = KWHC_InputPswLabReTxt;
                        }
                        [_pswOnce deleteCharactersInRange:NSMakeRange(0, _pswOnce.length)];
                    }
                }
            }
        }];
    }else{
        [_pswInputView addPswCircleFinish:nil];
    }
}

#pragma mark - WHC_GestureDragPlateViewDelegate
- (BOOL)WHC_GestureDragPlateView:(WHC_GestureDragPlateView *)gestureDragPlateView psw:(NSString *)strPsw  didFinish:(BOOL)finish{
    BOOL  isSuccess = NO;
    if(finish){
        if(_isAgainSetPsw){
            if(_isModifyPassword){
                if(_modifyPsw){
                    if([_modifyPsw isEqualToString:strPsw]){
                        isSuccess = YES;
                        _inputPswLab.text = KWHC_SetUnlockSuccessTxt;
                        [self saveConfigurationInfo];
                        [self removeFromSuperview];
                    }else{
                        _modifyPsw = nil;
                        [_gestureInputView againSetGesturePath:NO];
                        _inputPswLab.text = KWHC_inputOldGestureLabTxt;
                        [_pswOnce deleteCharactersInRange:NSMakeRange(0, _pswOnce.length)];
                        _isAgainSetPsw = NO;
                    }
                }else{
                    isSuccess = YES;
                    _modifyPsw = strPsw.copy;
                    [_gestureInputView againSetGesturePath:YES];
                }
                [_pswOnce deleteCharactersInRange:NSMakeRange(0, _pswOnce.length)];
            }else{
                if([strPsw isEqualToString:_pswOnce]){
                    isSuccess = YES;
                    _inputPswLab.text = KWHC_SetUnlockSuccessTxt;
                    [self saveConfigurationInfo];
                    [self removeFromSuperview];
                }else{
                    [_gestureInputView againSetGesturePath:NO];
                    _inputPswLab.text = KWHC_InputPswLabGestureTxt;
                    [_pswOnce deleteCharactersInRange:NSMakeRange(0, _pswOnce.length)];
                    _isAgainSetPsw = NO;
                }
            }
        }else{
            if(_setState || _isModifyPassword){
                _pswOnce = [NSMutableString stringWithString:strPsw];
                _isAgainSetPsw = YES;
                if(_isModifyPassword){
                    if([strPsw isEqualToString:_didSavePsw]){
                        isSuccess = YES;
                        _inputPswLab.text = KWHC_inputNewGestureLabTxt;
                    }else{
                        _inputPswLab.text = KWHC_inputOldGestureLabTxt;
                        _isAgainSetPsw = NO;
                        [_pswOnce deleteCharactersInRange:NSMakeRange(0, _pswOnce.length)];
                    }
                }else{
                    _inputPswLab.text = KWHC_InputPswLabGestureAgTxt;
                }
                [_gestureInputView againSetGesturePath:_isAgainSetPsw];
            }else{
                if([strPsw isEqualToString:_didSavePsw]){
                    isSuccess = YES;
                    _inputPswLab.text = KWHC_UnlockSuccessTxt;
                    [self removeFromSuperview];
                    if(_isRemovePassword){
//                        [WHC_GestureUnlockScreenVC removeGesturePassword];
                    }
                }else{
                    _inputPswLab.text = KWHC_InputPswLabGestureReTxt;
                }
            }
        }
    }
    return isSuccess;
}
@end
