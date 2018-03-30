//
//  AppDelegate.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/2/7.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "AppDelegate.h"
#import "BLLogManager.h"
#import "BLLoginViewController.h"
#import "InputLoginPsdViewController.h"
#import "BLDBManager.h"
#import "HoldCoinDBManager.h"
#import "BLWalletDBManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //开启DDLogInfo
    [BLLogManager logOpen];
        
    //配置当前语音
    [self initLanguage];

    if ([BLWalletDBManager queryWalletDBData].count > 0) {
        BL_WalletId = [BLWalletDBManager getWalletId];
        if ([BLWalletDBManager getWalletNeedLoginPassword]){
            [self goToPasswordViewController];
        }else {
            [self goToMainViewController];
        }
    }else {
        [self goToLoginViewController];
    }
    
    return YES;
}

- (void)initLanguage{
    if (![[NSUserDefaults standardUserDefaults]objectForKey:NDappLanguage]) {
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *language = [languages objectAtIndex:0];
        if ([language hasPrefix:@"zh-Hans"]) {//开头匹配
            [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:NDappLanguage];
        }else if([language hasPrefix:@"en"]){
            [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:NDappLanguage];
        }
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}

-(void)goToPasswordViewController{
    self.window.rootViewController = nil;
    
    InputLoginPsdViewController *ilVC = [[InputLoginPsdViewController alloc]init];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:ilVC];
    self.window.rootViewController = navController;
}

-(void)goToMainViewController{
    self.window.rootViewController = nil;
    
    BL_WalletId = [BLWalletDBManager getWalletId];
    [BLDBManager initDBSettings];
    
    _customTabBarController = [[CustomTabBarViewController alloc]init];
    self.window.rootViewController = _customTabBarController;
}

-(void)goToLoginViewController{
    self.window.rootViewController = nil;
    
    BLLoginViewController *loginMVC   = [[BLLoginViewController alloc]init];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:loginMVC];
    self.window.rootViewController = navController;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
