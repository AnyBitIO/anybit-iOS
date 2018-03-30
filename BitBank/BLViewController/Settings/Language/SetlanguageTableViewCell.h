//
//  SetlanguageTableViewCell.h
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/1.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetlanguageTableViewCell : UITableViewCell

@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UIImageView *selectedView;
@property(nonatomic,strong)UIView *lineView;

-(void)setContentWithIndexPath:(NSIndexPath*)indexPath selectRow:(NSInteger)selectRow;

@end
