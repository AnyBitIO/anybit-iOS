//
//  SettingTableViewCell.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/2/28.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "SettingTableViewCell.h"
#import "BLWalletDBManager.h"

@implementation SettingTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        
        self.backgroundColor = [UIColor clearColor];
        
        _bgView = [[UIImageView alloc]init];
        _bgView.backgroundColor = [UIColor clearColor];
        _bgView.userInteractionEnabled = YES;
        [self.contentView addSubview:_bgView];
        
        _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 40, 40)];
        _headImageView.backgroundColor = [UIColor clearColor];
        _headImageView.userInteractionEnabled = YES;
        [_bgView addSubview:_headImageView];

        _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, _bgView.frame.size.width-90, 20)];
        _titleLab.font = SYS_FONT(17);
        _titleLab.textColor = UIColorFromRGB(0x333333);
        [_bgView addSubview:_titleLab];

        _loginSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(_bgView.frame.size.width-60, 15, 40, 30)];
        [_bgView addSubview:_loginSwitch];
        
        _arrowView = [[UIImageView alloc]initWithFrame:CGRectMake(_bgView.frame.size.width-24, 22, 9, 16)];
        _arrowView.image = ImageNamed(@"rightArrow");
        [_bgView addSubview:_arrowView];
        
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 59.5, _bgView.frame.size.width-30, 0.5)];
        _lineView.backgroundColor = LINE_COLOR;
        [_bgView addSubview:_lineView];
    }
    return self;
}


-(void)setSettingVCContentWithIndexPath:(NSIndexPath*)indexPath{
    
    _loginSwitch.hidden = YES;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        _headImageView.hidden = NO;
        _bgView.frame = CGRectMake(10, 0, kMainScreenWidth-20, 80);
        _headImageView.frame = CGRectMake(15, 20, 40, 40);
        _titleLab.frame = CGRectMake(70, 30, _bgView.frame.size.width-90, 20);
        _arrowView.frame = CGRectMake(_bgView.frame.size.width-24, 32, 9, 16);
        _lineView.frame = CGRectMake(15, 79.5, _bgView.frame.size.width-30, 0.5);
    }else{
        _headImageView.hidden = YES;
        _bgView.frame = CGRectMake(10, 0, kMainScreenWidth-20, 60);
        _titleLab.frame = CGRectMake(15, 20, _bgView.frame.size.width-90, 20);
        _arrowView.frame = CGRectMake(_bgView.frame.size.width-24, 22, 9, 16);
        _lineView.frame = CGRectMake(15, 59.5, _bgView.frame.size.width-30, 0.5);
    }

    if (indexPath.section == 0){
        if (indexPath.row == 0) {
            _lineView.hidden = NO;
            _headImageView.image = ImageNamed(@"headUrl");
            _titleLab.text = [BLWalletDBManager getWalletName];
            _bgView.image = ImageNamed(@"list_lower_square");
        }else{
            _lineView.hidden = YES;
            _titleLab.text = Localized(@"bl_contact");
            _bgView.image = ImageNamed(@"list_upper_square");
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            _lineView.hidden = NO;
            _titleLab.text = Localized(@"setting_security");
            _bgView.image = ImageNamed(@"list_lower_square");
        }else if (indexPath.row == 1){
            _lineView.hidden = NO;
            _titleLab.text = Localized(@"setting_coin");
            _bgView.image = ImageNamed(@"list_square");
        }else if (indexPath.row == 2){
            _lineView.hidden = YES;
            _titleLab.text = Localized(@"set_language");
            _bgView.image = ImageNamed(@"list_upper_square");
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            _lineView.hidden = NO;
            _titleLab.text = Localized(@"setting_FAQ");
            _bgView.image = ImageNamed(@"list_lower_square");
        }else if (indexPath.row == 1){
            _lineView.hidden = NO;
            _titleLab.text = Localized(@"setting_about_us");
            _bgView.image = ImageNamed(@"list_square");
        }else if (indexPath.row == 2){
            _lineView.hidden = YES;
            _titleLab.text = Localized(@"setting_check_update");
            _bgView.image = ImageNamed(@"list_upper_square");
        }
    }
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setSecurityVCContentWithIndexPath:(NSIndexPath*)indexPath{
    _headImageView.hidden = YES;
    
    _bgView.frame = CGRectMake(10, 0, kMainScreenWidth-20, 60);
    _titleLab.frame = CGRectMake(15, 20, _bgView.frame.size.width-90, 20);
    _loginSwitch.frame = CGRectMake(_bgView.frame.size.width-60, 15, 40, 30);
    _arrowView.frame = CGRectMake(_bgView.frame.size.width-24, 22, 9, 16);
    _lineView.frame = CGRectMake(15, 59.5, _bgView.frame.size.width-30, 0.5);
    
    if (indexPath.row == 0) {
        _lineView.hidden = NO;
        _arrowView.hidden = NO;
        _loginSwitch.hidden = YES;
        _titleLab.text = Localized(@"setting_change_loginPsd");
        _bgView.image = ImageNamed(@"list_lower_square");
    }else if (indexPath.row == 1){
        _lineView.hidden = NO;
        _arrowView.hidden = NO;
        _loginSwitch.hidden = YES;
        _titleLab.text = Localized(@"setting_change_payPsd");
        _bgView.image = ImageNamed(@"list_square");

    }else if (indexPath.row == 2){
        _lineView.hidden = YES;
        _arrowView.hidden = YES;
        _loginSwitch.hidden = NO;
        _titleLab.text = Localized(@"setting_need_login");
        _bgView.image = ImageNamed(@"list_upper_square");
        [_loginSwitch setOn:[BLWalletDBManager getWalletNeedLoginPassword]];
    }
    
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
