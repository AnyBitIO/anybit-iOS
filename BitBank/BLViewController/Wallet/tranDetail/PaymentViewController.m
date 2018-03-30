//
//  PaymentViewController.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/12.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "PaymentViewController.h"
#import "HMScannerController.h"
#import "PaymentTableViewCell.h"
#import "FeeNoticeTableViewCell.h"
#import "BLHttpsRequest.h"
#import "NSString+Utility.h"
#import "BLSignatureManager.h"
#import "DNPayAlertView.h"
#import "NSString+Base58.h"
#import "BLContactViewController.h"
#import "CoinView.h"

@interface PaymentViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,PaymentTableViewCellDeleagte>{
    NSString *_coinAddress;
    NSString *_coinType;
    NSString *_coinCount;
    
    NSString *_toAddress;
    NSString *_tranAmt;
    NSString *_tranFee;
    NSDecimalNumber *_feeNumber;
    NSDecimalNumber *_originFeeNumber;
    NSString *_tranRemark;
    
    NSIndexPath *_currentIndexPath;
    
    UITableView *_tableView;
    UIButton *_cancelBtn;
    UIButton *_nextBtn;
}

@end

@implementation PaymentViewController

-(id)initWithCoinAddress:(NSString *)coinAddress coinType:(NSString *)coinType coinCount:(NSString *)coinCount{
    self = [super init];
    if (self) {
        _coinAddress = coinAddress;
        _coinType = coinType;
        _coinCount = coinCount;
        _tranFee = @"0.0001";
        _feeNumber = [NSDecimalNumber decimalNumberWithString:_tranFee];
        _originFeeNumber = [NSDecimalNumber decimalNumberWithString:@"0.0001"];
        _tranRemark = @"";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = Localized(@"wallet_fuKuan");
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self initUI];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)initUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.rowHeight = 60;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [self tableViewHeaderView];
    _tableView.layer.cornerRadius = 8;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[PaymentTableViewCell class] forCellReuseIdentifier:@"PaymentTableViewCellIdentify"];
    [_tableView registerClass:[FeeNoticeTableViewCell class] forCellReuseIdentifier:@"FeeNoticeTableViewCellIdentify"];

    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBtn.frame = CGRectMake(10,kScreenHeightNoStatusAndNoNaviBarHeight-60, 170, 50);
    [_cancelBtn setTitle:Localized(@"wallet_cancel") forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = SYS_FONT(16);
    [_cancelBtn setBackgroundImage:ImageNamed(@"btn_recovery") forState:UIControlStateNormal];
    [_cancelBtn setBackgroundImage:ImageNamed(@"btn_establish") forState:UIControlStateHighlighted];
    [_cancelBtn setTitleColor:UIColorFromRGB(0x02a4ff) forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelBtn];
    
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBtn.frame = CGRectMake(kMainScreenWidth-180,kScreenHeightNoStatusAndNoNaviBarHeight-60, 170, 50);
    [_nextBtn setTitle:Localized(@"login_next") forState:UIControlStateNormal];
    _nextBtn.titleLabel.font = SYS_FONT(16);
    [_nextBtn setBackgroundImage:ImageNamed(@"btn_establish") forState:UIControlStateNormal];
    [_nextBtn setBackgroundImage:ImageNamed(@"btn_recovery") forState:UIControlStateHighlighted];
    [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextBtn setTitleColor:UIColorFromRGB(0x02a4ff) forState:UIControlStateHighlighted];
    [_nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextBtn];
    
    if (@available(iOS 11.0, *)) {
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
            
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(10);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-10);
            make.bottom.equalTo(_cancelBtn.mas_top).offset(-10);
        }];
        
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(self.view.left).offset(10);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-10);
            make.width.equalTo((kMainScreenWidth-30)/2);
            make.height.equalTo(50);
        }];
        
        [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make){
            make.right.equalTo(self.view.right).offset(-10);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-10);
            make.width.equalTo((kMainScreenWidth-30)/2);
            make.height.equalTo(50);
        }];
        
    } else {
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.view.mas_top).offset(10);
            make.left.equalTo(self.view.mas_left).offset(10);
            make.right.equalTo(self.view.mas_right).offset(-10);
            make.bottom.equalTo(_cancelBtn.mas_top).offset(-10);
        }];
        
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(self.view.left).offset(10);
            make.bottom.equalTo(self.view.bottom).offset(-10);
            make.width.equalTo((kMainScreenWidth-30)/2);
            make.height.equalTo(50);
        }];
        
        [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make){
            make.right.equalTo(self.view.right).offset(-10);
            make.bottom.equalTo(self.view.bottom).offset(-10);
            make.width.equalTo((kMainScreenWidth-30)/2);
            make.height.equalTo(50);
        }];
    }

}

