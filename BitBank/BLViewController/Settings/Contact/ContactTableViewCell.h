//
//  ContactTableViewCell.h
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/8.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactModel.h"
#import "CoinView.h"

@interface ContactTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *nickNameLab;
@property(nonatomic,strong)UILabel *addressLab;
@property(nonatomic,strong)CoinView *coinView;

-(void)setContentWithModel:(ContactModel*)model;

@end
