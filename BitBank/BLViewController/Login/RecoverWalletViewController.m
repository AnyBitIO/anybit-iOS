//
//  RecoverWalletViewController.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/6.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "RecoverWalletViewController.h"
#import "NSString+Utility.h"
#import "BLUnitsMethods.h"
#import "SetWalletNameViewController.h"
#import "NoCopyPasteTextView.h"
#import "MnemonicManager.h"

@interface RecoverWalletViewController ()<UITextViewDelegate>{
    UIView *_allBgView;
    
    UIImageView *_logoView;
    UIView *_alphaView;
    UILabel *_checkSeedLab;
    
    NoCopyPasteTextView *_seedTextView;
    UILabel* _noticeLab;
    
    UIButton *_nextBtn;
    UIButton *_backBtn;
}

@end

@implementation RecoverWalletViewController

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
    
    _logoView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.center.x-55, 60+fit_X_width, 110, 78)];
    _logoView.image = ImageNamed(@"logo");
    [_allBgView addSubview:_logoView];
    
    _alphaView = [[UIView alloc]init];
    _alphaView.backgroundColor = [UIColor whiteColor];
    _alphaView.alpha = 0.2;
    _alphaView.layer.cornerRadius = 5;
    [_allBgView addSubview:_alphaView];
    
    CGFloat infoHeight = [Localized(@"login_inputSeedNotice") heightForWidth:kMainScreenWidth-20-60 withFont:SYS_FONT(16)];
    _checkSeedLab = [[UILabel alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(_logoView.frame)+50, kMainScreenWidth-80, infoHeight)];
    _checkSeedLab.font = SYS_FONT(16);
    _checkSeedLab.numberOfLines = 0;
    _checkSeedLab.textAlignment = NSTextAlignmentCenter;
    _checkSeedLab.text = Localized(@"login_inputSeedNotice");
    _checkSeedLab.textColor = UIColorFromRGB(0x333333);
    [_allBgView addSubview:_checkSeedLab];
    
    _seedTextView = [[NoCopyPasteTextView alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(_checkSeedLab.frame)+30, kMainScreenWidth-80, 150)];
    _seedTextView.textColor = UIColorFromRGB(0x333333);
    _seedTextView.font = SYS_FONT(16);
    _seedTextView.delegate = self;
    _seedTextView.userInteractionEnabled = YES;
    _seedTextView.layer.cornerRadius = 5;
    _seedTextView.keyboardType = UIKeyboardTypeASCIICapable;
    [_allBgView addSubview:_seedTextView];
    
    _noticeLab = [[UILabel alloc]initWithFrame:CGRectMake(5, 2.5, kMainScreenWidth - 20, 30)];
    _noticeLab.text = Localized(@"login_seedNotice");
    _noticeLab.textColor = UIColorFromRGB(0xdadada);
    _noticeLab.font= SYS_FONT(15);
    _noticeLab.hidden= NO;
    [_seedTextView addSubview:_noticeLab];
    
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBtn.frame = CGRectMake(self.view.center.x-70, CGRectGetMaxY(_seedTextView.frame)+50, 140, 50);
    [_nextBtn setBackgroundImage:ImageNamed(@"btn_recovery") forState:UIControlStateNormal];
    [_nextBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_nextBtn setTitle:Localized(@"login_next") forState:UIControlStateNormal];
    [_nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    _nextBtn.userInteractionEnabled = NO;
    [_allBgView addSubview:_nextBtn];
    
    _alphaView.frame = CGRectMake(10, CGRectGetMaxY(_logoView.frame)+24, kMainScreenWidth-20, CGRectGetMaxY(_nextBtn.frame)-CGRectGetMaxY(_logoView.frame));
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

-(void)backAction{
    [self.view endEditing:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)nextAction{
    [self.view endEditing:YES];

    NSMutableArray *array = [NSMutableArray arrayWithArray:[[_seedTextView.text lowercaseString] componentsSeparatedByString:@" "]];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:@""]) {
            [array removeObject:obj];
        }
    }];
    
    if (array.count != 18){
        [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"login_seedError") finsh:nil];
        return;
    }
    
    BL_WalletId = [MnemonicManager getWalletIdWithMnemonicWords:[array componentsJoinedByString:@" "]];
    SetWalletNameViewController *slVC = [[SetWalletNameViewController alloc]initWithIsRecover:YES mnemonicWords:[array componentsJoinedByString:@" "]];
    [self.navigationController pushViewController:slVC animated:YES];
}

#pragma mark - UITextView Delegate
- (void)textViewDidBeginEditing:(UITextView*)textView{
    [textView becomeFirstResponder];
}

- (BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text{
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    
    if ([text isEqualToString:@""]){
        return YES;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView*)textView{
    if([textView.text isEqualToString:@""]){
        _noticeLab.hidden = NO;
        _nextBtn.userInteractionEnabled = NO;
        [_nextBtn setBackgroundImage:ImageNamed(@"btn_recovery") forState:UIControlStateNormal];
        [_nextBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    else{
        _noticeLab.hidden = YES;
        _nextBtn.userInteractionEnabled = YES;
        [_nextBtn setBackgroundImage:ImageNamed(@"btn_establish") forState:UIControlStateNormal];
        [_nextBtn setBackgroundImage:ImageNamed(@"btn_recovery") forState:UIControlStateHighlighted];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextBtn setTitleColor:UIColorFromRGB(0x02a4ff) forState:UIControlStateHighlighted];
    }
}

- (void)textViewDidEndEditing:(UITextView*)textView{
    [textView resignFirstResponder];
}

#pragma mark - 键盘的显示
- (void)keyboardWillShow:(NSNotification*)notification{
    NSDictionary* userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue* animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    
    [animationDurationValue getValue:&animationDuration];
    
    CGFloat restHeight = keyboardRect.size.height-(kScreenHeightNoStatusBarHeight-CGRectGetMaxY(_seedTextView.frame));
    
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
