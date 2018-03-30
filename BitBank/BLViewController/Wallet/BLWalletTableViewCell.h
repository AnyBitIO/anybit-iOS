//
//  BLWalletTableViewCell.h
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/12.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoinView.h"

@interface BLWalletTableViewCell : UITableViewCell

@property(nonatomic,strong)CoinView *coinView;
@property(nonatomic,strong)UILabel *countLab;
@property(nonatomic,strong)UILabel *assetsLab;

-(void)setContentWithArray:(NSMutableArray *)array indexPath:(NSIndexPath*)indexPath iscnyAmt:(BOOL)iscnyAmt;

@end
