//
//  CheckUpdateTableViewCell.h
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/14.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckUpdateTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UIImageView *arrowView;
@property(nonatomic,strong)UILabel *updateLab;
@property(nonatomic,strong)UIView *lineView;

-(void)setContentWithIndexPath:(NSIndexPath*)indexPath isNewest:(BOOL)isNewest;

@end
