//
//  ChangePasswordViewController.h
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/8.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLBaseViewController.h"

typedef NS_ENUM (NSInteger, BLChangePasswordType){
    BLChangePassword_Login,
    BLChangePassword_Pay
};

@interface ChangePasswordViewController : BLBaseViewController

-(id)initWithType:(BLChangePasswordType)type;

@end
