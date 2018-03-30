//
//  AssetDetailTableViewCell.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/12.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "AssetDetailTableViewCell.h"
#import "Masonry.h"
#import "NSDate+Utility.h"
#import "TranModel.h"

@implementation AssetDetailTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        
        self.backgroundColor = [UIColor clearColor];
        
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
        
        _verticalView = [[UIView alloc]init];
        [_bgView addSubview:_verticalView];
        
        _adddressLab = [[UILabel alloc]init];
        _adddressLab.font = SYS_FONT(15);
        _adddressLab.textColor = UIColorFromRGB(0x666666);
        [_bgView addSubview:_adddressLab];
        
        _countLab = [[UILabel alloc]init];
        _countLab.font = SYS_BOLD_FONT(15);
        _countLab.textColor = UIColorFromRGB(0x666666);
        [_bgView addSubview:_countLab];
        
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = UIColorFromRGB(0xDEF0FC);
        [_bgView addSubview:_lineView];
        
        _timeLab = [[UILabel alloc]init];
        _timeLab.font = SYS_FONT(12);
        _timeLab.textColor = UIColorFromRGB(0xdddddd);
        [_bgView addSubview:_timeLab];
        
        _stateLab = [[UILabel alloc]init];
        _stateLab.font = SYS_FONT(15);
        [_bgView addSubview:_stateLab];
        
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.contentView.top).offset(0);
            make.bottom.equalTo(self.contentView.bottom).offset(0).priorityHigh();
            make.left.equalTo(self.contentView.left).offset(10);
            make.right.equalTo(self.contentView.right).offset(-10);
            make.height.equalTo(90);
        }];
        
        [_verticalView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(_bgView.top).offset(0);
            make.bottom.equalTo(_bgView.bottom).offset(0).priorityHigh();
            make.left.equalTo(_bgView.left).offset(0);
            make.width.equalTo(3);
            make.height.equalTo(90);
        }];
        
        [_adddressLab mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(_bgView.top).offset(15);
            make.bottom.equalTo(_lineView.top).offset(-15);
            make.left.equalTo(_verticalView.right).offset(15);
            make.right.lessThanOrEqualTo(_countLab.left).offset(-15);
        }];
        
        [_countLab mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(_bgView.top).offset(15);
             make.bottom.equalTo(_lineView.top).offset(-15);
             make.right.equalTo(_bgView.right).offset(-15);
         }];
        
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_bgView.left).offset(10);
            make.right.equalTo(_bgView.right).offset(-10);
            make.height.equalTo(0.5);
        }];
        
        [_timeLab mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(_lineView.bottom).offset(5);
            make.bottom.equalTo(_bgView.bottom).offset(-5);
            make.left.equalTo(_verticalView.right).offset(15);
            make.right.lessThanOrEqualTo(_stateLab.left).offset(15);
            
        }];
        
        [_stateLab mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(_lineView.bottom).offset(5);
             make.bottom.equalTo(_bgView.bottom).offset(-5);
             make.right.equalTo(_bgView.right).offset(-15);
         }];
        
        [_countLab setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_countLab setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        
    }
    return self;
}


-(void)setContentWithArray:(NSMutableArray *)array indexPath:(NSIndexPath*)indexPath{
    
    TranModel *model = [array objectAtIndex:indexPath.section];

    if ([model.tranState isEqualToString:@"1"]) {
        _stateLab.text = Localized(@"wallet_tran_check");
        _stateLab.textColor = UIColorFromRGB(0xE60012);
        _verticalView.backgroundColor = UIColorFromRGB(0xE60012);
    }else if ([model.tranState isEqualToString:@"2"]) {
        _stateLab.text = Localized(@"wallet_tran_succress");
        _stateLab.textColor = UIColorFromRGB(0x22AC38);
        _verticalView.backgroundColor = UIColorFromRGB(0x22AC38);
    }else{
        _stateLab.text = Localized(@"wallet_tran_invalid");
        _stateLab.textColor = UIColorFromRGB(0x22AC38);
        _verticalView.backgroundColor = UIColorFromRGB(0x22AC38);
    }
    
    _adddressLab.text = model.targetAddr;
    
    if ([model.tranType isEqualToString:@"1"]) {
        _countLab.textColor = UIColorFromRGB(0x22AC38);
        _countLab.text = [NSString stringWithFormat:@"-%@",model.tranAmt];
    }else{
        _countLab.textColor = UIColorFromRGB(0xE60012);
        _countLab.text = [NSString stringWithFormat:@"+%@",model.tranAmt];
    }
    
    
    _timeLab.text = [NSDate timeStrForListWithNSTimeIntervalStringStr:model.createTime];


    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    // Make sure the contentView does a layout pass here so that its subviews have their frames set, which we
    // need to use to set the preferredMaxLayoutWidth below.
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    // Set the preferredMaxLayoutWidth of the mutli-line bodyLabel based on the evaluated width of the label's frame,
    // as this will allow the text to wrap correctly, and as a result allow the label to take on the correct height.
}

@end
