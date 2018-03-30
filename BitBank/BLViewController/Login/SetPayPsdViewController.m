//
//  SetPayPsdViewController.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/5.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "SetPayPsdViewController.h"
#import "BLUnitsMethods.h"
#import "SYPasswordView.h"
#import "ManagerCoinViewController.h"
#import "NSString+Utility.h"

@interface SetPayPsdViewController (){
    UIView *_allBgView;
    UIImageView *_logoView;
    UIView *_alphaView;
    UILabel *_pswNoticeLab;
    UILabel *_pswNoticeTwiceLab;
    UIButton *_nextBtn;
    UIButton *_backBtn;
    
    BOOL _isRecover;
    NSString *_mnemonicWords;
    NSString *_loginPsd;
    NSString *_walletName;
}
@property (nonatomic, strong) SYPasswordView *pasView;

@end

@implementation SetPayPsdViewController

-(id)initWithIsRecover:(BOOL)isRecover
         mnemonicWords:(NSString *)mnemonicWords
            walletName:(NSString*)walletName
              loginPsd:(NSString *)loginPsd{
    self = [super init];
    if (self) {
        _isRecover = isRecover;
        _mnemonicWords = mnemonicWords;
        _walletName = walletName;
        _loginPsd = loginPsd;
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
    
    _alphaView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_logoView.frame)+24, kMainScreenWidth-20, 300)];
    _alphaView.backgroundColor = [UIColor whiteColor];
    _alphaView.layer.cornerRadius = 5;
    [_allBgView addSubview:_alphaView];
    
    _pswNoticeLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 44, kMainScreenWidth-20, 30)];
    _pswNoticeLab.font = SYS_FONT(18);
    _pswNoticeLab.text = Localized(@"login_pswPayNotice");
    _pswNoticeLab.textColor = UIColorFromRGB(0x333333);
    _pswNoticeLab.textAlignment = NSTextAlignmentCenter;
    [_alphaView addSubview:_pswNoticeLab];
    
    _pswNoticeTwiceLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_pswNoticeLab.frame)+10, kMainScreenWidth-20, 20)];
    _pswNoticeTwiceLab.font = SYS_FONT(12);
    _pswNoticeTwiceLab.text = Localized(@"login_pswPayNoticeTwice");
    _pswNoticeTwiceLab.textColor = UIColorFromRGB(0xd12323);
    _pswNoticeTwiceLab.textAlignment = NSTextAlignmentCenter;
    [_alphaView addSubview:_pswNoticeTwiceLab];
    
    _pasView = [[SYPasswordView alloc] initWithFrame:CGRectMake(_alphaView.center.x-40*3-10, CGRectGetMaxY(_pswNoticeTwiceLab.frame)+30, 40*6, 45)];
    [_pasView.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_alphaView addSubview:_pasView];
    
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBtn.frame = CGRectMake(self.view.center.x-70, CGRectGetMaxY(_pasView.frame)+45, 140, 50);
    [_nextBtn setBackgroundImage:ImageNamed(@"btn_recovery") forState:UIControlStateNormal];
    [_nextBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_nextBtn setTitle:Localized(@"login_next") forState:UIControlStateNormal];
    [_nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    _nextBtn.userInteractionEnabled = NO;
    _nextBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_alphaView addSubview:_nextBtn];
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

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length == 6) {
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

-(void)backAction{
    [self.view endEditing:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)nextAction{
    [self.view endEditing:YES];
    
    DDLogInfo(@"最终的交易密码是:%@",_pasView.textField.text);
    
    if ([NSString isBLBlankString:_pasView.textField.text]) {
        [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"login_inputPswPay") finsh:nil];
        return;
    }
    
    if (_pasView.textField.text.length != 6) {
        [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"login_pswPayNotice") finsh:nil];
        return;
    }
    
    ManagerCoinViewController *mVC = [[ManagerCoinViewController alloc]initWithIsRecover:_isRecover isFromHomePage:NO mnemonicWords:_mnemonicWords walletName:_walletName loginPsd:_loginPsd payPsd:_pasView.textField.text];
    [self.navigationController pushViewController:mVC animated:YES];
}

#pragma mark - 键盘的显示
- (void)keyboardWillShow:(NSNotification*)notification{
    NSDictionary* userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue* animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    
    [animationDurationValue getValue:&animationDuration];
    
    CGFloat restHeight = keyboardRect.size.height-(kScreenHeightNoStatusBarHeight-CGRectGetMaxY(_pasView.frame));
    
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
