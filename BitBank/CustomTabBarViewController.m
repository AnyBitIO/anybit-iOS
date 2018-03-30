//
//  CustomTabBarViewController.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/2/28.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "CustomTabBarViewController.h"
#import "BLSettingViewController.h"
//#import "BLContactViewController.h"
#import "BLInfomationViewController.h"
#import "BLMarketViewController.h"
#import "BLWalletViewController.h"
#import "SetlanguageViewController.h"
#import "AppDelegate.h"

@interface CustomTabBarViewController (){
    UINavigationController* _walletNav;//钱包导航栏
    UINavigationController* _marketNav;//行情导航栏
    UINavigationController* _infomationNav;//资讯导航栏
//    UINavigationController* _contactNav;//联系人导航栏
    UINavigationController* _settingNav;//设置导航栏
}
@end

@implementation CustomTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(languageChange) name:NotifyLanguageChanged object:nil];
    
    [self.tabBar setBarTintColor:UIColorFromRGB(0x48526b)];
    
    [self initUI];
}

- (void)initUI{
    NSMutableArray* customTabBarControllerArray = [[NSMutableArray alloc]init];
    //钱包
    BLWalletViewController *walletViewController = [[BLWalletViewController alloc] init];
    _walletNav = [[UINavigationController alloc]initWithRootViewController:walletViewController];
    [customTabBarControllerArray addObject:_walletNav];
    
    //行情
    BLMarketViewController *marketViewController = [[BLMarketViewController alloc]init];
    _marketNav = [[UINavigationController alloc]initWithRootViewController:marketViewController];
    [customTabBarControllerArray addObject:_marketNav];
    
    //资讯
    BLInfomationViewController *infomationViewController = [[BLInfomationViewController alloc] init];
    _infomationNav = [[UINavigationController alloc]initWithRootViewController:infomationViewController];
    [customTabBarControllerArray addObject:_infomationNav];
    
    //联系人
//    BLContactViewController *contactViewController = [[BLContactViewController alloc]init];
//    _contactNav = [[UINavigationController alloc]initWithRootViewController:contactViewController];
//    [customTabBarControllerArray addObject:_contactNav];
    
    //设置
    BLSettingViewController *settingViewController = [[BLSettingViewController alloc]init];
    _settingNav = [[UINavigationController alloc]initWithRootViewController:settingViewController];
    [customTabBarControllerArray addObject:_settingNav];
    
    //tabbar item init
    UITabBarItem *walletItem = [[UITabBarItem alloc] initWithTitle:Localized(@"bl_wallet") image:[ImageNamed(@"tab_qianbao_gray") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[ImageNamed(@"tab_qianbao_blue") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [walletItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      TAB_BAR_SELECT_COLOR, NSForegroundColorAttributeName, SYS_FONT(11), NSFontAttributeName,
                                      nil] forState:UIControlStateSelected];
    [walletItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      TAB_BAR_NORMAL_COLOR, NSForegroundColorAttributeName, SYS_FONT(11), NSFontAttributeName,
                                      nil] forState:UIControlStateNormal];
    _walletNav.tabBarItem = walletItem;
    
    UITabBarItem *marketItem = [[UITabBarItem alloc] initWithTitle:Localized(@"bl_market") image:[ImageNamed(@"tab_hangqing_gray") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[ImageNamed(@"tab_hangqing_blue") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [marketItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                           TAB_BAR_SELECT_COLOR, NSForegroundColorAttributeName, SYS_FONT(11), NSFontAttributeName,
                                           nil] forState:UIControlStateSelected];
    [marketItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                           TAB_BAR_NORMAL_COLOR, NSForegroundColorAttributeName, SYS_FONT(11), NSFontAttributeName,
                                           nil] forState:UIControlStateNormal];
    _marketNav.tabBarItem = marketItem;
    
    
    UITabBarItem *infomationItem = [[UITabBarItem alloc] initWithTitle:Localized(@"bl_infomation") image:[ImageNamed(@"tab_zixun_gray") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[ImageNamed(@"tab_zixun_blue") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [infomationItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                         TAB_BAR_SELECT_COLOR, NSForegroundColorAttributeName, SYS_FONT(11), NSFontAttributeName,
                                         nil] forState:UIControlStateSelected];
    [infomationItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                         TAB_BAR_NORMAL_COLOR, NSForegroundColorAttributeName, SYS_FONT(11), NSFontAttributeName,
                                         nil] forState:UIControlStateNormal];
    _infomationNav.tabBarItem = infomationItem;
    
    
//    UITabBarItem *contactItem = [[UITabBarItem alloc] initWithTitle:Localized(@"bl_contact") image:[ImageNamed(@"tab_lianxiren_gray") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[ImageNamed(@"tab_lianxiren_blue") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [contactItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                 TAB_BAR_SELECT_COLOR, NSForegroundColorAttributeName, SYS_FONT(11), NSFontAttributeName,
//                                                 nil] forState:UIControlStateSelected];
//    [contactItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                 TAB_BAR_NORMAL_COLOR, NSForegroundColorAttributeName, SYS_FONT(11), NSFontAttributeName,
//                                                 nil] forState:UIControlStateNormal];
//    _contactNav.tabBarItem = contactItem;
    
    UITabBarItem *settingItem = [[UITabBarItem alloc] initWithTitle:Localized(@"bl_setting") image:[ImageNamed(@"tab_shezhi_gray") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[ImageNamed(@"tab_shezhi_blue") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [settingItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      TAB_BAR_SELECT_COLOR, NSForegroundColorAttributeName, SYS_FONT(11), NSFontAttributeName,
                                      nil] forState:UIControlStateSelected];
    [settingItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      TAB_BAR_NORMAL_COLOR, NSForegroundColorAttributeName, SYS_FONT(11), NSFontAttributeName,
                                      nil] forState:UIControlStateNormal];
    _settingNav.tabBarItem = settingItem;
    
    [self setViewControllers:customTabBarControllerArray];
    [self setSelectedIndex:0];
    
}

- (void)languageChange
{
    [BLAPPDELEGATE goToMainViewController];
    [BLAPPDELEGATE.customTabBarController setSelectedIndex:3];    
//    UINavigationController *nav = tabVc.selectedViewController;
//    [nav pushViewController:[[SetlanguageViewController alloc]init] animated:NO];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
