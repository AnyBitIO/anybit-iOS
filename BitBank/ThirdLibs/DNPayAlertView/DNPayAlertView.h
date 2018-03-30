//
//  DNPayAlertView.h
//  DNPayAlertDemo
//
//  Created by dawnnnnn on 15/12/9.
//  Copyright © 2015年 dawnnnnn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DNPayAlertView : UIViewController

@property (nonatomic, copy) void (^payAlertViewSuccessBlock)(NSString *word);
@property (nonatomic, copy) void (^payAlertViewCloseBlock)(void);

- (void)show;

@end

NS_ASSUME_NONNULL_END
