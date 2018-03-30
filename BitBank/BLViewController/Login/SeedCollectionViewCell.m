//
//  SeedCollectionViewCell.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/27.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "SeedCollectionViewCell.h"
#import "Masonry.h"
#import "NSString+Utility.h"

@implementation SeedCollectionViewCell

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = [UIColor clearColor];
        
        _titleLabel = [[UILabel alloc]initWithFrame:self.contentView.bounds];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = SYS_FONT(16);
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.layer.cornerRadius = 5.0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    // Make sure the contentView does a layout pass here so that its subviews have their frames set, which we
    // need to use to set the preferredMaxLayoutWidth below.
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    // Set the preferredMaxLayoutWidth of the mutli-line bodyLabel based on the evaluated width of the label's frame,
    // as this will allow the text to wrap correctly, and as a result allow the label to take on the correct height.
    //    self.cellTextLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.cellTextLabel.frame);
    //
    _titleLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.contentView.frame);
    
    [super layoutSubviews];
}

-(void)setMnemonicWords:(NSDictionary*)dic{
    _titleLabel.text = [dic objectForKey:@"name"];
    CGFloat seedWidth = [[dic objectForKey:@"name"] widthForHeight:25 withFont:SYS_FONT(16)];
    _titleLabel.frame = CGRectMake(0, 0, seedWidth+8, 25);
    
    if ([[dic objectForKey:@"select"] isEqualToString:@"1"]) {
        _titleLabel.backgroundColor = UIColorFromRGB(0x03A4FF);
    }else{
        _titleLabel.backgroundColor = [UIColor clearColor];
    }
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

@end