-(UIView *)tableViewHeaderView{

    UIView *_whiteView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, kMainScreenWidth-20, 100)];
    _whiteView.backgroundColor = [UIColor whiteColor];
    _whiteView.layer.cornerRadius = 8.0;
    
    CoinView *_coinView = [[CoinView alloc]initWithFrame:CGRectMake(10,15, 90, 30) coinType:_coinType];
    [_whiteView addSubview:_coinView];
    
    UILabel *_assetsLab = [[UILabel alloc]initWithFrame:CGRectMake(120, 10, _whiteView.frame.size.width-120-20, 40)];
    _assetsLab.font = SYS_FONT(15);
    _assetsLab.textColor = UIColorFromRGB(0x666666);
    _assetsLab.textAlignment = NSTextAlignmentRight;
    _assetsLab.text = _coinCount;
    [_whiteView addSubview:_assetsLab];
    
    UIView *_lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 60, _whiteView.frame.size.width-20, 0.5)];
    _lineView.backgroundColor = UIColorFromRGB(0xDEF0FC);
    [_whiteView addSubview:_lineView];
    
    UILabel *_adddressLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 70, _whiteView.frame.size.width-40, 20)];
    _adddressLab.font = SYS_FONT(15);
    _adddressLab.textColor = UIColorFromRGB(0xbababa);
    _adddressLab.textAlignment = NSTextAlignmentRight;
    _adddressLab.text = _coinAddress;
    [_whiteView addSubview:_adddressLab];
    
    return _whiteView;
}

#pragma mark - 取消
-(void)cancelAction{
    [self.view endEditing:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 下一步
-(void)nextAction{
    [self.view endEditing:YES];
    
    if ([_toAddress isEqualToString:_coinAddress]) {
        [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"wallet_tran_noSelf") finsh:nil];
        return;
    }
    
    if ([NSString isBLBlankString:_toAddress]) {
        [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"contact_without_wallet_address") finsh:nil];
        return;
    }
    
    if (!_toAddress.isValidBitcoinAddress) {
        [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"contact_wallet_address_error") finsh:nil];
        return;
    }
    
    if ([NSString isBLBlankString:_tranAmt]) {
        [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"wallet_tran_without_money") finsh:nil];
        return;
    }
    
    if (![NSString isBLBlankString:_tranRemark]) {
        if (![NSString stringWithNumbersAndLettersOrChinese:_tranRemark]) {
            [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"common_input_limit") finsh:nil];
            return;
        }
        
        if (_tranRemark.length>20) {
            [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"common_input_length_20") finsh:nil];
            return;
        }
    }
    
    if (![NSString stringWithNumbersAndDot:_tranFee] || ![NSString stringWithNumbersAndDot:_tranAmt]){
        [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"common_input_Number") finsh:nil];
        return;
    }
    

    if ([_feeNumber compare:_originFeeNumber] == NSOrderedAscending){
        [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"wallet_tran_few_fee") finsh:nil];
        return;
    }
    
    DNPayAlertView *payAlert = [[DNPayAlertView alloc]init];
    [payAlert show];
    payAlert.payAlertViewSuccessBlock = ^(NSString *word) {
        [self buildTranWithPayPsd:word];
    };
}

