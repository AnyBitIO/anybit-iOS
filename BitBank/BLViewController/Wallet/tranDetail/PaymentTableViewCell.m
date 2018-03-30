//
//  PaymentTableViewCell.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/12.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "PaymentTableViewCell.h"

@implementation PaymentTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        
        self.backgroundColor = [UIColor clearColor];
        
        _bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth-20, 60)];
        _bgView.backgroundColor = [UIColor clearColor];
        _bgView.userInteractionEnabled = YES;
        [self.contentView addSubview:_bgView];
        
        _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 50, 30)];
        _titleLab.font = SYS_FONT(15);
        _titleLab.textColor = UIColorFromRGB(0x666666);
        [_bgView addSubview:_titleLab];
        
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(80, 15, _bgView.frame.size.width-95, 30)];
        _textField.textColor = UIColorFromRGB(0xbababa);
        [_bgView addSubview:_textField];
        
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 59.5, _bgView.frame.size.width-20, 0.5)];
        _lineView.backgroundColor = UIColorFromRGB(0xDEF0FC);
        [_bgView addSubview:_lineView];
        
        _contactLogoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_contactLogoBtn setImage:ImageNamed(@"contactLogo") forState:UIControlStateNormal];
        [_contactLogoBtn addTarget:self action:@selector(contactButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_contactLogoBtn];
        
        _scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scanBtn setImage:ImageNamed(@"saomiao") forState:UIControlStateNormal];
        [_scanBtn addTarget:self action:@selector(scanButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_scanBtn];
        
        _iconLab = [[UILabel alloc]init];
        _iconLab.font = SYS_FONT(15);
        _iconLab.textColor = UIColorFromRGB(0x666666);
        _iconLab.textAlignment = NSTextAlignmentRight;
        [_bgView addSubview:_iconLab];
      
        _reduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reduceBtn setImage:ImageNamed(@"reduceFee") forState:UIControlStateNormal];
        [_reduceBtn addTarget:self action:@selector(reduceButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_reduceBtn];
        
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setImage:ImageNamed(@"addFee") forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_addBtn];
    }
    return self;
}


-(void)setContentWithIndexPath:(NSIndexPath*)indexPath coinType:(NSString*)coinType{
    if (indexPath.row == 0) {
        _addBtn.hidden = YES;
        _reduceBtn.hidden = YES;
        _contactLogoBtn.hidden = NO;
        _iconLab.hidden = YES;
        
        _bgView.image = ImageNamed(@"list_lower_square");
        
        _titleLab.frame = CGRectMake(15, 15, 60, 30);
        _titleLab.text = Localized(@"wallet_addeess");
    
        _textField.keyboardType = UIKeyboardTypeASCIICapable;
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.frame = CGRectMake(90, 15, _bgView.frame.size.width-95-5-45-45, 30);
        
        _scanBtn.frame = CGRectMake(_bgView.frame.size.width-90, 15, 30, 30);
        _contactLogoBtn.frame = CGRectMake(_bgView.frame.size.width-45, 15, 30, 30);
    } else if (indexPath.row == 1) {
        _addBtn.hidden = YES;
        _reduceBtn.hidden = YES;
        _contactLogoBtn.hidden = YES;
        _iconLab.hidden = NO;
        
        _bgView.image = ImageNamed(@"list_square");
        
        _titleLab.frame = CGRectMake(15, 15, 60, 30);
        _titleLab.text = Localized(@"wallet_money");
        
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.keyboardType = UIKeyboardTypeDecimalPad;
        _textField.frame = CGRectMake(90, 15, _bgView.frame.size.width-95-5-65, 30);
        
        _iconLab.text = coinType;
        _iconLab.frame = CGRectMake(_bgView.frame.size.width-65, 15, 50, 30);
    }else if (indexPath.row == 2) {
        _addBtn.hidden = YES;
        _reduceBtn.hidden = YES;
        _contactLogoBtn.hidden = YES;
        _iconLab.hidden = YES;
        
        _bgView.image = ImageNamed(@"list_square");
        
        _titleLab.frame = CGRectMake(15, 15, 60, 30);
        _titleLab.text = Localized(@"wallet_remark");
        
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.keyboardType = UIKeyboardTypeDefault;
        _textField.frame = CGRectMake(90, 15, _bgView.frame.size.width-105, 30);
    }else if (indexPath.row == 3) {
        _addBtn.hidden = NO;
        _reduceBtn.hidden = NO;
        _contactLogoBtn.hidden = YES;
        _iconLab.hidden = NO;
        _bgView.image = ImageNamed(@"list_square");
        
        _titleLab.frame = CGRectMake(15, 15, 50, 30);
        _titleLab.text = Localized(@"wallet_fee");
        
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.text = @"0.0001";
        _textField.keyboardType = UIKeyboardTypeDecimalPad;
        _textField.frame = CGRectMake(115, 15, _bgView.frame.size.width-115-5-30-5-65, 30);
        
        _reduceBtn.frame = CGRectMake(80, 15, 30, 30);
        _addBtn.frame = CGRectMake(_bgView.frame.size.width-65-5-30, 15, 30, 30);
        
        _iconLab.text = coinType;
        _iconLab.frame = CGRectMake(_bgView.frame.size.width-65, 15, 50, 30);
    }
    

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Make sure the contentView does a layout pass here so that its subviews have their frames set, which we
    // need to use to set the preferredMaxLayoutWidth below.
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    // Set the preferredMaxLayoutWidth of the mutli-line bodyLabel based on the evaluated width of the label's frame,
    // as this will allow the text to wrap correctly, and as a result allow the label to take on the correct height.
}

-(void)scanButtonClick{
    if (_delegate && [_delegate respondsToSelector:@selector(scanAddress)]){
        [_delegate scanAddress];
    }
}

-(void)contactButtonClick{
    if (_delegate && [_delegate respondsToSelector:@selector(selectContact)]){
        [_delegate selectContact];
    }
}

-(void)reduceButtonClick{
    if (_delegate && [_delegate respondsToSelector:@selector(reduceFee)]){
        [_delegate reduceFee];
    }
}

-(void)addButtonClick{
    if (_delegate && [_delegate respondsToSelector:@selector(addFee)]){
        [_delegate addFee];
    }
}

@end
