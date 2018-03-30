//
//  DNPayAlertView.m
//  DNPayAlertDemo
//
//  Created by dawnnnnn on 15/12/9.
//  Copyright © 2015年 dawnnnnn. All rights reserved.
//

#import "DNPayAlertView.h"
#import "BLWalletDBManager.h"
#import "NSString+Utility.h"

#define kSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define kSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define kPAYMENT_WIDTH kSCREEN_WIDTH-80

static NSInteger const kPasswordCount = 6;

static CGFloat const kTitleHeight     = 46.f;
static CGFloat const kDotWidth        = 10;
static CGFloat const kKeyboardHeight  = 216;
static CGFloat const kAlertHeight     = 150;
static CGFloat const kCommonMargin    = 100;
static CGFloat const kCommonMargin_X  = 150;

@interface DNPayAlertView () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *paymentAlert;
@property (nonatomic, strong) UIView *inputView;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *pwdTextField;

@property (nonatomic, strong) UIWindow *showWindow;

@end

@interface DNPayAlertView ()

@property (nonatomic, strong) NSMutableArray <UILabel *> *pwdIndicators;

@end

@implementation DNPayAlertView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.view.frame = [UIScreen mainScreen].bounds;
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.6f];
        
        [self viewAddSubviews];
    }
    return self;
}

- (void)viewAddSubviews {
    [self.view addSubview:self.paymentAlert];
    [self.paymentAlert addSubview:self.titleLabel];
    [self.paymentAlert addSubview:self.closeBtn];
    [self.paymentAlert addSubview:self.inputView];
    [self.inputView addSubview:self.pwdTextField];
    
    CGFloat width = self.inputView.bounds.size.width/kPasswordCount;
    for (int i = 0; i < kPasswordCount; i ++) {
        UILabel *dot = [[UILabel alloc]initWithFrame:CGRectMake((width-kDotWidth)/2.f + i*width, (self.inputView.bounds.size.height-kDotWidth)/2.f, kDotWidth, kDotWidth)];
        dot.backgroundColor = [UIColor blackColor];
        dot.layer.cornerRadius = kDotWidth/2.;
        dot.clipsToBounds = YES;
        dot.hidden = YES;
        [self.inputView addSubview:dot];
        [self.pwdIndicators addObject:dot];
        if (i == kPasswordCount-1) {
            continue;
        }
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake((i+1)*width, 0, .5f, self.inputView.bounds.size.height)];
        line.backgroundColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1.];
        [self.inputView addSubview:line];
    }
}


- (void)show {
    UIWindow *newWindow = [[UIWindow alloc]initWithFrame:self.view.bounds];
    newWindow.rootViewController = self;
    [newWindow makeKeyAndVisible];
    self.showWindow = newWindow;
    
    self.paymentAlert.transform = CGAffineTransformMakeScale(1.21f, 1.21f);
    self.paymentAlert.alpha = 0;

    [UIView animateWithDuration:.7f delay:0.f usingSpringWithDamping:.7f initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [_pwdTextField becomeFirstResponder];
        _paymentAlert.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        _paymentAlert.alpha = 1.0;
    } completion:nil];
}

- (void)dismiss {
    [self.pwdTextField resignFirstResponder];
    [UIView animateWithDuration:.7f animations:^{
        self.paymentAlert.transform = CGAffineTransformMakeScale(1.21f, 1.21f);
        self.paymentAlert.alpha = 0;
        self.showWindow.alpha = 0;
    } completion:^(BOOL finished) {
        [self.showWindow removeFromSuperview];
        [self.showWindow resignKeyWindow];
        self.showWindow = nil;
    }];
}

-(void)closeAction{
    if (_payAlertViewCloseBlock) {
        [self.pwdTextField resignFirstResponder];
        [self.showWindow removeFromSuperview];
        [self.showWindow resignKeyWindow];
        self.showWindow = nil;
        _payAlertViewCloseBlock();
    }else{
        [self dismiss];
    }
}

