//
//  AppDelegate.h
//  BitBank
//
//  Created by 张蒙蒙 on 2018/2/7.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabBarViewController.h"

#define BLAPPDELEGATE   ((AppDelegate *)[UIApplication sharedApplication].delegate)

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CustomTabBarViewController *customTabBarController;

-(void)goToLoginViewController;

-(void)goToMainViewController;

@end

