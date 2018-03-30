//
//  SeedCollectionViewCell.h
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/27.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeedCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)UILabel *titleLabel;

-(void)setMnemonicWords:(NSDictionary*)dic;

@end
