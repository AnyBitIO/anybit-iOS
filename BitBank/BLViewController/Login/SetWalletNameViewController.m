//
//  SetWalletNameViewController.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/26.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "SetWalletNameViewController.h"
#import "SetLoginPsdViewController.h"
#import "BLUnitsMethods.h"
#import "NSString+Utility.h"
#import "CommonWebViewController.h"
#import "BLWalletDBManager.h"

@interface SetWalletNameViewController ()<UITextFieldDelegate>{
    UIView *_allBgView;
    UIButton *_backBtn;
    UIImageView *_logoView;
    UIView *_whiteView;
    UILabel *_nameTitleLab;
    UITextField *_nameTextField;
    UIView *_lineView;
    UIButton *_caseBtn;
    UILabel *_termsLab;
    UIButton *_termsBtn;
    UIButton *_nextBtn;
    
    BOOL _isSelect;
    BOOL _isRecover;
    NSString *_mnemonicWords;
}

@end

@implementation SetWalletNameViewController

-(id)initWithIsRecover:(BOOL)isRecover mnemonicWords:(NSString *)mnemonicWords{
    self = [super init];
    if (self) {
        _isRecover = isRecover;
        _mnemonicWords = mnemonicWords;
        _isSelect = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _allBgView = [[UIView alloc]initWithFrame:self.view.bounds];
    _allBgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_allBgView];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(10, fit_X_width+30, 13, 23);
    [_backBtn setBackgroundImage:ImageNamed(@"back") forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
    
    _logoView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.center.x-55, fit_X_width+60, 110, 78)];
    _logoView.image = ImageNamed(@"logo");
    [_allBgView addSubview:_logoView];
    
    _whiteView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_logoView.frame)+24, kMainScreenWidth-20, 300)];
    _whiteView.backgroundColor = [UIColor whiteColor];
    _whiteView.layer.cornerRadius = 5;
    [_allBgView addSubview:_whiteView];
    
    _nameTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 44, kMainScreenWidth-20, 30)];
    _nameTitleLab.font = SYS_FONT(18);
    _nameTitleLab.text = Localized(@"login_walletName");
    _nameTitleLab.textColor = UIColorFromRGB(0x333333);
    _nameTitleLab.textAlignment = NSTextAlignmentCenter;
    [_whiteView addSubview:_nameTitleLab];
    
    _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(_whiteView.center.x-100, CGRectGetMaxY(_nameTitleLab.frame)+60, 200, 40)];
    _nameTextField.backgroundColor = [UIColor whiteColor];
    _nameTextField.delegate = self;
    [_nameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _nameTextField.textColor = UIColorFromRGB(0x666666);
    _nameTextField.textAlignment = NSTextAlignmentCenter;
    [_whiteView addSubview:_nameTextField];
    
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(_whiteView.center.x-100, CGRectGetMaxY(_nameTextField.frame), 200, 0.5)];
    _lineView.backgroundColor = UIColorFromRGB(0xDEF0FC);
    [_whiteView addSubview:_lineView];
    
    _caseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_caseBtn setBackgroundImage:ImageNamed(@"terms") forState:UIControlStateNormal];
    [_caseBtn setBackgroundImage:ImageNamed(@"terms_select") forState:UIControlStateSelected];
    [_caseBtn addTarget:self action:@selector(termsSelectAction) forControlEvents:UIControlEventTouchUpInside];
    [_whiteView addSubview:_caseBtn];

    _termsLab = [[UILabel alloc]init];
    _termsLab.font = SYS_FONT(13);
    _termsLab.text = Localized(@"login_read_lab");
    _termsLab.textColor = UIColorFromRGB(0x666666);
    [_whiteView addSubview:_termsLab];

    _termsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_termsBtn setTitle:[NSString stringWithFormat:@"《%@》",Localized(@"login_read_btn")] forState:UIControlStateNormal];
    [_termsBtn setTitleColor:UIColorFromRGB(0x5080C7) forState:UIControlStateNormal];
    [_termsBtn addTarget:self action:@selector(termsDetailAction) forControlEvents:UIControlEventTouchUpInside];
    _termsBtn.titleLabel.font = SYS_FONT(13);
    [_whiteView addSubview:_termsBtn];
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:NDappLanguage] isEqualToString:@"en"]){
        _caseBtn.frame = CGRectMake(_whiteView.center.x-170, CGRectGetMaxY(_lineView.frame)+10, 20, 20);
        _termsLab.frame = CGRectMake(CGRectGetMaxX(_caseBtn.frame)+5,CGRectGetMaxY(_lineView.frame)+10, 55, 20);
        _termsBtn.frame = CGRectMake(CGRectGetMaxX(_termsLab.frame), CGRectGetMaxY(_lineView.frame)+10, 245, 20);
    }else {
        _caseBtn.frame = CGRectMake(_whiteView.center.x-135, CGRectGetMaxY(_lineView.frame)+10, 20, 20);
        _termsLab.frame = CGRectMake(CGRectGetMaxX(_caseBtn.frame)+5,CGRectGetMaxY(_lineView.frame)+10, 120, 20);
        _termsBtn.frame = CGRectMake(CGRectGetMaxX(_termsLab.frame), CGRectGetMaxY(_lineView.frame)+10, 120, 20);
    }
    
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBtn.frame = CGRectMake(_whiteView.center.x-70, CGRectGetMaxY(_caseBtn.frame)+20, 140, 50);
    [_nextBtn setBackgroundImage:ImageNamed(@"btn_recovery") forState:UIControlStateNormal];
    [_nextBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_nextBtn setTitle:Localized(@"login_next") forState:UIControlStateNormal];
    [_nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    _nextBtn.userInteractionEnabled = NO;
    _nextBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_whiteView addSubview:_nextBtn];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark- 返回
