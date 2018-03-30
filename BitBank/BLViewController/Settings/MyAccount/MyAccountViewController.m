//
//  MyAccountViewController.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/26.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "MyAccountViewController.h"
#import "BLUnitsMethods.h"
#import "BLWalletDBManager.h"
#import "ExportPrivatekeyViewController.h"
#import "NSString+Utility.h"
#import "DNPayAlertView.h"
#import "BLWalletDBManager.h"
#import "HoldCoinDBManager.h"
#import "ContactsDBManager.h"
#import "TransactionDBManager.h"
#import "AppDelegate.h"

@interface MyAccountViewController ()<UITextFieldDelegate>{
    UIView *_bgView;
    
    UILabel *_headImageLab;
    UIImageView *_headImageView;
    UIView *_lineOneView;
    
    UILabel *_nameLab;
    UITextField *_nameTextField;
    UIView *_lineTwoView;
    
    UILabel *_keyLab;
    UIImageView *_arrowView;
    UIButton *_keyBtn;
    
    UIButton *_deleteBtn;
}

@end

@implementation MyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = Localized(@"setting_my_account");
    
    [BLUnitsMethods drawTheRightBarBtnWithTitle:Localized(@"set_sure") target:self action:@selector(sureAction)];
    
    [self initUI];
    
}

-(void)initUI{
    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, kMainScreenWidth-20, 80*3)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgView];
    
    _headImageLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 30, _bgView.frame.size.width-90, 20)];
    _headImageLab.font = SYS_FONT(17);
    _headImageLab.textColor = UIColorFromRGB(0x333333);
    _headImageLab.text = Localized(@"setting_photo");
    [_bgView addSubview:_headImageLab];
    
    _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_bgView.frame.size.width-55, 20, 40, 40)];
    _headImageView.backgroundColor = [UIColor clearColor];
    _headImageView.image = ImageNamed(@"headUrl");
    [_bgView addSubview:_headImageView];
    
    _lineOneView = [[UIView alloc]initWithFrame:CGRectMake(10, 79.5, _bgView.frame.size.width-20, 0.5)];
    _lineOneView.backgroundColor = LINE_COLOR;
    [_bgView addSubview:_lineOneView];
    
    _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 80+30, 100, 20)];
    _nameLab.font = SYS_FONT(17);
    _nameLab.textColor = UIColorFromRGB(0x333333);
    _nameLab.text = Localized(@"setting_wallet_name");
    [_bgView addSubview:_nameLab];
    
    _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(120, 80+25, _bgView.frame.size.width-135, 30)];
    _nameTextField.backgroundColor = [UIColor clearColor];
    _nameTextField.textColor = UIColorFromRGB(0xBABABA);
    _nameTextField.delegate = self;
    _nameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _nameTextField.text = [BLWalletDBManager getWalletName];
    _nameTextField.textAlignment = NSTextAlignmentRight;
    [_nameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_bgView addSubview:_nameTextField];
    
    _lineTwoView = [[UIView alloc]initWithFrame:CGRectMake(10, 159.5, _bgView.frame.size.width-20, 0.5)];
    _lineTwoView.backgroundColor = LINE_COLOR;
    [_bgView addSubview:_lineTwoView];

    
    _keyLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 190, 155, 20)];
    _keyLab.font = SYS_FONT(17);
    _keyLab.textColor = UIColorFromRGB(0x333333);
    _keyLab.text = Localized(@"setting_export_privatekey");
    [_bgView addSubview:_keyLab];
    
    _arrowView = [[UIImageView alloc]initWithFrame:CGRectMake(_bgView.frame.size.width-24, 160+32, 9, 16)];
    _arrowView.image = ImageNamed(@"rightArrow");
    [_bgView addSubview:_arrowView];
    
    _keyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _keyBtn.frame = CGRectMake(15, 160, _bgView.frame.size.width-30, 80);
    [_keyBtn addTarget:self action:@selector(exportPrivatekeyAction) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_keyBtn];
    
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteBtn setBackgroundColor:UIColorFromRGB(0xEDEDED)];
    [_deleteBtn setTitle:Localized(@"setting_delete_wallet") forState:UIControlStateNormal];
    [_deleteBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
    _deleteBtn.titleLabel.font = SYS_BOLD_FONT(16);
    [_deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_deleteBtn];
    
    if (@available(iOS 11.0, *)) {
        [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(self.view.left).offset(0);
            make.right.equalTo(self.view.right).offset(0);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(0);
            make.width.equalTo(kMainScreenWidth);
            make.height.equalTo(50);
        }];
    } else {
        [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(self.view.left).offset(0);
            make.right.equalTo(self.view.right).offset(0);
            make.bottom.equalTo(self.view.bottom).offset(0);
            make.width.equalTo(kMainScreenWidth);
            make.height.equalTo(50);
        }];
    }
}


-(void)deleteAction{
    [self.view endEditing:YES];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:Localized(@"set_delete_wallet_notice") message:Localized(@"set_delete_wallet_notice_content") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:Localized(@"common_delete")  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        DNPayAlertView *payAlert = [[DNPayAlertView alloc]init];
        [payAlert show];
        payAlert.payAlertViewSuccessBlock = ^(NSString *word) {
            
            [self performSelector:@selector(dbOperation) withObject:nil afterDelay:.5f];
        };
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:Localized(@"common_cancel")  style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:deleteAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
 
}

-(void)dbOperation{
    [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"contact_delete_success")finsh:^{
        NSArray *walletArray = [BLWalletDBManager queryWalletDBData];
        [BLWalletDBManager deleteOneWalletData];
        [HoldCoinDBManager deleteAllHoldCoin];
        [ContactsDBManager deleteAllContacts];
        [TransactionDBManager deleteAllTransaction];
        
        if (walletArray.count == 1) {
            [BLAPPDELEGATE goToLoginViewController];
        }else{
            NSDictionary *dic = [walletArray firstObject];
            BL_WalletId = [dic objectForKey:@"walletId"];
            [BLWalletDBManager updateOneWalletIsDefault:YES];
            [BLAPPDELEGATE goToMainViewController];
        }
    }];
}

-(void)exportPrivatekeyAction{
    [self.view endEditing:YES];
    
    ExportPrivatekeyViewController *eVc = [[ExportPrivatekeyViewController alloc]init];
    [self.navigationController pushViewController:eVc animated:YES];
}


-(void)sureAction{
    
    [self.view endEditing:YES];
    
    if ([BLWalletDBManager queryWalletNameIsTakenWithName:_nameTextField.text]) {
        [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"wallet_name_same") finsh:nil];
        return;
    }
    
    if ([NSString isBLBlankString:_nameTextField.text]) {
        [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"wallet_name_unEmpty") finsh:nil];
        return;
    }
    
    if (![NSString stringWithNumbersAndLettersOrChinese:_nameTextField.text]) {
        [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"common_input_limit") finsh:nil];
        return;
    }
    
    if (_nameTextField.text.length>10) {
        [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"common_input_length_10") finsh:nil];
        return;
    }
    
    [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"common_set_success") finsh:^{
        [BLWalletDBManager updateWalletName:_nameTextField.text];
        [[NSNotificationCenter defaultCenter]postNotificationName:NotifyChangeWallet object:nil];
    }];
}

#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return NO;
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
