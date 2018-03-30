//
//  SetPayPsdViewController.h
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/5.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLBaseViewController.h"

@interface SetPayPsdViewController : BLBaseViewController

-(id)initWithIsRecover:(BOOL)isRecover
         mnemonicWords:(NSString *)mnemonicWords
            walletName:(NSString*)walletName
              loginPsd:(NSString *)loginPsd;

@end
