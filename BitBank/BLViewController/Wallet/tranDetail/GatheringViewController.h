//
//  GatheringViewController.h
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/12.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLBaseViewController.h"

@interface GatheringViewController : BLBaseViewController

-(id)initWithCoinAddress:(NSString *)coinAddress coinType:(NSString *)coinType coinCount:(NSString *)coinCount;

@end