-(void)buildTranWithPayPsd:(NSString*)payPsd{
    
    [BLHudView linkerUnEnableHUDShowToViewController:self];
    
    NSDictionary *sendDic = @{@"fromAddr":_coinAddress,
                              @"toAddr":_toAddress,
                              @"coinType":_coinType,
                              @"tranAmt":_tranAmt,
                              @"tranFee":_tranFee,
                              @"bak":_tranRemark};

    [BLHttpsRequest basePostHttpsRequestWithBlock:^(NSDictionary *responseObject, NSString *rtnCode, NSString *errCode, NSString *errMsg, NSError *error) {
        if ([rtnCode isEqualToString:BL_HTTP_CODE_OK]) {
            NSDictionary *returnDic = [responseObject objectForKey:@"data"];
            NSString *unsignTranHex = [NSString stringWithoutNil:[returnDic objectForKey:@"unsignTranHex"]];
            NSArray *inputs = [returnDic objectForKey:@"inputs"];
            NSMutableArray *inputArray = [[NSMutableArray alloc]init];
            for (NSDictionary *tempDic in inputs) {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                [dic setObject:[NSString stringWithoutNil:[tempDic objectForKey:@"amout"]] forKey:@"amout"];
                [dic setObject:[NSString stringWithoutNil:[tempDic objectForKey:@"scriptPubKey"]] forKey:@"scriptPubKey"];
                [dic setObject:[NSString stringWithoutNil:[tempDic objectForKey:@"txid"]] forKey:@"txid"];
                [dic setObject:[NSString stringWithoutNil:[tempDic objectForKey:@"vout"]] forKey:@"vout"];
                [inputArray addObject:dic];
            }
            [BLHudView linkerHUDStopOrShowWithMsg:@"" finsh:nil];
            [self sendUnsignTranHex:unsignTranHex inputs:inputs inputArray:inputArray sendDic:sendDic payPsd:payPsd];
        }else{
            [BLHudView linkerHUDStopOrShowWithMsg:errMsg finsh:nil];
        }
    } paramDic:sendDic path:@"tran_build"];
}

