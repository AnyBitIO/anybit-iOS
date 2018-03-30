//
//  AddUserViewController.h
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/9.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLBaseViewController.h"
#import "ContactModel.h"

typedef void(^AddUserBlock)(ContactModel *model);

@interface AddUserViewController : BLBaseViewController

-(id)initWithModel:(ContactModel*)model addUserBlock:(AddUserBlock)block;

@end
