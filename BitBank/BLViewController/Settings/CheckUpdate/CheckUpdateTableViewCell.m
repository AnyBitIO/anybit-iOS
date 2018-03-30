//
//  CheckUpdateTableViewCell.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/14.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "CheckUpdateTableViewCell.h"

@implementation CheckUpdateTableViewCell

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
        
        _updateLab = [[UILabel alloc]initWithFrame:CGRectMake((kMainScreenWidth-40)-57, 22, 42, 20)];
        _updateLab.font = SYS_FONT(12);
        _updateLab.textColor = [UIColor whiteColor];
        _updateLab.backgroundColor = UIColorFromRGB(0xD12323);
        _updateLab.text = Localized(@"set_update");
        _updateLab.textAlignment = NSTextAlignmentCenter;
        _updateLab.layer.cornerRadius = 5;
        _updateLab.layer.borderWidth  = 2;
        _updateLab.layer.borderColor = UIColorFromRGB(0xD12323).CGColor;
        _updateLab.layer.masksToBounds = YES;
        [self.contentView addSubview:_updateLab];
        
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 59.5, (kMainScreenWidth-40)-30, 0.5)];
        _lineView.backgroundColor = UIColorFromRGB(0xE9F6FF);
        [self.contentView addSubview:_lineView];
    }
    return self;
}


-(void)setContentWithIndexPath:(NSIndexPath*)indexPath isNewest:(BOOL)isNewest{
    
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0) {
        _titleLab.text = Localized(@"set_version_log");
        _arrowView.hidden = NO;
        _updateLab.hidden = YES;
    }else if (indexPath.row == 1){
        _titleLab.text = Localized(@"set_update_version");
        _arrowView.hidden = YES;
        if (isNewest) {
            _updateLab.hidden = YES;
        }else{
            _updateLab.hidden = NO;
        }
    }
}


@end
