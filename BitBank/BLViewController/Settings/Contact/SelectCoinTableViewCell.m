//
//  SelectCoinTableViewCell.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/22.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "SelectCoinTableViewCell.h"
#import "CoinModel.h"


@implementation SelectCoinTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        
        self.backgroundColor = [UIColor clearColor];
        
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, kMainScreenWidth-20, 60)];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
        
        _coinView = [[CoinView alloc]initWithFrame:CGRectMake(10,15, 90, 30) coinType:@""];
        [_bgView addSubview:_coinView];
        
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 59.5, _bgView.frame.size.width-20, 0.5)];
        _lineView.backgroundColor = LINE_COLOR;
        [_bgView addSubview:_lineView];
        
    }
    return self;
}


-(void)setContentWithArray:(NSArray*)array indexPath:(NSIndexPath*)indexPath{
    
    CoinModel *model = [array objectAtIndex:indexPath.row];
    [_coinView setCoinType:model.coinType];
    
    if (array.count == indexPath.row+1){
        _lineView.hidden = YES;
    } else {
        _lineView.hidden = NO;
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
}

@end
