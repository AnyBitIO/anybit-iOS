//
//  AddUserViewController.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/9.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "AddUserViewController.h"
#import "ContactModel.h"
#import "ContactsDBManager.h"
#import "BLUnitsMethods.h"
#import "NSString+Utility.h"
#import "HMScannerController.h"
#import "BLHttpsRequest.h"
#import "NSString+Base58.h"
#import "CoinView.h"
#import "SelectCoinViewController.h"

@interface AddUserViewController ()<UITextFieldDelegate>{
    AddUserBlock _addUserBlock;
    ContactModel *_editModel;
    NSString *_nickName;
    NSString *_coinType;
    NSString *_address;
    
    UIView *_bgView;
    
    UILabel *_nickNameLab;
    UITextField *_nickNameTextField;
    UIView *_lineOneView;
    
    UILabel *_coinTitleLab;
    CoinView *_coinView;
    UIImageView *_arrowView;
    UIButton *_clickBtn;
    UIView *_lineTwoView;
    
    UILabel *_addressLab;
    UITextField *_addressTextField;
    UIButton *_scanBtn;
}

@end

@implementation AddUserViewController

-(id)initWithModel:(ContactModel*)model addUserBlock:(AddUserBlock)block{
    self = [super init];
    if (self) {
        _addUserBlock = block;
        _editModel = model;
        if (_editModel) {
            _coinType = _editModel.coinType;
            _nickName = _editModel.nickName;
            _address = _editModel.address;
        }else{
            _coinType = @"UBTC";
            _nickName = @"";
            _address = @"";
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (_editModel) {
        self.title = Localized(@"contact_edit_user");
    }else{
        self.title = Localized(@"contact_add_user");
    }
    
    [BLUnitsMethods drawTheRightBarBtnWithTitle:Localized(@"set_sure") target:self action:@selector(sureAction)];
    
    [self initUI];
}

-(void)initUI{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 20, kMainScreenWidth-20, 180)];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.cornerRadius = 5;
    [self.view addSubview:_bgView];
    
    _nickNameLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 75, 20)];
    _nickNameLab.font = SYS_FONT(16);
    _nickNameLab.textColor = UIColorFromRGB(0x333333);
    _nickNameLab.text = Localized(@"contact_nickName");
    _nickNameLab.backgroundColor = [UIColor clearColor];
    [_bgView addSubview:_nickNameLab];
    
    _nickNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 20, _bgView.frame.size.width-115, 20)];
    _nickNameTextField.backgroundColor = [UIColor whiteColor];
    _nickNameTextField.delegate = self;
    [_nickNameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _nickNameTextField.textColor = UIColorFromRGB(0x666666);
    _nickNameTextField.text = _nickName;
    _nickNameTextField.placeholder = Localized(@"contact_serach_notice");
    _nickNameTextField.textAlignment = NSTextAlignmentRight;
    [_bgView addSubview:_nickNameTextField];
    
    _lineOneView = [[UIView alloc]initWithFrame:CGRectMake(10, 60, _bgView.frame.size.width-20, 0.5)];
    _lineOneView.backgroundColor = UIColorFromRGB(0xDEF0FC);
    [_bgView addSubview:_lineOneView];
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    _coinTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_lineOneView.frame)+20, 75, 20)];
    _coinTitleLab.font = SYS_FONT(16);
    _coinTitleLab.textColor = UIColorFromRGB(0x333333);
    _coinTitleLab.text = Localized(@"contact_coin");
    _coinTitleLab.backgroundColor = [UIColor clearColor];
    [_bgView addSubview:_coinTitleLab];
    
    _coinView = [[CoinView alloc]initWithFrame:CGRectMake(_bgView.frame.size.width-95-30, CGRectGetMaxY(_lineOneView.frame)+15, 85, 30) coinType:_coinType];
    [_bgView addSubview:_coinView];
    
    _arrowView = [[UIImageView alloc]initWithFrame:CGRectMake(_bgView.frame.size.width-24, CGRectGetMaxY(_lineOneView.frame)+23, 9, 16)];
    _arrowView.image = ImageNamed(@"rightArrow");
    [_bgView addSubview:_arrowView];
    
    _clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _clickBtn.frame = CGRectMake(100, CGRectGetMaxY(_lineOneView.frame), _bgView.frame.size.width-115, 60);
    [_clickBtn addTarget:self action:@selector(selectCoinAction) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_clickBtn];
    
    _lineTwoView = [[UIView alloc]initWithFrame:CGRectMake(10, 120, _bgView.frame.size.width-20, 0.5)];
    _lineTwoView.backgroundColor = UIColorFromRGB(0xDEF0FC);
    [_bgView addSubview:_lineTwoView];
    
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    _addressLab = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_lineTwoView.frame)+20, 75, 20)];
    _addressLab.font = SYS_FONT(16);
    _addressLab.textColor = UIColorFromRGB(0x333333);
    _addressLab.text = Localized(@"contact_wallet_address");
    _addressLab.backgroundColor = [UIColor clearColor];
    [_bgView addSubview:_addressLab];
    
    _scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _scanBtn.frame = CGRectMake(_bgView.frame.size.width-22-10, CGRectGetMaxY(_lineTwoView.frame)+19, 22, 22);
    [_scanBtn setBackgroundImage:ImageNamed(@"saomiao") forState:UIControlStateNormal];
    [_scanBtn addTarget:self action:@selector(scanAction) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_scanBtn];
    
    _addressTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(_lineTwoView.frame)+20, _bgView.frame.size.width-132-15, 20)];
    _addressTextField.backgroundColor = [UIColor whiteColor];
    _addressTextField.delegate = self;
    [_addressTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _addressTextField.textColor = UIColorFromRGB(0x666666);
    _addressTextField.text = _address;
    _addressTextField.textAlignment = NSTextAlignmentRight;
    _addressTextField.keyboardType = UIKeyboardTypeASCIICapable;
    [_bgView addSubview:_addressTextField];
}

