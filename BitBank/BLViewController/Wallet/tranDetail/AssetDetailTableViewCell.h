//
//  AssetDetailTableViewCell.h
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/12.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetDetailTableViewCell : UITableViewCell

@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIView *verticalView;
@property(nonatomic,strong)UILabel *adddressLab;
@property(nonatomic,strong)UILabel *countLab;
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)UILabel *timeLab;
@property(nonatomic,strong)UILabel *stateLab;

-(void)setContentWithArray:(NSMutableArray *)array indexPath:(NSIndexPath*)indexPath;

@end
