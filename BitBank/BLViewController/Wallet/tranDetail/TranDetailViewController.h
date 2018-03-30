//
//  TranDetailViewController.h
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/13.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLBaseViewController.h"
#import "TranModel.h"

@interface TranDetailViewController : BLBaseViewController

-(id)initWithModel:(TranModel*)model coinType:(NSString *)coinType;

@end
