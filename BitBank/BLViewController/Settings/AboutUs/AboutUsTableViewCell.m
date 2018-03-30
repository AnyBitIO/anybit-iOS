//
//  AboutUsTableViewCell.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/26.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "AboutUsTableViewCell.h"

@implementation AboutUsTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        
        self.backgroundColor = [UIColor clearColor];
        
        _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, 220, 20)];
        _titleLab.font = SYS_FONT(15);
        _titleLab.textColor = UIColorFromRGB(0x666666);
        [self.contentView addSubview:_titleLab];
        
        _arrowView = [[UIImageView alloc]initWithFrame:CGRectMake((kMainScreenWidth-40)-23, 22, 9, 16)];
        _arrowView.image = ImageNamed(@"rightArrow");
        [self.contentView addSubview:_arrowView];
    
        
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 59.5, (kMainScreenWidth-40)-30, 0.5)];
        _lineView.backgroundColor = UIColorFromRGB(0xE9F6FF);
        [self.contentView addSubview:_lineView];
    }
    return self;
}


-(void)setContentWithIndexPath:(NSIndexPath*)indexPath{
    
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        _titleLab.text = Localized(@"set_terms_of_use");
    }else if (indexPath.row == 1){
        _titleLab.text = Localized(@"set_privacy_policy");
    }else if (indexPath.row == 2){
        _titleLab.text = Localized(@"set_contact_us");
    }else if (indexPath.row == 3){
        _titleLab.text = Localized(@"set_recommend_share");
    }
}
@end
