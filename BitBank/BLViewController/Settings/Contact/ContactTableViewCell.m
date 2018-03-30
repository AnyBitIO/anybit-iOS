//
//  ContactTableViewCell.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/8.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "ContactTableViewCell.h"
#import "Masonry.h"

@implementation ContactTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){

        self.backgroundColor = [UIColor clearColor];
        
        _nickNameLab = [UILabel new];
        _nickNameLab.font = SYS_FONT(16);
        _nickNameLab.textColor = UIColorFromRGB(0x333333);
        [self.contentView addSubview:_nickNameLab];
        
        _addressLab = [UILabel new];
        _addressLab.font = SYS_FONT(12);
        _addressLab.textColor = UIColorFromRGB(0x9a9a9a);
        [self.contentView addSubview:_addressLab];
        
        
        _coinView = [[CoinView alloc]initWithFrame:CGRectMake(kMainScreenWidth-100,10, 90, 30) coinType:@""];
        [self.contentView addSubview:_coinView];
        
        
        [_nickNameLab mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(self.contentView.top).offset(10);
             make.left.equalTo(self.contentView.left).offset(20);
             make.right.lessThanOrEqualTo(_coinView.left).offset(-15);
             make.bottom.equalTo(_addressLab.top).offset(-5);
         }];
        
        [_addressLab mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.left.equalTo(self.contentView.left).offset(20);
             make.right.lessThanOrEqualTo(_coinView.left).offset(-15);
             make.bottom.equalTo(self.contentView.bottom).offset(-10).priorityHigh();
         }];
        
        [_coinView mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(self.contentView.top).offset(15);
             make.bottom.equalTo(self.contentView.bottom).offset(-15).priorityHigh();
             make.right.equalTo(self.contentView.right).offset(-10);
             make.width.equalTo(90);
             make.height.equalTo(30);
         }];
    }
    return self;
}


-(void)setContentWithModel:(ContactModel*)model{
    
    _nickNameLab.text = model.nickName;
    _addressLab.text = model.address;
    [_coinView setCoinType:model.coinType];
    
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
