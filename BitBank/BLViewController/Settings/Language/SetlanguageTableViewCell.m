//
//  SetlanguageTableViewCell.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/1.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "SetlanguageTableViewCell.h"

@implementation SetlanguageTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        
        self.backgroundColor = [UIColor clearColor];

        _bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, kMainScreenWidth-20, 60)];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
        
        _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, _bgView.frame.size.width-48, 20)];
        _titleLab.font = SYS_FONT(15);
        _titleLab.textColor = UIColorFromRGB(0x666666);
        [_bgView addSubview:_titleLab];
        
        _selectedView = [[UIImageView alloc]initWithFrame:CGRectMake(_bgView.frame.size.width-38, 24, 18, 12)];
        _selectedView.image = ImageNamed(@"selected");
        [_bgView addSubview:_selectedView];

        _lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 59.5, _bgView.frame.size.width-20, 0.5)];
        _lineView.backgroundColor = LINE_COLOR;
        [_bgView addSubview:_lineView];
    }
    return self;
}


-(void)setContentWithIndexPath:(NSIndexPath*)indexPath selectRow:(NSInteger)selectRow{
    
    if (indexPath.row == 0) {
        _lineView.hidden = NO;
        _titleLab.text = Localized(@"set_simpleChinese");
        _selectedView.hidden = (selectRow == indexPath.row)?NO:YES;
        
    } else if (indexPath.row == 1) {
        _lineView.hidden = YES;
        _titleLab.text = Localized(@"set_english");
        _selectedView.hidden = (selectRow == indexPath.row)?NO:YES;
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

@end
