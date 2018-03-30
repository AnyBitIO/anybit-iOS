//
//  FeeNoticeTableViewCell.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/12.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "FeeNoticeTableViewCell.h"

@implementation FeeNoticeTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        _bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth-20, 60)];
        _bgView.backgroundColor = [UIColor clearColor];
        _bgView.userInteractionEnabled = YES;
        _bgView.image = ImageNamed(@"list_upper_square");
        [self.contentView addSubview:_bgView];
        
        _noticeLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, _bgView.frame.size.width-35, 30)];
        _noticeLab.font = SYS_FONT(11);
        _noticeLab.textColor = UIColorFromRGB(0xd12323);
        _noticeLab.text = Localized(@"wallet_fee_notice");
        _noticeLab.numberOfLines = 0;
        [_bgView addSubview:_noticeLab];
    }
    return self;
}


@end
