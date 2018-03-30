//
//  SYPasswordView.h
//  PasswordDemo
//
//  Created by aDu on 2017/2/6.
//  Copyright © 2017年 DuKaiShun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoCopyPasteTextField.h"

@interface SYPasswordView : UIView<UITextFieldDelegate>

@property (nonatomic, strong) NoCopyPasteTextField *textField;


/**
 *  清除密码
 */
- (void)clearUpPassword;

@end
