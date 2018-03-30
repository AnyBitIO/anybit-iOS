//
//  ManagerCoinCell.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/5.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "ManagerCoinCell.h"
#import "CoinModel.h"

@implementation ManagerCoinCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        
        self.backgroundColor = [UIColor clearColor];
        
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, kMainScreenWidth-20, 60)];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
        
        _coinView = [[CoinView alloc]initWithFrame:CGRectMake(10,15, 90, 30) coinType:@""];
        [_bgView addSubview:_coinView];
        
        _coinSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(_bgView.frame.size.width-60, 15, 40, 30)];
        [_bgView addSubview:_coinSwitch];
        
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 59.5, _bgView.frame.size.width-20, 0.5)];
        _lineView.backgroundColor = LINE_COLOR;
        [_bgView addSubview:_lineView];
    }
    return self;
}


-(void)setContentWithArray:(NSMutableArray *)array indexPath:(NSIndexPath*)indexPath{

    CoinModel *model = [array objectAtIndex:indexPath.row];
    
    [_coinView setCoinType:model.coinType];
    
    if (array.count == indexPath.row+1){
        _lineView.hidden = YES;
    } else {
        _lineView.hidden = NO;
    }
    
    _coinSwitch.tag = indexPath.row+100;
    [_coinSwitch setOn:model.isSelect];
    
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
