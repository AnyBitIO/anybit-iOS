//
//  ChangePasswordViewController.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/8.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "BLUnitsMethods.h"
#import "NSString+Utility.h"
#import "NoCopyPasteTextField.h"
#import "BLWalletDBManager.h"
#import "AESCrypt.h"

@interface ChangePasswordViewController ()<UITextFieldDelegate>{
    BLChangePasswordType _type;
    
    UIView *_bgView;
    
    NoCopyPasteTextField *_oldTextField;
    
    UIView *_labView;
    UILabel *_noticeLab;
    
    NoCopyPasteTextField *_newTextField;
    UIButton *_newBtn;
    UIView *_lineView;
    
    NoCopyPasteTextField *_confirmTextField;
    UIButton *_confirmBtn;
}

@end

@implementation ChangePasswordViewController

-(id)initWithType:(BLChangePasswordType)type{
    self = [super init];
    if (self) {
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_type == BLChangePassword_Login) {
        self.title = Localized(@"setting_change_loginPsd");
    }else{
        self.title = Localized(@"setting_change_payPsd");
    }
    
    [BLUnitsMethods drawTheRightBarBtnWithTitle:Localized(@"set_sure") target:self action:@selector(sureAction)];

    [self initUI];
}

-(void)initUI{
    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, kMainScreenWidth-20, 60*3+30)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgView];
    
    _oldTextField = [[NoCopyPasteTextField alloc] initWithFrame:CGRectMake(10, 15, _bgView.frame.size.width-20, 30)];
    _oldTextField.backgroundColor = [UIColor clearColor];
    _oldTextField.textColor = UIColorFromRGB(0x333333);
    _oldTextField.delegate = self;
    _oldTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _oldTextField.keyboardType = UIKeyboardTypeNumberPad;
    _oldTextField.secureTextEntry = YES;
    _oldTextField.placeholder = Localized(@"set_old_password");
    [_oldTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_bgView addSubview:_oldTextField];
    
    _labView = [[UIView alloc]initWithFrame:CGRectMake(0, 60, _bgView.frame.size.width, 30)];
    _labView.backgroundColor = UIColorFromRGB(0xf1f6fe);
    [_bgView addSubview:_labView];
    
    _noticeLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, _bgView.frame.size.width-20, 30)];
    _noticeLab.font = SYS_FONT(13);
    _noticeLab.textColor = UIColorFromRGB(0x666666);
    _noticeLab.text = Localized(@"set_password_notice");
    _noticeLab.backgroundColor = [UIColor clearColor];
    [_labView addSubview:_noticeLab];

    
    _newTextField = [[NoCopyPasteTextField alloc] initWithFrame:CGRectMake(10, 105, _bgView.frame.size.width-40-22, 30)];
    _newTextField.backgroundColor = [UIColor clearColor];
    _newTextField.textColor = UIColorFromRGB(0x333333);
    _newTextField.delegate = self;
    _newTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _newTextField.keyboardType = UIKeyboardTypeNumberPad;
    _newTextField.secureTextEntry = YES;
    _newTextField.clearsOnBeginEditing = YES;
    _newTextField.placeholder = Localized(@"set_new_password");
    [_newTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_bgView addSubview:_newTextField];
    
    _newBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _newBtn.frame = CGRectMake(_bgView.frame.size.width-22-10, 115, 22, 13);
    [_newBtn setBackgroundImage:ImageNamed(@"eye") forState:UIControlStateNormal];
    [_newBtn addTarget:self action:@selector(showNewPsdAction) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_newBtn];
    
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 149.5, _bgView.frame.size.width-20, 0.5)];
    _lineView.backgroundColor = LINE_COLOR;
    [_bgView addSubview:_lineView];
    
    _confirmTextField = [[NoCopyPasteTextField alloc] initWithFrame:CGRectMake(10, 165, _bgView.frame.size.width-40-22, 30)];
    _confirmTextField.backgroundColor = [UIColor clearColor];
    _confirmTextField.textColor = UIColorFromRGB(0x333333);
    _confirmTextField.delegate = self;
    _confirmTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _confirmTextField.keyboardType = UIKeyboardTypeNumberPad;
    _confirmTextField.secureTextEntry = YES;
    _confirmTextField.clearsOnBeginEditing = YES;
    [_confirmTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _confirmTextField.placeholder = Localized(@"set_confirm_password");
    [_bgView addSubview:_confirmTextField];
    
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmBtn.frame = CGRectMake(_bgView.frame.size.width-22-10, 175, 22, 13);
    [_confirmBtn setBackgroundImage:ImageNamed(@"eye") forState:UIControlStateNormal];
    [_confirmBtn addTarget:self action:@selector(showConfirmPsdAction) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_confirmBtn];
}


-(void)showNewPsdAction{
    [_newTextField resignFirstResponder];
    if (_newTextField.secureTextEntry) {
        _newTextField.secureTextEntry = NO;
    }else{
        _newTextField.secureTextEntry = YES;
    }
    [_newTextField becomeFirstResponder];
}

-(void)showConfirmPsdAction{
    if (_confirmTextField.secureTextEntry) {
        _confirmTextField.secureTextEntry = NO;
    }else{
        _confirmTextField.secureTextEntry = YES;
    }
}


-(void)sureAction{
    
    [self.view endEditing:YES];
    
    if ([NSString isBLBlankString:_oldTextField.text] || [NSString isBLBlankString:_newTextField.text] || [NSString isBLBlankString:_confirmTextField.text]) {
        [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"set_empty_password") finsh:nil];
        return;
    }
    
    if (_oldTextField.text.length !=6 || _newTextField.text.length !=6 || _confirmTextField.text.length !=6) {
        [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"set_length_password") finsh:nil];
        return;
    }
    
    if (![_newTextField.text isEqualToString:_confirmTextField.text]) {
        [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"set_different_password") finsh:nil];
        return;
    }
    
    if (_type == BLChangePassword_Login) {
        NSString *tempLoginPsd = [BLWalletDBManager getWalletLoginPsd];
        if (![tempLoginPsd isEqualToString:[NSString stringToHash256ToHex:_oldTextField.text]]) {
            [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"set_error_password") finsh:nil];
            return;
        }
        
        [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"common_set_success") finsh:^{
            [BLWalletDBManager updateWalletLoginPsd:[NSString stringToHash256ToHex:_confirmTextField.text]];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }else {
        NSString *tempPayPsd = [BLWalletDBManager getWalletPayPsd];
        if (![tempPayPsd isEqualToString:[NSString stringToHash256ToHex:_oldTextField.text]]) {
            [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"set_error_password") finsh:nil];
            return;
        }
        
        [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"common_set_success") finsh:^{
            NSString *mnemonicWords = [AESCrypt decrypt:[BLWalletDBManager getWalletMnemonicWords] password:_oldTextField.text];
             NSString *seedKey = [AESCrypt decrypt:[BLWalletDBManager getWalletSeedKey] password:_oldTextField.text];
            [BLWalletDBManager updateWalletMnemonicWords:mnemonicWords];
            [BLWalletDBManager updateWalletSeedKey:seedKey];
            [BLWalletDBManager updateWalletPayPsd:[NSString stringToHash256ToHex:_confirmTextField.text]];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField becomeFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidChange:(UITextField *)textField{
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (string.length == 0) return YES;
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (existedLength - selectedLength + replaceLength > 6) {
        return NO;
    }
    
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
