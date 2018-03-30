//
//  CoinView.h
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/19.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoinView : UIView

@property(nonatomic,strong)UILabel *coinLab;
@property(nonatomic,strong)UIImageView *icon;

-(id)initWithFrame:(CGRect)frame coinType:(NSString*)coinType;

-(void)setCoinType:(NSString*)coinType;

@end
