//
//  VersionLogTableViewCell.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/15.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "VersionLogTableViewCell.h"
//#import "Masonry.h"

@implementation VersionLogTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        
        self.backgroundColor = [UIColor clearColor];
        
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bgView];
        
        _titleLab = [[UILabel alloc]init];
        _titleLab.font = SYS_FONT(15);
        _titleLab.textColor = UIColorFromRGB(0xABABAB);
        _titleLab.numberOfLines = 0;
        [_bgView addSubview:_titleLab];
    }
    return self;
}


-(void)setContentWithArray:(NSArray*)array indexPath:(NSIndexPath*)indexPath{
    
    NSDictionary  *dic = [array objectAtIndex:indexPath.section];
    CGFloat height = [[dic objectForKey:@"height"] floatValue];
    
    _bgView.frame= CGRectMake(0, 0, kMainScreenWidth-20, height+20);
    
    _titleLab.frame= CGRectMake(20, 10, kMainScreenWidth-20-20*2, height);
    _titleLab.text = [dic objectForKey:@"content"];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;

}



@end
