//
//  ExportPrivatekeyTableViewCell.h
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/14.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoinView.h"

@interface ExportPrivatekeyTableViewCell : UITableViewCell

@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)CoinView *coinView;
@property(nonatomic,strong)UIImageView *arrowView;
@property(nonatomic,strong)UIView *lineView;

-(void)setContentWithArray:(NSArray*)array indexPath:(NSIndexPath*)indexPath;

@end
