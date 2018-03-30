//
//  BLContactViewController.h
//  BitBank
//
//  Created by 张蒙蒙 on 2018/2/28.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLBaseViewController.h"

typedef void (^GetAddressBlock)(NSString *address);

@interface BLContactViewController : BLBaseViewController

-(id)initWithCoinType:(NSString *)coinType block:(GetAddressBlock)block;

@end
