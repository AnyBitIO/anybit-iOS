//
//  BLWalletTableViewCell.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/12.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "BLWalletTableViewCell.h"

@implementation BLWalletTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        
        _coinView = [[CoinView alloc]initWithFrame:CGRectMake(((kMainScreenWidth-20)/3-90)/2,10, 90, 30) coinType:@""];
        [self.contentView addSubview:_coinView];
        
        _countLab = [[UILabel alloc]initWithFrame:CGRectMake((kMainScreenWidth-20)/3, 0, (kMainScreenWidth-20)/3, 50)];
        _countLab.font = SYS_FONT(15);
        _countLab.textColor = UIColorFromRGB(0x666666);
        _countLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_countLab];
        
        _assetsLab = [[UILabel alloc]initWithFrame:CGRectMake((kMainScreenWidth-20)/3*2, 0, (kMainScreenWidth-20)/3, 50)];
        _assetsLab.font = SYS_FONT(15);
        _assetsLab.textColor = UIColorFromRGB(0x666666);
        _assetsLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_assetsLab];
    
    }
    return self;
}


-(void)setContentWithArray:(NSMutableArray *)array indexPath:(NSIndexPath*)indexPath iscnyAmt:(BOOL)iscnyAmt{
    
    if (indexPath.row/2 == 0) {
        self.contentView.backgroundColor = UIColorFromRGB(0xf1f6fe);
    }else {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    NSDictionary *dic = [array objectAtIndex:indexPath.row];
    
    [_coinView setCoinType:[dic objectForKey:@"coinType"]];
    
    _countLab.text = [dic objectForKey:@"num"];
    
    if (iscnyAmt) {
        _assetsLab.text = [NSString stringWithFormat:@"≈¥%@",[dic objectForKey:@"cnyAmt"]];
    }else{
        _assetsLab.text = [NSString stringWithFormat:@"≈$%@",[dic objectForKey:@"usdtAmt"]];
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleBlue;
    self.accessoryType = UITableViewCellAccessoryNone;
        
}

@end
