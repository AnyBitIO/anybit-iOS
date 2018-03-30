//
//  SelectCoinViewController.h
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/22.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLBaseViewController.h"

typedef void(^SelectCoinBlock)(NSString *coinType);

@interface SelectCoinViewController : BLBaseViewController

-(id)initWithBlcok:(SelectCoinBlock)block;

@end