-(void)selectCoinAction{
    [self.view endEditing:YES];
    
    SelectCoinViewController *sVC = [[SelectCoinViewController alloc]initWithBlcok:^(NSString *coinType) {
        _coinType = coinType;
        [_coinView setCoinType:_coinType];
    }];
    [self.navigationController pushViewController:sVC animated:YES];
}

-(void)scanAction{
    [self.view endEditing:YES];
    
    HMScannerController *scanner = [HMScannerController scannerWithCardName:@"" avatar:nil completion:^(NSString *stringValue){
        _address = stringValue;
        _addressTextField.text = _address;
    }];
    
    [scanner setTitleColor:[UIColor whiteColor] tintColor:[UIColor greenColor]];
    
    [self showDetailViewController:scanner sender:nil];
}

-(void)sureAction{
    
    [self.view endEditing:YES];
    
    if ([NSString isBLBlankString:_coinType]) {
        [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"contact_without_coin") finsh:nil];
        return;
    }
    
    if ([NSString isBLBlankString:_nickName]) {
        [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"contact_serach_notice") finsh:nil];
        return;
    }
    
    if (![NSString stringWithNumbersAndLettersOrChinese:_nickName]) {
        [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"common_input_limit") finsh:nil];
        return;
    }
    
    if (_nickName.length>20) {
        [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"common_input_length_20") finsh:nil];
        return;
    }
    
    if ([NSString isBLBlankString:_address]) {
        [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"contact_without_wallet_address") finsh:nil];
        return;
    }
    
    if (!_address.isValidBitcoinAddress) {
        [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"contact_wallet_address_error") finsh:nil];
        return;
    }
    
    [BLHudView linkerUnEnableHUDShowToViewController:self];
    
    ContactModel *model = [[ContactModel alloc]init];
    model.coinType = _coinType;
    model.nickName = _nickName;
    model.address = _address;
    
    if (_editModel) {
        [BLHttpsRequest basePostHttpsRequestWithBlock:^(NSDictionary *responseObject, NSString *rtnCode, NSString *errCode, NSString *errMsg, NSError *error){
            if ([rtnCode isEqualToString:BL_HTTP_CODE_OK]) {
                [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"contact_edit_success") finsh:^{
                    [ContactsDBManager deleteContactsDBWithModel:_editModel];
                    [ContactsDBManager insertContactsDBWithModel:model];
                    if (_addUserBlock){
                        _addUserBlock(model);
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else{
                [BLHudView linkerHUDStopOrShowWithMsg:errMsg finsh:nil];
            }
        } paramDic:@{@"origContacterAddr":_editModel.address,@"contacterAddr":_address,@"coinType":_coinType,@"nickName":_nickName} path:@"contacter_edit"];
    }else{
        [BLHttpsRequest basePostHttpsRequestWithBlock:^(NSDictionary *responseObject, NSString *rtnCode, NSString *errCode, NSString *errMsg, NSError *error){
            if ([rtnCode isEqualToString:BL_HTTP_CODE_OK]) {
                [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"contact_add_success") finsh:^{
                    [ContactsDBManager insertContactsDBWithModel:model];
                    if (_addUserBlock){
                        _addUserBlock(model);
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else{
                [BLHudView linkerHUDStopOrShowWithMsg:errMsg finsh:nil];
            }
        } paramDic:@{@"contacterAddr":_address,@"coinType":_coinType,@"nickName":_nickName} path:@"contacter_add"];
    }
}

#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return NO;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField == _nickNameTextField) {
        _nickName = textField.text;
    }else{
        _address = textField.text;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField becomeFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidChange:(UITextField *)textField{
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    return YES;
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
