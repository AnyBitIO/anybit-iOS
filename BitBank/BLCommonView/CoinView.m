//
//  CoinView.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/19.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "CoinView.h"

@implementation CoinView

-(id)initWithFrame:(CGRect)frame coinType:(NSString*)coinType{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        NSString *iconStr = [NSString stringWithFormat:@"coin_%@",coinType];
        _icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        _icon.image = ImageNamed(iconStr);
        [self addSubview:_icon];
        
        _coinLab = [[UILabel alloc]initWithFrame:CGRectMake(35, 5, 55, 20)];
        _coinLab.font = SYS_FONT(16);
        _coinLab.textColor = UIColorFromRGB(0x333333);
        _coinLab.text = coinType;
        _coinLab.backgroundColor = [UIColor clearColor];
        [self addSubview:_coinLab];
    }
    return self;
}

-(void)setCoinType:(NSString*)coinType{
    NSString *iconStr = [NSString stringWithFormat:@"coin_%@",coinType];
    _icon.image = ImageNamed(iconStr);
    _coinLab.text = coinType;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