-(void)backAction{
    [self.view endEditing:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- 勾选隐私协议
-(void)termsSelectAction{
    [self.view endEditing:YES];
    
    if (_caseBtn.selected) {
        _isSelect = NO;
        _caseBtn.selected = NO;
    }else{
        _isSelect = YES;
        _caseBtn.selected = YES;
    }
    
    [self judgeNextBtnISEnable];
}

#pragma mark- 查看隐私协议详情
-(void)termsDetailAction{
    [self.view endEditing:YES];
    
    CommonWebViewController *cVC = [[CommonWebViewController alloc]initWithTitle:Localized(@"login_read_btn") pageType:@"agreement"];
    [self.navigationController pushViewController:cVC animated:YES];
}

#pragma mark- 下一步
-(void)nextAction{
    [self.view endEditing:YES];
    
    DDLogInfo(@"最终的钱包名字是:%@",_nameTextField.text);
    
    if ([BLWalletDBManager queryWalletNameIsTakenWithName:_nameTextField.text]) {
        [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"wallet_name_same") finsh:nil];
        return;
    }
    
    if ([NSString isBLBlankString:_nameTextField.text]) {
        [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"wallet_name_unEmpty") finsh:nil];
        return;
    }
    
    if (![NSString stringWithNumbersAndLettersOrChinese:_nameTextField.text]) {
        [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"common_input_limit") finsh:nil];
        return;
    }
    
    if (_nameTextField.text.length>10) {
        [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"common_input_length_10") finsh:nil];
        return;
    }
    
    SetLoginPsdViewController *sVC = [[SetLoginPsdViewController alloc]initWithIsRecover:_isRecover mnemonicWords:_mnemonicWords walletName:_nameTextField.text];
    [self.navigationController pushViewController:sVC animated:YES];
}

#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return NO;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
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
    [self judgeNextBtnISEnable];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    return YES;
}

-(void)judgeNextBtnISEnable{
    if (![NSString isBLBlankString:_nameTextField.text] && _isSelect) {
        _nextBtn.userInteractionEnabled = YES;
        [_nextBtn setBackgroundImage:ImageNamed(@"btn_establish") forState:UIControlStateNormal];
        [_nextBtn setBackgroundImage:ImageNamed(@"btn_recovery") forState:UIControlStateHighlighted];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextBtn setTitleColor:UIColorFromRGB(0x02a4ff) forState:UIControlStateHighlighted];
    }else {
        _nextBtn.userInteractionEnabled = NO;
        [_nextBtn setBackgroundImage:ImageNamed(@"btn_recovery") forState:UIControlStateNormal];
        [_nextBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
}

#pragma mark - 键盘的显示
- (void)keyboardWillShow:(NSNotification*)notification{
    NSDictionary* userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue* animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    
    [animationDurationValue getValue:&animationDuration];
    
    CGFloat restHeight = keyboardRect.size.height-(kScreenHeightNoStatusBarHeight-CGRectGetMaxY(_nameTextField.frame));
    
    if (restHeight > 0){
        CGRect tempRect = _allBgView.frame;
        tempRect.origin.y = -restHeight;
        _allBgView.frame = tempRect;
    }
}

#pragma mark - 键盘的隐藏
- (void)keyboardWillHide:(NSNotification*)notification{
    NSDictionary* userInfo = [notification userInfo];
    NSValue* animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    
    [animationDurationValue getValue:&animationDuration];
    
    _allBgView.frame = self.view.bounds;
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