-(void)sendUnsignTranHex:(NSString *)unsignTranHex
                  inputs:(NSArray *)inputs
              inputArray:(NSMutableArray *)inputArray
                 sendDic:(NSDictionary*)sendDic
                  payPsd:(NSString*)payPsd{
    [BLHudView linkerUnEnableHUDShowToViewController:self];
    if ([BLSignatureManager verifyReturnedDataIsValidWithOriginalTransaction:unsignTranHex sendDic:sendDic coinType:_coinType]){
        NSString *signTranHex = [BLSignatureManager getSignatureDataWithOriginalTransaction:unsignTranHex inputs:inputArray coinType:_coinType payPsd:payPsd];
        
        NSDictionary *dic = @{@"tranContent":sendDic,@"signTranHex":signTranHex,@"inputs":inputs};
        
        [BLHttpsRequest basePostHttpsRequestWithBlock:^(NSDictionary *responseObject, NSString *rtnCode, NSString *errCode, NSString *errMsg, NSError *error) {
            if ([rtnCode isEqualToString:BL_HTTP_CODE_OK]) {
                [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"wallet_tran_success") finsh:^{
                    [[NSNotificationCenter defaultCenter]postNotificationName:NotifyPaySuccess object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else{
                [BLHudView linkerHUDStopOrShowWithMsg:errMsg finsh:nil];
            }
        } paramDic:dic path:@"tran_send"];
    }else{
        [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"wallet_tran_fail") finsh:nil];
    }
}

#pragma mark - tableView delegate and source
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row<4) {
        PaymentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PaymentTableViewCellIdentify" forIndexPath:indexPath];
        [cell setContentWithIndexPath:indexPath coinType:_coinType];
        cell.delegate = self;
        cell.textField.tag = indexPath.row+100;
        cell.textField.delegate = self;
        [cell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        return cell;
    }else{
        FeeNoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeeNoticeTableViewCellIdentify" forIndexPath:indexPath];
        return cell;
    }
}

#pragma mark - 扫描二维码
-(void)scanAddress{
    [self.view endEditing:YES];
    
    HMScannerController *scanner = [HMScannerController scannerWithCardName:@"" avatar:nil completion:^(NSString *stringValue){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        PaymentTableViewCell *cell = (PaymentTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
        _toAddress = stringValue;
        cell.textField.text = _toAddress;
    }];
    
    [scanner setTitleColor:[UIColor whiteColor] tintColor:[UIColor greenColor]];
    
    [self showDetailViewController:scanner sender:nil];
}

#pragma mark- 选择地址
-(void)selectContact{
    [self.view endEditing:YES];
    BLContactViewController *cVC = [[BLContactViewController alloc]initWithCoinType:_coinType block:^(NSString *address) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        PaymentTableViewCell *cell = (PaymentTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
        _toAddress = address;
        cell.textField.text= _toAddress;
    }];
    [self.navigationController pushViewController:cVC animated:YES];
}

#pragma mark- 加减消小费
-(void)reduceFee{
    [self.view endEditing:YES];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    PaymentTableViewCell *cell = (PaymentTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
    
    if ([_feeNumber compare:_originFeeNumber] == NSOrderedDescending){
        _feeNumber = [_feeNumber decimalNumberBySubtracting:_originFeeNumber];
        _tranFee = [NSString stringWithFormat:@"%@",_feeNumber];
        cell.textField.text= _tranFee;
    }
}

-(void)addFee{
    [self.view endEditing:YES];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    PaymentTableViewCell *cell = (PaymentTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
    
    _feeNumber = [_feeNumber decimalNumberByAdding:_originFeeNumber];
    _tranFee = [NSString stringWithFormat:@"%@",_feeNumber];
    cell.textField.text= _tranFee;
}

#pragma mark - UIKeyboardNotification-
- (void)handleKeyboardWillShow:(NSNotification *)paramNotification{
    NSDictionary *userInfo = [paramNotification userInfo];
    NSValue *animationCurveObject =
    [userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSValue *animationDurationObject =
    [userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSValue *keyboardEndRectObject =
    [userInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    NSUInteger animationCurve = 0;
    double animationDuration = 0.0f;
    CGRect keyboardEndRect = CGRectMake(0, 0, 0, 0);
    
    [animationCurveObject getValue:&animationCurve];
    [animationDurationObject getValue:&animationDuration];
    [keyboardEndRectObject getValue:&keyboardEndRect];
    
    [UIView beginAnimations:@"changeTableViewContentInset" context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:(UIViewAnimationCurve)animationCurve];
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    CGRect intersectionOfKeyboardRectAndWindowRect = CGRectIntersection(window.frame, keyboardEndRect);
    CGFloat bottomInset = intersectionOfKeyboardRectAndWindowRect.size.height;
    _tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, bottomInset, 0.0f);
    [UIView commitAnimations];

    if (_currentIndexPath){
        [_tableView scrollToRowAtIndexPath:_currentIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)handleKeyboardWillHide:(NSNotification *)paramNotification{
    NSDictionary *userInfo = [paramNotification userInfo];
    NSValue *animationCurveObject =
    [userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSValue *animationDurationObject = [userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    NSValue *keyboardEndRectObject = [userInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    NSUInteger animationCurve = 0;
    double animationDuration = 0.0f;
    CGRect keyboardEndRect = CGRectMake(0, 0, 0, 0);
    
    [animationCurveObject getValue:&animationCurve]; [animationDurationObject getValue:&animationDuration]; [keyboardEndRectObject getValue:&keyboardEndRect];
    [UIView beginAnimations:@"changeTableViewContentInset" context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:(UIViewAnimationCurve)animationCurve];
    
    _tableView.contentInset = UIEdgeInsetsZero;
    [UIView commitAnimations];
}

#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField becomeFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 0+100){
        _currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }else if (textField.tag == 1+100) {
        _currentIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    }else if (textField.tag == 2+100) {
        _currentIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    }else if (textField.tag == 3+100) {
        _currentIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    }
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField.tag == 0+100){
        _toAddress = textField.text;
    }else if (textField.tag == 1+100) {
        _tranAmt = textField.text;
    }else if (textField.tag == 2+100) {
        _tranRemark = textField.text;
    }else if (textField.tag == 3+100) {
        _tranFee = textField.text;
        _feeNumber = [NSDecimalNumber decimalNumberWithString:_tranFee];
    }
    
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
    
    //首位不能为.号
    if (range.location == 0 && [string isEqualToString:@"."]) {
        return NO;
    }
    
    //如果有高亮部分则暂时不计算字数
    UITextRange *markedRange = [textField markedTextRange];
    if (markedRange){
        return YES;
    }
    
    UITextRange *selectedRange = [textField selectedTextRange];
    // 获取高亮部分
    UITextPosition *pos = [textField positionFromPosition:selectedRange.start offset:0];
    
    // 如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textField offsetFromPosition:textField.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textField offsetFromPosition:textField.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        NSRange rangeItem = [textField.text rangeOfString:@"."];//判断字符串是否包含
        
        if (textField.tag == 1+100 || textField.tag == 3+100){
            
            if (rangeItem.location != NSNotFound){
                //只能输入一个小数点
                if ([textField.text containsString:@"."] && [string isEqualToString:@"."]){
                    return NO;
                }
                
                NSRange subRange = [textField.text rangeOfString:@"."];
                if (offsetRange.location - subRange.location > 8){
                    return NO;
                }
            }
        }
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
