//
//  BLBaseViewController.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/2/28.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "BLBaseViewController.h"
#import "BLUnitsMethods.h"
#import "BLSettingViewController.h"
#import "BLInfomationViewController.h"
#import "BLMarketViewController.h"
#import "BLWalletViewController.h"
#import "BLLoginViewController.h"
#import "BLContactViewController.h"
#import "CreateWalletViewController.h"
#import "CheckSeedPsdViewController.h"
#import "SetWalletNameViewController.h"
#import "SetLoginPsdViewController.h"
#import "SetPayPsdViewController.h"
#import "InputLoginPsdViewController.h"
#import "RecoverWalletViewController.h"
#import "GatheringViewController.h"
#import "PaymentViewController.h"
#import "TranDetailViewController.h"

@interface BLBaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation BLBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.extendedLayoutIncludesOpaqueBars = NO;
//    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,SYS_FONT(20), NSFontAttributeName, nil]];
    self.navigationController.navigationBar.translucent = YES;
    
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0x557ec5)];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
     
    [self setBackground];
    
    [BLUnitsMethods drawTheBackBarBtn:self target:self action:@selector(backAcion)];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

-(void)setBackground{
    
    if ([self isKindOfClass:[BLWalletViewController class]]) {
        UIImageView *baseBgView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        baseBgView.image = ImageNamed(@"wallet_bg");
        [self.view addSubview:baseBgView];
    }else if ([self isKindOfClass:[BLMarketViewController class]] || [self isKindOfClass:[BLInfomationViewController class]] ||
             [self isKindOfClass:[BLSettingViewController class]] || [self isKindOfClass:[TranDetailViewController class]] || [self isKindOfClass:[BLContactViewController class]]){
        UIImageView *baseBgView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        baseBgView.image = ImageNamed(@"other_bg");
        [self.view addSubview:baseBgView];
    }else if ([self isKindOfClass:[BLLoginViewController class]] || [self isKindOfClass:[CreateWalletViewController class]] ||[self isKindOfClass:[CheckSeedPsdViewController class]] || [self isKindOfClass:[SetWalletNameViewController class]] || [self isKindOfClass:[SetLoginPsdViewController class]] || [self isKindOfClass:[SetPayPsdViewController class]] || [self isKindOfClass:[InputLoginPsdViewController class]] || [self isKindOfClass:[RecoverWalletViewController class]]|| [self isKindOfClass:[GatheringViewController class]] || [self isKindOfClass:[PaymentViewController class]]){
        UIImageView *baseBgView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        baseBgView.image = ImageNamed(@"login_bg");
        [self.view addSubview:baseBgView];
    }else {
        self.view.backgroundColor = UIColorFromRGB(0xf1f6fe);
    }
}
    
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DDLogInfo(@"dealloc class = %@", self.class);
}


-(void)backAcion{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark tap action
- (void)tapAction:(id)sender{
    [self.view endEditing:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch{
    if (![touch.view isKindOfClass:[UITextField class]] &&
        ![touch.view isKindOfClass:[UITextView class]] &&
        ![touch.view isKindOfClass:[UIButton class]]
        ){
        [self.view endEditing:YES];
    }
    
    return NO;
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
