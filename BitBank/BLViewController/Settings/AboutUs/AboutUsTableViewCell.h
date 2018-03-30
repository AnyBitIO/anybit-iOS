//
//  AboutUsTableViewCell.h
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/26.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutUsTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UIImageView *arrowView;
@property(nonatomic,strong)UIView *lineView;

-(void)setContentWithIndexPath:(NSIndexPath*)indexPath;


@end
