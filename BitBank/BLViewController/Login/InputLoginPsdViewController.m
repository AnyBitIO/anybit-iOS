//
//  InputLoginPsdViewController.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/6.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "InputLoginPsdViewController.h"
#import "BLUnitsMethods.h"
#import "SYPasswordView.h"
#import "SetPayPsdViewController.h"
#import "NSString+Utility.h"
#import "AppDelegate.h"
#import "RecoverWalletViewController.h"
#import "BLWalletDBManager.h"
#import "NSString+Utility.h"

@interface InputLoginPsdViewController ()<UITextFieldDelegate>{
    UIView *_allBgView;
    
    UIImageView *_logoView;
    
    UIView *_whiteView;
    UILabel *_pswNoticeLab;
    
    UIButton *_recoverBtn;
}
@property (nonatomic, strong) SYPasswordView *pasView;

@end

@implementation InputLoginPsdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _allBgView = [[UIView alloc]initWithFrame:self.view.bounds];
    _allBgView.backgroundColor = [UIColor clearColor];
    _allBgView.userInteractionEnabled = YES;
    [self.view addSubview:_allBgView];
    
    _logoView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.center.x-55, fit_X_width+60, 110, 78)];
    _logoView.image = ImageNamed(@"logo");
    _logoView.userInteractionEnabled = YES;
    [_allBgView addSubview:_logoView];
    
    _whiteView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_logoView.frame)+24, kMainScreenWidth-20, 280)];
    _whiteView.backgroundColor = [UIColor whiteColor];
    _whiteView.layer.cornerRadius = 5;
    [_allBgView addSubview:_whiteView];
    
    _pswNoticeLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 44, kMainScreenWidth-20, 30)];
    _pswNoticeLab.font = SYS_FONT(18);
    _pswNoticeLab.text = Localized(@"login_inputPswLogin");
    _pswNoticeLab.textColor = UIColorFromRGB(0x333333);
    _pswNoticeLab.textAlignment = NSTextAlignmentCenter;
    [_whiteView addSubview:_pswNoticeLab];
    
    _pasView = [[SYPasswordView alloc] initWithFrame:CGRectMake(_whiteView.center.x-40*3-10, CGRectGetMaxY(_pswNoticeLab.frame)+30, 40*6, 45)];
    _pasView.textField.delegate = self;
    [_pasView.textField becomeFirstResponder];
    [_whiteView addSubview:_pasView];
    
    _recoverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _recoverBtn.frame = CGRectMake(_whiteView.center.x-70, CGRectGetMaxY(_pasView.frame)+45, 140, 50);
    [_recoverBtn setBackgroundImage:ImageNamed(@"btn_recovery") forState:UIControlStateNormal];
    [_recoverBtn setBackgroundImage:ImageNamed(@"btn_establish") forState:UIControlStateHighlighted];
    [_recoverBtn setTitle:Localized(@"login_recoverWallet") forState:UIControlStateNormal];
    [_recoverBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_recoverBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_recoverBtn addTarget:self action:@selector(recoverAction) forControlEvents:UIControlEventTouchUpInside];
    [_whiteView addSubview:_recoverBtn];
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

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField.text.length == 6) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *tempPassword = [BLWalletDBManager getWalletLoginPsd];
            if ([tempPassword isEqualToString:[NSString stringToHash256ToHex:_pasView.textField.text]]){
                [BLAPPDELEGATE goToMainViewController];
            }else{
                CAKeyframeAnimation *shake=[CAKeyframeAnimation animationWithKeyPath:@"position.x"];
                shake.values=@[@0,@-10,@10,@-10,@0];
                shake.additive=YES;
                shake.duration=0.25;
                [_pasView.layer addAnimation:shake forKey:@"shake"];
                [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"login_loginError") finsh:nil];
                [_pasView clearUpPassword];
            }
        });
    }
    return YES;
}

-(void)recoverAction{
    [self.view endEditing:YES];
    
    RecoverWalletViewController *rVC = [[RecoverWalletViewController alloc]init];
    [self.navigationController pushViewController:rVC animated:YES];
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
