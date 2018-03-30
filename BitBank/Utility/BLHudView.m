//
//  BLHudView.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/6.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "BLHudView.h"

@implementation BLHudView

+ (instancetype)sharedBLHudView
{
    static BLHudView * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        _currentVC = nil;
        _timer = nil;
        _mbProgressHud = nil;
        _hudView = nil;
        _hudSubView = nil;
    }
    return self;
}

#pragma mark - class method -
+ (void)linkerEnableHUDShow
{
    [[BLHudView sharedBLHudView] showEnablelinkerHUD];
}

// 加载动画时 rightBarButton 默认可点
+ (void)linkerUnEnableHUDShowToViewController:(UIViewController *)viewController
{
    [[BLHudView sharedBLHudView] showUnEnablelinkerHUDToViewController:viewController enableRightBarBtn:NO overTimeBlock:nil];
}

// 加载动画时选择是否隐藏 rightBarButton
+ (void)linkerUnEnableHUDShowToViewController:(UIViewController *)viewController
                           enableRightBarBtn:(BOOL)enable
{
    [[BLHudView sharedBLHudView] showUnEnablelinkerHUDToViewController:viewController enableRightBarBtn:enable overTimeBlock:nil];
}

//
+ (void)linkerUnEnableHUDShowToViewController:(UIViewController *)viewController
                               overTimeBlock:(OverTimeBlock)overTimeBlock
{
    [[BLHudView sharedBLHudView] showUnEnablelinkerHUDToViewController:viewController enableRightBarBtn:YES overTimeBlock:overTimeBlock];
}

//
+ (void)linkerHUDStopOrShowWithMsg:(NSString*)msg
                            finsh:(void (^)(void))finshBlock
{
    [[BLHudView sharedBLHudView] stopOrShowWithMsg:msg
                                             finsh:finshBlock];
}

+ (void)linkerHUDHide
{
    [[BLHudView sharedBLHudView] hideHUD];
}

#pragma mark - instance method -
- (void)showEnablelinkerHUD
{
    _isUserEnable = YES;
    [self showlinkerHUD];
}

- (void)showUnEnablelinkerHUDToViewController:(UIViewController *)viewController
{
    [self showUnEnablelinkerHUDToViewController:viewController
                             enableRightBarBtn:YES
                                 overTimeBlock:nil];
}

- (void)showUnEnablelinkerHUDToViewController:(UIViewController *)viewController
                           enableRightBarBtn:(BOOL)enable
                               overTimeBlock:(OverTimeBlock)overTimeBlock
{
    _isUserEnable = NO;
    [self showlinkerHUD];
    _overTimeBlock = overTimeBlock;
    
    if (viewController != nil)
    {
        _currentVC = viewController;
        viewController.navigationItem.rightBarButtonItem.enabled = enable;
    }
}

