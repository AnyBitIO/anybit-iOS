//
//  WZSwitch.m
//  CFInterview
//
//  Created by Cflower on 2017/12/13.
//  Copyright © 2017年 golo.@golo365.com. All rights reserved.
//

#import "WZSwitch.h"


@interface WZSwitch()

@property(nonatomic,strong)UIButton     *actionBtn;     //触发按钮

@property(nonatomic,strong)UIView       *moveView;      //移动的view

@property(nonatomic,strong)UILabel      *leftDownLable; //左侧的底部label

@property(nonatomic,strong)UILabel      *leftOnLabel;   //左侧上面的label

@property(nonatomic,strong)UILabel      *rightDownLable; //右侧的底部label

@property(nonatomic,strong)UILabel      *rightOnLabel;   //右侧上面的label

@property(nonatomic,strong)UIView       *grayView;      //蒙层
@end

@implementation WZSwitch

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        CGFloat width   = frame.size.width / 2;
        CGFloat height  = frame.size.height;
        
        _leftDownLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, height)];
        _leftDownLable.backgroundColor = [UIColor clearColor];
        _leftDownLable.text      = @"¥";
        _leftDownLable.textAlignment    = NSTextAlignmentCenter;
        _leftDownLable.textColor        = [UIColor whiteColor];
        [self addSubview:_leftDownLable];
        
        _rightDownLable = [[UILabel alloc]initWithFrame:CGRectMake(width, 0, width, height)];
        _rightDownLable.backgroundColor = [UIColor clearColor];
        _rightDownLable.text      = @"$";
        _rightDownLable.textAlignment    = NSTextAlignmentCenter;
        _rightDownLable.textColor        = [UIColor whiteColor];
        [self addSubview:_rightDownLable];
        
        UIView  *subView = [[UIView alloc]initWithFrame:self.bounds];
        
        [self addSubview:subView];
        
        
        
        _leftOnLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, height)];
        _leftOnLabel.backgroundColor = [UIColor whiteColor];
        _leftOnLabel.text      = @"¥";
        _leftOnLabel.textAlignment    = NSTextAlignmentCenter;
        _leftOnLabel.textColor        = UIColorFromRGB(0x7a88bb);
        [subView addSubview:_leftOnLabel];
        
        _rightOnLabel = [[UILabel alloc]initWithFrame:CGRectMake(width, 0, width, height)];
        _rightOnLabel.backgroundColor = [UIColor whiteColor];
        _rightOnLabel.text      = @"$";
        _rightOnLabel.textAlignment    = NSTextAlignmentCenter;
        _rightOnLabel.textColor        = UIColorFromRGB(0x7a88bb);
        [subView addSubview:_rightOnLabel];
        
        self.moveView   = [[UIView alloc]initWithFrame:CGRectMake(2, 2, width-4, height - 4)];
        self.moveView.layer.cornerRadius    = (height - 4)/2;
        self.moveView.clipsToBounds         = YES;
        self.moveView.backgroundColor       = [UIColor whiteColor];
        subView.maskView    = self.moveView;
        
        self.actionBtn = [[UIButton alloc]initWithFrame:self.bounds];
        self.actionBtn.backgroundColor = [UIColor clearColor];
        [self.actionBtn addTarget:self action:@selector(changeSwitchState:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.actionBtn];
        
        
        self.grayView   = [[UIView alloc]initWithFrame:self.bounds];
        self.grayView.backgroundColor = [UIColor grayColor];
        self.grayView.alpha = 0.7;
        self.grayView.hidden    = YES;
        [self addSubview:self.grayView];
        
        self.backgroundColor            = UIColorFromRGB(0x7a88bb);
        
        self.layer.cornerRadius = height/2;
        self.clipsToBounds  = YES;
        
        self.userInteractionEnabled = YES;
        
        [self setTextFont:[UIFont systemFontOfSize:15]];
        
        self.enable     = YES;
        
    }
    
    return self;
}

#pragma mark - 设置文字
-(void)setLeftString:(NSString *)leftString
{
    self.leftOnLabel.text = leftString;
    self.leftDownLable.text = leftString;
    
    _leftString             = leftString;
}

-(void)setRightString:(NSString *)rightString
{
    self.rightOnLabel.text = rightString;
    self.rightDownLable.text = rightString;
    
    _rightString             = rightString;
}

-(void)setSelectColor:(UIColor *)selectColor
{
    self.rightOnLabel.textColor = selectColor;
    self.leftOnLabel.textColor  = selectColor;
    
    _selectColor = selectColor;
}

-(void)setUnselectColor:(UIColor *)unselectColor
{

    self.rightDownLable.textColor   = unselectColor;
    self.leftDownLable.textColor    = unselectColor;
    
    _unselectColor                  = unselectColor;
}

-(void)setTextFont:(UIFont *)textFont
{
    self.rightOnLabel.font      = textFont;
    self.rightDownLable.font    = textFont;
    
    self.leftDownLable.font     = textFont;
    self.leftOnLabel.font       = textFont;
    
    _textFont                   = textFont;
}

-(void)setMoveViewColor:(UIColor *)moveViewColor
{
    self.rightOnLabel.backgroundColor   = moveViewColor;
    self.leftOnLabel.backgroundColor    = moveViewColor;
    
    _moveViewColor                      = moveViewColor;
}

-(void)setSwitchState:(BOOL)state animation:(BOOL)animation
{
    _on = state;
    
    self.actionBtn.selected = _on;
    
    [self startAnimationMoveView:_on animation:animation];
}

-(void)setEnable:(BOOL)enable
{
    _enable = enable;
    
    self.grayView.hidden    = enable;
}

#pragma mark - 按钮方法
-(void)changeSwitchState:(UIButton *)btn
{
    self.actionBtn.userInteractionEnabled   = NO;
    
    _on = !btn.selected;
    
    btn.selected = _on;
    
    [self startAnimationMoveView:_on animation:YES];
    
    if (self.block) {
        self.block(_on);
    }
    
    [self performSelector:@selector(changeActionBtnUseEnable) withObject:nil afterDelay:0.5f];
}

-(void)changeActionBtnUseEnable
{
    self.actionBtn.userInteractionEnabled = YES;
}

-(void)startAnimationMoveView:(BOOL)state animation:(BOOL)animation
{
    CGFloat width    = self.moveView.frame.size.width;
    CGFloat height   = self.frame.size.height;
    
    CGPoint dest = !state?CGPointMake(2+width/2, height/2):CGPointMake(6 + width*3/2, height/2);
    
    if (animation) {
        [UIView animateWithDuration:.4 animations:^{
            self.moveView.center = dest;
        }];
    }
    else
    {
        self.moveView.center = dest;
    }
    
}


@end
