//
//  RecommendShareViewController.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/27.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "RecommendShareViewController.h"
#import "BLUnitsMethods.h"
#import "HMScannerController.h"

@interface RecommendShareViewController (){
    UIView *_whiteView;
    UIImageView *_QRImageView;
    UILabel *_addressLab;
    UIButton *_copyBtn;
    NSString *_downloadAddress;
}

@end

@implementation RecommendShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = Localized(@"set_recommend_share");
//    [BLUnitsMethods drawTheRightBarBtnWithImage:ImageNamed(@"share") target:self action:@selector(shareAction)];
    
    _downloadAddress = @"https://anybit.io/download/ios.html";
    
    [self initUI];
}

-(void)initUI{
    _whiteView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, kMainScreenWidth-20, kScreenHeightNoStatusAndNoNaviBarHeight-20)];
    _whiteView.backgroundColor = [UIColor whiteColor];
    _whiteView.layer.cornerRadius = 8.0;
    [self.view addSubview:_whiteView];
    
    _QRImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_whiteView.center.x-135, _whiteView.center.y-230, 270, 270)];
    [_whiteView addSubview:_QRImageView];
    
    [HMScannerController cardImageWithCardName:_downloadAddress avatar:nil scale:0.2 completion:^(UIImage *image) {
        _QRImageView.image = image;
    }];
    
    _addressLab = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_QRImageView.frame)+30, _whiteView.frame.size.width-20, 20)];
    _addressLab.font = SYS_FONT(15);
    _addressLab.textColor = UIColorFromRGB(0xbababa);
    _addressLab.textAlignment = NSTextAlignmentCenter;
    _addressLab.text = _downloadAddress;
    [_whiteView addSubview:_addressLab];
    
    _copyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _copyBtn.frame = CGRectMake(_whiteView.center.x-70, CGRectGetMaxY(_addressLab.frame)+30, 140, 50);
    [_copyBtn setTitle:Localized(@"wallet_copy_address") forState:UIControlStateNormal];
    [_copyBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    _copyBtn.titleLabel.font = SYS_FONT(15);
    [_copyBtn setBackgroundColor:UIColorFromRGB(0xEDEDED)];
    _copyBtn.layer.cornerRadius = 5;
    [_copyBtn addTarget:self action:@selector(copyAction) forControlEvents:UIControlEventTouchUpInside];
    [_whiteView addSubview:_copyBtn];
}

-(void)shareAction{
    
}

-(void)copyAction{
    [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"wallet_copy_success") finsh:^{
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = _downloadAddress;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
