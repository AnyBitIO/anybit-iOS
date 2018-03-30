//
//  PrivateDetailViewController.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/14.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "PrivateDetailViewController.h"
#import "BLKeyManager.h"
#import "HoldCoinDBManager.h"
#import "NSString+Utility.h"

@interface PrivateDetailViewController (){
    CoinModel *_model;
    NSString *_payPsd;
    
    UILabel *_titleLab;
    
    UIView *_bgView;
    UILabel *_addTLab;
    UILabel *_addDLab;
    UIButton *_addDBtn;
    UIView *_lineView;
    UILabel *_proTLab;
    UILabel *_proDLab;
    UIButton *_proDDBtn;
    
    UIImageView *_attentionIcon;
    UILabel *_attentionOneLab;
    UILabel *_attentionTwoLab;
}

@end

@implementation PrivateDetailViewController

-(id)initWithModel:(CoinModel*)model payPsd:(NSString *)payPsd{
    self = [super init];
    if (self) {
        _model = model;
        _payPsd = payPsd;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@%@",_model.coinType,Localized(@"common_privatekey")];
    
    CGFloat titleHeight = [[NSString stringWithFormat:@"%@ %@ %@",Localized(@"set_key_title_one"),_model.coinType,Localized(@"set_key_title_two")] heightForWidth:kMainScreenWidth-20 withFont:SYS_FONT(12)];
    
    _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, kMainScreenWidth-20, titleHeight)];
    _titleLab.font = SYS_FONT(12);
    _titleLab.textColor = UIColorFromRGB(0x666666);
    _titleLab.numberOfLines = 0;
    _titleLab.text = [NSString stringWithFormat:@"%@ %@ %@",Localized(@"set_key_title_one"),_model.coinType,Localized(@"set_key_title_two")];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_titleLab];
    
    CGFloat titleLabWidth = 0;
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:NDappLanguage] isEqualToString:@"zh-Hans"]) {
        titleLabWidth = 40;
    }else{
        titleLabWidth = 85;
    }
    
    CGFloat addressHeight = [[BLKeyManager getAddressWithCoinType:_model.coinType payPsd:_payPsd] heightForWidth:kMainScreenWidth-20-(titleLabWidth+15*2)-15 withFont:SYS_FONT(15)];
    
    CGFloat keyHeight = [[BLKeyManager getPrivateKeyWithCoinType:_model.coinType payPsd:_payPsd] heightForWidth:kMainScreenWidth-20-(titleLabWidth+15*2)-15 withFont:SYS_FONT(15)];
    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_titleLab.frame)+15, kMainScreenWidth-20, addressHeight+keyHeight+10*4+0.5)];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.userInteractionEnabled = YES;
    [self.view addSubview:_bgView];
    
    _addTLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, titleLabWidth, addressHeight)];
    _addTLab.font = SYS_FONT(15);
    _addTLab.textColor = UIColorFromRGB(0x666666);
    _addTLab.text = Localized(@"common_address");
    [_bgView addSubview:_addTLab];

    _addDLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_addTLab.frame)+15, 10, _bgView.frame.size.width-(CGRectGetMaxX(_addTLab.frame)+15)-15, addressHeight)];
    _addDLab.font = SYS_FONT(15);
    _addDLab.numberOfLines = 0;
    _addDLab.textColor = UIColorFromRGB(0xBABABA);
    _addDLab.text = [BLKeyManager getAddressWithCoinType:_model.coinType payPsd:_payPsd];
    [_bgView addSubview:_addDLab];
    
    _addDBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addDBtn.frame = CGRectMake(CGRectGetMaxX(_addTLab.frame)+15, 10, _bgView.frame.size.width-(CGRectGetMaxX(_addTLab.frame)+15), addressHeight);
    [_addDBtn addTarget:self action:@selector(copyAddress) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_addDBtn];
    
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_addDLab.frame)+10, _bgView.frame.size.width, 0.5)];
    _lineView.backgroundColor = UIColorFromRGB(0xF1F8FD);
    [_bgView addSubview:_lineView];

    _proTLab = [[UILabel alloc]initWithFrame:CGRectMake(15,CGRectGetMaxY(_lineView.frame)+10, titleLabWidth, keyHeight)];
    _proTLab.font = SYS_FONT(15);
    _proTLab.textColor = UIColorFromRGB(0x666666);
    _proTLab.text = Localized(@"common_privatekey");
    [_bgView addSubview:_proTLab];
    
    _proDLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_proTLab.frame)+15, CGRectGetMaxY(_lineView.frame)+10, _bgView.frame.size.width-(CGRectGetMaxX(_proTLab.frame)+15)-15, keyHeight)];
    _proDLab.font = SYS_FONT(15);
    _proDLab.numberOfLines = 0;
    _proDLab.textColor = UIColorFromRGB(0xBABABA);
    _proDLab.text = [BLKeyManager getPrivateKeyWithCoinType:_model.coinType payPsd:_payPsd];
    [_bgView addSubview:_proDLab];
    
    _proDDBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _proDDBtn.frame = CGRectMake(CGRectGetMaxX(_proTLab.frame)+15, CGRectGetMaxY(_lineView.frame)+10, _bgView.frame.size.width-(CGRectGetMaxX(_proTLab.frame)+15), keyHeight);
    [_proDDBtn addTarget:self action:@selector(copyPrivateKey) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_proDDBtn];
    
    
    _attentionOneLab = [[UILabel alloc]init];
    _attentionOneLab.font = SYS_FONT(12);
    _attentionOneLab.textColor = UIColorFromRGB(0x999999);
    _attentionOneLab.text = Localized(@"set_key_attention_one");
    _attentionOneLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_attentionOneLab];
    
    _attentionIcon = [[UIImageView alloc]init];
    _attentionIcon.image = ImageNamed(@"attention_privatekey");
    [self.view addSubview:_attentionIcon];
    
    _attentionTwoLab = [[UILabel alloc]init];
    _attentionTwoLab.font = SYS_FONT(12);
    _attentionTwoLab.textColor = UIColorFromRGB(0x999999);
    _attentionTwoLab.text = Localized(@"set_key_attention_two");
    _attentionTwoLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_attentionTwoLab];
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:NDappLanguage] isEqualToString:@"zh-Hans"]) {
        _attentionOneLab.frame = CGRectMake(self.view.center.x-120, CGRectGetMaxY(_bgView.frame)+50, 240, 20);
        _attentionIcon.frame = CGRectMake(self.view.center.x-120, CGRectGetMaxY(_bgView.frame)+55, 11, 11);
        _attentionTwoLab.frame = CGRectMake(self.view.center.x-150, CGRectGetMaxY(_attentionIcon.frame)+5, 300, 20);
    }else{
        _attentionOneLab.frame = CGRectMake(self.view.center.x-150, CGRectGetMaxY(_bgView.frame)+50, 300, 20);
        _attentionIcon.frame = CGRectMake(self.view.center.x-150, CGRectGetMaxY(_bgView.frame)+55, 11, 11);
        _attentionTwoLab.frame = CGRectMake(self.view.center.x-170, CGRectGetMaxY(_attentionIcon.frame)+5, 340, 20);
    }
}

-(void)copyAddress{
    [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"wallet_copy_success") finsh:^{
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [BLKeyManager getAddressWithCoinType:_model.coinType payPsd:_payPsd];
    }];

}

-(void)copyPrivateKey{
    [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"wallet_copy_success") finsh:^{
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = [BLKeyManager getPrivateKeyWithCoinType:_model.coinType payPsd:_payPsd];
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
