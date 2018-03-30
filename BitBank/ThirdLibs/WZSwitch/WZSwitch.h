//
//  WZSwitch.h
//  CFInterview
//
//  Created by Cflower on 2017/12/13.
//  Copyright © 2017年 golo.@golo365.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SwitchSelectBlock)(BOOL state);

@interface WZSwitch : UIView

@property(nonatomic,strong)NSString         *leftString;    //左侧显示的字符串

@property(nonatomic,strong)NSString         *rightString;   //右侧显示的字符串

@property(nonatomic,strong)UIColor          *selectColor;   //选中的字体颜色

@property(nonatomic,strong)UIColor          *unselectColor; //未选中时候的字体颜色

@property(nonatomic,strong)UIColor          *moveViewColor;      //上面漂浮的块颜色

@property(nonatomic,strong)UIFont           *textFont;          //字体大小，统一的

@property(nonatomic,assign,readonly)BOOL    on;             //是否选中

@property(nonatomic,copy)SwitchSelectBlock      block;      //选中后的回调
@property(nonatomic,assign)BOOL                 enable;     //是否能用  默认能用
//设置选中状态
-(void)setSwitchState:(BOOL)state animation:(BOOL)animation;
@end
