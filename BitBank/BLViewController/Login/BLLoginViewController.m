//
//  BLLoginViewController.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/1.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "BLLoginViewController.h"
#import "CreateWalletViewController.h"
#import "RecoverWalletViewController.h"

@interface BLLoginViewController (){
    UIImageView *_logoView;
    
    UIButton *_createBtn;
    UIButton *_recoverBtn;
}

@end

@implementation BLLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _logoView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.center.x-55, self.view.center.y-78-50, 110, 78)];
    _logoView.image = ImageNamed(@"logo");
    [self.view addSubview:_logoView];
    
    _createBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _createBtn.frame = CGRectMake(self.view.center.x-85, CGRectGetMaxY(_logoView.frame)+100, 170, 50);
    [_createBtn setBackgroundImage:ImageNamed(@"btn_establish") forState:UIControlStateNormal];
    [_createBtn setBackgroundImage:ImageNamed(@"btn_recovery") forState:UIControlStateHighlighted];
    [_createBtn setTitle:Localized(@"login_createWallet") forState:UIControlStateNormal];
    [_createBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_createBtn setTitleColor:UIColorFromRGB(0x02a4ff) forState:UIControlStateHighlighted];
    [_createBtn addTarget:self action:@selector(createAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_createBtn];

    _recoverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _recoverBtn.frame = CGRectMake(self.view.center.x-85, CGRectGetMaxY(_createBtn.frame)+30, 170, 50);
    [_recoverBtn setBackgroundImage:ImageNamed(@"btn_recovery") forState:UIControlStateNormal];
    [_recoverBtn setBackgroundImage:ImageNamed(@"btn_establish") forState:UIControlStateHighlighted];
    [_recoverBtn setTitle:Localized(@"login_recoverWallet") forState:UIControlStateNormal];
    [_recoverBtn setTitleColor:UIColorFromRGB(0x02a4ff) forState:UIControlStateNormal];
    [_recoverBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_recoverBtn addTarget:self action:@selector(recoverAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_recoverBtn];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(void)createAction{
    CreateWalletViewController *cVC = [[CreateWalletViewController alloc]init];
    [self.navigationController pushViewController:cVC animated:YES];
}

-(void)recoverAction{
    RecoverWalletViewController *rVC = [[RecoverWalletViewController alloc]init];
    [self.navigationController pushViewController:rVC animated:YES];
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