- (void)stopOrShowWithMsg:(NSString*)msg
                    finsh:(void (^)(void))finshBlock
{
    
    _currentVC.navigationItem.rightBarButtonItem.enabled = YES;
    
    [self hideHUD];
    
    if (!([msg isEqualToString:@""] ||
          [msg isKindOfClass:[NSNull class]] ||
          msg == nil ||
          msg == NULL ||
          [msg isEqualToString:@"<null>"] ||
          [msg isEqualToString:@"(null)"] ||
          [[msg stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0)) {
        
        _mbProgressHud = [MBProgressHUD showHUDAddedTo:_APP_KEYWINDOW animated:YES];
        _mbProgressHud.mode = MBProgressHUDModeText;
        _mbProgressHud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        _mbProgressHud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _mbProgressHud.contentColor = [UIColor whiteColor];
        _mbProgressHud.detailsLabel.text = msg;
        
        if (msg.length > 12) {
            _mbProgressHud.detailsLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        } else {
            _mbProgressHud.detailsLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            _mbProgressHud.removeFromSuperViewOnHide = YES;
            [_mbProgressHud hideAnimated:NO];
            _mbProgressHud = nil;
            
            if (finshBlock) {
                finshBlock();
            }
        });
        
    } else {
        if (finshBlock) {
            finshBlock();
        }
    }
}

#pragma mark - hide -
- (void)hideHUD
{
    [self hidelinkerHUD];
    [self hideMBProHUD];
}

#pragma mark - private
#pragma mark - show / hide
- (void)showlinkerHUD
{
    [self hideHUD];
    [self initTimer];
    
    CGSize hudSize = CGSizeMake(100, 100);
    
    if (_hudView == nil) {
        _hudView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _DEVICE_WIDTH, _DEVICE_HEIGHT_NO_64)];
        [_APP_KEYWINDOW addSubview:_hudView];
        
        if (_hudSubView == nil) {
            _hudSubView = [[UIView alloc] initWithFrame:CGRectMake((_DEVICE_WIDTH - hudSize.width)/2, (_DEVICE_HEIGHT - hudSize.height)/2 - 64, hudSize.width, hudSize.height)];
            [_hudView addSubview:_hudSubView];
        }
        
        if (_isUserEnable == YES) {
            _hudView.userInteractionEnabled = NO;
        } else {
            _hudView.userInteractionEnabled = YES;
        }
        
        _mbProgressHud = [MBProgressHUD showHUDAddedTo:_hudSubView animated:YES];
        _mbProgressHud.mode = MBProgressHUDModeCustomView;
        _mbProgressHud.margin = 0.0;
        _mbProgressHud.minSize = hudSize;
        _mbProgressHud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
        _mbProgressHud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        _mbProgressHud.bezelView.color = [UIColor clearColor];
//        _mbProgressHud.bezelView.alpha = 0.7;
        _mbProgressHud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        UIActivityIndicatorView *_indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicator.center = CGPointMake(100.0f, 125.0f);
        [_indicator startAnimating];
        _mbProgressHud.customView = _indicator;
    }
}

- (void)hideMBProHUD
{
    NSArray * subViews = [_APP_KEYWINDOW subviews];
    
    for (int i = 0; i < subViews.count; i++) {
        UIView * subview = [subViews objectAtIndex:i];
        if ([subview isKindOfClass:[MBProgressHUD class]]) {
            [subview removeFromSuperview];
            subview = nil;
        }
    }
}

- (void)hidelinkerHUD
{
    [self makeTimerInvalid];
    if (_hudView) {
        if (_mbProgressHud.customView && [_mbProgressHud.customView isKindOfClass:[UIImageView class]]) {
            UIImageView * custemImageView = (UIImageView *)_mbProgressHud.customView;
            if (custemImageView.isAnimating) {
                [custemImageView stopAnimating];
                [custemImageView removeFromSuperview];
            }
            _mbProgressHud.removeFromSuperViewOnHide = YES;
            [_mbProgressHud hideAnimated:NO];
            _mbProgressHud = nil;
        }
        [_hudSubView removeFromSuperview];
        _hudSubView = nil;
        [_hudView removeFromSuperview];
        _hudView = nil;
    }
    _currentVC = nil;
}

#pragma mark - 定时器
- (void)initTimer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:35.0
                                                  target:self
                                                selector:@selector(overTime)
                                                userInfo:nil
                                                 repeats:NO];
        [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (void)overTime
{
    [self hideHUD];
    
    _mbProgressHud = [MBProgressHUD showHUDAddedTo:_APP_KEYWINDOW animated:YES];
    _mbProgressHud.mode = MBProgressHUDModeText;
    _mbProgressHud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    _mbProgressHud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    _mbProgressHud.contentColor = [UIColor whiteColor];
    _mbProgressHud.detailsLabel.text = @"服务器开小差了，请稍后再试";
    _mbProgressHud.detailsLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        _mbProgressHud.removeFromSuperViewOnHide = YES;
        [_mbProgressHud hideAnimated:NO];
        _mbProgressHud = nil;
        
        if (_overTimeBlock) {
            _overTimeBlock();
        }
    });
}

- (void)makeTimerInvalid
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}


@end
