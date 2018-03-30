//
//  TranDetailTableViewCell.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/13.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "TranDetailTableViewCell.h"
#import "Masonry.h"
#import "NSDate+Utility.h"

@implementation TranDetailTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        _bgView = [[UIImageView alloc]init];
        [self.contentView addSubview:_bgView];
        
        _titleLab = [UILabel new];
        _titleLab.font = SYS_FONT(16);
        _titleLab.textColor = UIColorFromRGB(0x333333);
        [_bgView addSubview:_titleLab];
        
        _detailLab = [UILabel new];
        _detailLab.font = SYS_FONT(16);
        _detailLab.textColor = UIColorFromRGB(0xbababa);
        _detailLab.numberOfLines = 0;
        _detailLab.textAlignment = NSTextAlignmentRight;
        [_bgView addSubview:_detailLab];
        
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = UIColorFromRGB(0xDEF0FC);
        [_bgView addSubview:_lineView];
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(self.contentView.top).offset(0);
             make.left.equalTo(self.contentView.left).offset(0);
             make.right.equalTo(self.contentView.right).offset(0);
             make.bottom.equalTo(self.contentView.bottom).offset(0).priorityHigh();
         }];
        
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.centerY.equalTo(_bgView.centerY);
             make.left.equalTo(_bgView.left).offset(15);
             make.right.lessThanOrEqualTo(_detailLab.left).offset(-15);
         }];
        
        [_detailLab mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(_bgView.top).offset(15);
             make.bottom.equalTo(_bgView.bottom).offset(-15).priorityHigh();
             make.right.equalTo(_bgView.right).offset(-15);
         }];
        
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.bottom.equalTo(_bgView.bottom).offset(-0.5);
             make.left.equalTo(_bgView.left).offset(15);
             make.right.equalTo(_bgView.right).offset(-15);
             make.height.equalTo(0.5);
         }];
        
//        [_detailLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
//        [_detailLab setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        
    }
    return self;
}

-(void)setContentWithModel:(TranModel*)model indexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row == 0) {
        _bgView.image = ImageNamed(@"list_square");
        _titleLab.text = Localized(@"wallet_tran_time");
        _lineView.hidden = NO;
        _detailLab.text = [NSDate timeStrForListWithNSTimeIntervalStringStr:model.createTime];
        _detailLab.textColor = UIColorFromRGB(0xbababa);
    }else if (indexPath.row == 1) {
        _bgView.image = ImageNamed(@"list_square");
        _titleLab.text = Localized(@"wallet_tran_type");
        _lineView.hidden = NO;
        if ([model.tranType isEqualToString:@"1"]) {
            _detailLab.text = Localized(@"wallet_fuKuan");
        }else{
            _detailLab.text = Localized(@"wallet_shouKuan");
        }
        _detailLab.textColor = UIColorFromRGB(0xbababa);
    }else if (indexPath.row == 2) {
        _bgView.image = ImageNamed(@"list_square");
        _titleLab.text = Localized(@"wallet_tran_address");
        _lineView.hidden = NO;
        _detailLab.text = model.targetAddr;
        _detailLab.textColor = UIColorFromRGB(0xbababa);
    }else if (indexPath.row == 3) {
        _bgView.image = ImageNamed(@"list_square");
        _titleLab.text = Localized(@"wallet_tran_remark");
        _lineView.hidden = NO;
        _detailLab.text = model.bak;
        _detailLab.textColor = UIColorFromRGB(0xbababa);
    }else if (indexPath.row == 4) {
        _bgView.image = ImageNamed(@"list_square");
        _titleLab.text = Localized(@"wallet_tranId");
        _lineView.hidden = NO;
        _detailLab.text = model.txId;
        _detailLab.textColor = UIColorFromRGB(0x03A4FF);
    }else if (indexPath.row == 5) {
        _bgView.image = ImageNamed(@"list_upper_square");
        _titleLab.text = Localized(@"wallet_tran_status");
        _lineView.hidden = YES;
        if ([model.tranState isEqualToString:@"1"]) {
            _detailLab.text = Localized(@"wallet_tran_check");
            _detailLab.textColor = UIColorFromRGB(0xE60012);
        }else if ([model.tranState isEqualToString:@"2"]) {
            _detailLab.text = Localized(@"wallet_tran_succress");
            _detailLab.textColor = UIColorFromRGB(0x22AC38);
        }else{
            _detailLab.text = Localized(@"wallet_tran_invalid");
            _detailLab.textColor = UIColorFromRGB(0x22AC38);
        }
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
