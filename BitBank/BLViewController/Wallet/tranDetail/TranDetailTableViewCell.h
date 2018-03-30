//
//  TranDetailTableViewCell.h
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/13.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TranModel.h"

@interface TranDetailTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *bgView;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UILabel *detailLab;
@property(nonatomic,strong)UIView *lineView;

-(void)setContentWithModel:(TranModel*)model indexPath:(NSIndexPath*)indexPath;

@end
