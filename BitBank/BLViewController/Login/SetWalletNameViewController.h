//
//  SetWalletNameViewController.h
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/26.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLBaseViewController.h"

@interface SetWalletNameViewController : BLBaseViewController

-(id)initWithIsRecover:(BOOL)isRecover mnemonicWords:(NSString *)mnemonicWords;

@end
