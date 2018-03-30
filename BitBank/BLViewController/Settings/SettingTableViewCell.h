//
//  SettingTableViewCell.h
//  BitBank
//
//  Created by 张蒙蒙 on 2018/2/28.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *bgView;
@property(nonatomic,strong)UIImageView *headImageView;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UISwitch *loginSwitch;
@property(nonatomic,strong)UIImageView *arrowView;
@property(nonatomic,strong)UIView *lineView;

-(void)setSettingVCContentWithIndexPath:(NSIndexPath*)indexPath;

-(void)setSecurityVCContentWithIndexPath:(NSIndexPath*)indexPath;

@end
