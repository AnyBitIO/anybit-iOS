//
//  NoCopyPasteTextView.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/2.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "NoCopyPasteTextView.h"

@implementation NoCopyPasteTextView

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController){
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
