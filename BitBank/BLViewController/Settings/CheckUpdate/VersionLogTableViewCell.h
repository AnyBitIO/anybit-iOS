//
//  VersionLogTableViewCell.h
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/15.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VersionLogTableViewCell : UITableViewCell

@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UILabel *titleLab;

-(void)setContentWithArray:(NSArray*)array indexPath:(NSIndexPath*)indexPath;

@end
