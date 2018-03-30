//
//  SetDefaultCoinCell.h
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/8.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoinView.h"

@interface SetDefaultCoinCell : UITableViewCell

@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)CoinView *coinView;
@property(nonatomic,strong)UIImageView *selectedView;
@property(nonatomic,strong)UIView *lineView;

-(void)setContentWithArray:(NSArray*)array indexPath:(NSIndexPath*)indexPath;

@end
