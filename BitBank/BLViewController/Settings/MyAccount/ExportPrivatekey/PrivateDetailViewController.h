//
//  PrivateDetailViewController.h
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/14.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLBaseViewController.h"
#import "CoinModel.h"

@interface PrivateDetailViewController : BLBaseViewController

-(id)initWithModel:(CoinModel*)model payPsd:(NSString *)payPsd;

@end
