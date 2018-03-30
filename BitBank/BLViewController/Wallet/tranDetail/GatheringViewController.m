//
//  GatheringViewController.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/12.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "GatheringViewController.h"
#import "BLUnitsMethods.h"
#import "HMScannerController.h"
#import "CoinView.h"

@interface GatheringViewController (){
    NSString *_coinAddress;
    NSString *_coinType;
    NSString *_coinCount;
    
    UIView *_whiteView;
    CoinView *_coinView;
    UILabel *_assetsLab;
    UIView *_lineView;
    UILabel *_adddressLab;
    
    UIView *_QRView;
    UIImageView *_QRImageView;
    UIButton *_copyBtn;
}

@end

@implementation GatheringViewController

-(id)initWithCoinAddress:(NSString *)coinAddress coinType:(NSString *)coinType coinCount:(NSString *)coinCount{
    self = [super init];
    if (self) {
        _coinAddress = coinAddress;
        _coinType = coinType;
        _coinCount = coinCount;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = Localized(@"wallet_shouKuan");
    
//    [BLUnitsMethods drawTheRightBarBtnWithImage:ImageNamed(@"share") target:self action:@selector(shareAction)];

    [self initUI];
}

-(void)initUI{
    _whiteView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, kMainScreenWidth-20, 60)];
    _whiteView.backgroundColor = [UIColor whiteColor];
    _whiteView.layer.cornerRadius = 8.0;
    [self.view addSubview:_whiteView];
    
    _coinView = [[CoinView alloc]initWithFrame:CGRectMake(10,15, 90, 30) coinType:_coinType];
    [_whiteView addSubview:_coinView];
    
    _assetsLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 15, _whiteView.frame.size.width-120-20, 30)];
    _assetsLab.font = SYS_FONT(15);
    _assetsLab.textColor = UIColorFromRGB(0x666666);
    _assetsLab.textAlignment = NSTextAlignmentRight;
    _assetsLab.text = _coinCount;
    [_whiteView addSubview:_assetsLab];

    _QRView = [[UIView alloc]initWithFrame:CGRectMake(10, 80, kMainScreenWidth-20, kScreenHeightNoStatusAndNoNaviBarHeight-100)];
    _QRView.backgroundColor = [UIColor whiteColor];
    _QRView.layer.cornerRadius = 8.0;
    [self.view addSubview:_QRView];
    
    _adddressLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, _whiteView.frame.size.width-40, 20)];
    _adddressLab.font = SYS_FONT(15);
    _adddressLab.textColor = UIColorFromRGB(0xbababa);
    _adddressLab.textAlignment = NSTextAlignmentRight;
    _adddressLab.text = _coinAddress;
    [_QRView addSubview:_adddressLab];
    
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 80, _whiteView.frame.size.width-20, 0.5)];
    _lineView.backgroundColor = UIColorFromRGB(0xDEF0FC);
    [_QRView addSubview:_lineView];
    
    
    _QRImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_QRView.center.x-135, _QRView.center.y-230, 270, 270)];
    [_QRView addSubview:_QRImageView];
    
    [HMScannerController cardImageWithCardName:_coinAddress avatar:nil scale:0.2 completion:^(UIImage *image) {
        _QRImageView.image = image;
    }];
    
    _copyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _copyBtn.frame = CGRectMake(_QRView.center.x-70, CGRectGetMaxY(_QRImageView.frame)+30, 140, 50);
    [_copyBtn setTitle:Localized(@"wallet_copy_address") forState:UIControlStateNormal];
    [_copyBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    _copyBtn.titleLabel.font = SYS_FONT(15);
    [_copyBtn setBackgroundColor:UIColorFromRGB(0xEDEDED)];
    _copyBtn.layer.cornerRadius = 5;
    [_copyBtn addTarget:self action:@selector(copyAction) forControlEvents:UIControlEventTouchUpInside];
    [_QRView addSubview:_copyBtn];
}

-(void)shareAction{
    
}

-(void)copyAction{
    
    [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"wallet_copy_success") finsh:^{
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = _coinAddress;
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
