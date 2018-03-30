//
//  CreateWalletViewController.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/1.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "CreateWalletViewController.h"
#import "NSString+Utility.h"
#import "CheckSeedPsdViewController.h"
#import "NoCopyPasteTextView.h"
#import "MnemonicManager.h"

@interface CreateWalletViewController (){
    UIImageView *_logoView;
    UIView *_alphaView;
    UILabel *_createInfoLab;
    NoCopyPasteTextView *_seedTextView;
    
    UIImageView *_attentionView;
    UIImageView *_attentionIcon;
    UILabel *_attentionLab;
    
    UIButton *_nextBtn;
    UIButton *_backBtn;
}

@end

@implementation CreateWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(10, fit_X_width+30, 13, 23);
    [_backBtn setBackgroundImage:ImageNamed(@"back") forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
    
    _logoView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.center.x-55, 60+fit_X_width, 110, 78)];
    _logoView.image = ImageNamed(@"logo");
    [self.view addSubview:_logoView];
    
    _alphaView = [[UIView alloc]init];
    _alphaView.backgroundColor = [UIColor whiteColor];
    _alphaView.alpha = 0.2;
    _alphaView.layer.cornerRadius = 5;
    [self.view addSubview:_alphaView];
    
    CGFloat infoHeight = [Localized(@"login_createInfo") heightForWidth:kMainScreenWidth-80 withFont:SYS_FONT(16)];
    _createInfoLab = [[UILabel alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(_logoView.frame)+50, kMainScreenWidth-80, infoHeight)];
    _createInfoLab.font = SYS_FONT(16);
    _createInfoLab.numberOfLines = 0;
    _createInfoLab.text = Localized(@"login_createInfo");
    _createInfoLab.textColor = UIColorFromRGB(0x333333);
    [self.view addSubview:_createInfoLab];
    
    _seedTextView = [[NoCopyPasteTextView alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(_createInfoLab.frame)+30, kMainScreenWidth-80, 150)];
    _seedTextView.textColor = UIColorFromRGB(0x333333);
    _seedTextView.font = SYS_FONT(16);
    _seedTextView.editable = NO;
    _seedTextView.layer.cornerRadius = 5;
    _seedTextView.text = [MnemonicManager getMnemonicWords];
    [self.view addSubview:_seedTextView];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [_seedTextView addGestureRecognizer:tap];
    
    _attentionView = [[UIImageView alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(_seedTextView.frame)+10, kMainScreenWidth-80, 20)];
    _attentionView.backgroundColor = UIColorFromRGB(0xd02323);
    _attentionView.layer.cornerRadius = 11;
    [self.view addSubview:_attentionView];
    
    _attentionIcon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 4.5, 11, 11)];
    _attentionIcon.image = ImageNamed(@"attention");
    [_attentionView addSubview:_attentionIcon];
    
    _attentionLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxY(_attentionIcon.frame)+10, 4.5, 200, 11)];
    _attentionLab.font = SYS_FONT(10);
    _attentionLab.text = Localized(@"login_createAttention");
    _attentionLab.textColor = [UIColor whiteColor];
    [_attentionView addSubview:_attentionLab];

    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBtn.frame = CGRectMake(self.view.center.x-70, CGRectGetMaxY(_attentionView.frame)+50, 140, 50);
    [_nextBtn setBackgroundImage:ImageNamed(@"btn_establish") forState:UIControlStateNormal];
    [_nextBtn setBackgroundImage:ImageNamed(@"btn_recovery") forState:UIControlStateHighlighted];
    [_nextBtn setTitle:Localized(@"login_next") forState:UIControlStateNormal];
    [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextBtn setTitleColor:UIColorFromRGB(0x02a4ff) forState:UIControlStateHighlighted];
    [_nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextBtn];
    
    _alphaView.frame = CGRectMake(10, CGRectGetMaxY(_logoView.frame)+24, kMainScreenWidth-20, CGRectGetMaxY(_nextBtn.frame)-CGRectGetMaxY(_logoView.frame));
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)tapAction:(id)sender{
    _seedTextView.text = [MnemonicManager getMnemonicWords];
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)nextAction{
    BL_WalletId = [MnemonicManager getWalletIdWithMnemonicWords:_seedTextView.text];
    CheckSeedPsdViewController *cVC = [[CheckSeedPsdViewController alloc]initWithMnemonicWords:_seedTextView.text];
    [self.navigationController pushViewController:cVC animated:YES];
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
