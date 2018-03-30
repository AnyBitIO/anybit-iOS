//
//  PaymentTableViewCell.h
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/12.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PaymentTableViewCellDeleagte <NSObject>

-(void)reduceFee;

-(void)addFee;

-(void)selectContact;

-(void)scanAddress;

@end


@interface PaymentTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *bgView;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UITextField *textField;
@property(nonatomic,strong)UIView *lineView;

@property(nonatomic,strong)UILabel *iconLab;
@property(nonatomic,strong)UIButton *contactLogoBtn;
@property(nonatomic,strong)UIButton *scanBtn;
@property(nonatomic,strong)UIButton *reduceBtn;
@property(nonatomic,strong)UIButton *addBtn;

@property(nonatomic,weak) id<PaymentTableViewCellDeleagte>delegate;

-(void)setContentWithIndexPath:(NSIndexPath*)indexPath coinType:(NSString*)coinType;


@end