#pragma mark - delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length >= kPasswordCount && string.length) {
        return NO;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[0-9]*$"];
    if (![predicate evaluateWithObject:string]) {
        return NO;
    }

    return YES;
}

#pragma mark - action

- (void)textDidChange:(UITextField *)textField {
    [self setDotWithCount:textField.text.length];
    if (textField.text.length == 6) {
        NSString *payPsd = [BLWalletDBManager getWalletPayPsd];
        if ([payPsd isEqualToString:[NSString stringToHash256ToHex:textField.text]]) {
            if (self.payAlertViewSuccessBlock) {
                self.payAlertViewSuccessBlock(textField.text);
            }
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:.3f];
        }else{
            [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"login_PayError") finsh:nil];
            CAKeyframeAnimation *shake=[CAKeyframeAnimation animationWithKeyPath:@"position.x"];
            shake.values=@[@0,@-10,@10,@-10,@0];
            shake.additive=YES;
            shake.duration=0.25;
            [_paymentAlert.layer addAnimation:shake forKey:@"shake"];
        }
    }
}

- (void)setDotWithCount:(NSInteger)count {
    for (UILabel *dot in self.pwdIndicators) {
        dot.hidden = YES;
    }
    
    for (int i = 0; i< count; i++) {
        ((UILabel*)[self.pwdIndicators objectAtIndex:i]).hidden = NO;
    }
}


#pragma mark - getter

- (UIView *)paymentAlert {
    if (_paymentAlert == nil) {
        _paymentAlert = [[UIView alloc]initWithFrame:CGRectMake(40, [UIScreen mainScreen].bounds.size.height-kKeyboardHeight-(iPhoneX?kCommonMargin_X:kCommonMargin)-kAlertHeight, [UIScreen mainScreen].bounds.size.width-80, kAlertHeight)];
        _paymentAlert.layer.cornerRadius = 5.f;
        _paymentAlert.layer.masksToBounds = YES;
        _paymentAlert.backgroundColor = [UIColor colorWithWhite:1. alpha:.95];
    }
    return _paymentAlert;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, kPAYMENT_WIDTH, kTitleHeight)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = UIColorFromRGB(0x333333);
        _titleLabel.font = SYS_FONT(17);
        _titleLabel.text = Localized(@"login_inputPswPay");
    }
    return _titleLabel;
}

- (UIButton *)closeBtn {
    if (_closeBtn == nil) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setFrame:CGRectMake(kPAYMENT_WIDTH-5-kTitleHeight, 5, kTitleHeight, kTitleHeight)];
        [_closeBtn setTitle:@"╳" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _closeBtn;
}


- (UIView *)inputView {
    if (_inputView == nil) {
        _inputView = [[UIView alloc]initWithFrame:CGRectMake(15, _paymentAlert.frame.size.height-(kPAYMENT_WIDTH-30)/6-15, kPAYMENT_WIDTH-30, (kPAYMENT_WIDTH-30)/6)];
        _inputView.backgroundColor = [UIColor whiteColor];
        _inputView.layer.borderWidth = 1.f;
        _inputView.layer.borderColor = [UIColor colorWithRed:.9 green:.9 blue:.9 alpha:1.].CGColor;
    }
    return _inputView;
}

- (UITextField *)pwdTextField {
    if (_pwdTextField == nil) {
        _pwdTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _pwdTextField.hidden = YES;
        _pwdTextField.delegate = self;
        _pwdTextField.keyboardType = UIKeyboardTypeNumberPad;
        _pwdTextField.secureTextEntry = YES;
        [_pwdTextField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _pwdTextField;
}

- (NSMutableArray *)pwdIndicators {
    if (_pwdIndicators == nil) {
        _pwdIndicators = [[NSMutableArray alloc]init];
    }
    return _pwdIndicators;
}

@end
