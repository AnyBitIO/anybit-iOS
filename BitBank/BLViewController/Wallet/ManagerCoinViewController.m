//
//  ManagerCoinViewController.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/5.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "ManagerCoinViewController.h"
#import "AppDelegate.h"
#import "BLUnitsMethods.h"
#import "ManagerCoinCell.h"
#import "CoinModel.h"
#import "MnemonicManager.h"
#import "HoldCoinDBManager.h"
#import "BLDBManager.h"
#import "AllCoinDBManager.h"
#import "BLHttpsRequest.h"
#import "BLKeyManager.h"
#import "ContactsDBManager.h"
#import "BLWalletDBManager.h"
#import "NSString+Utility.h"
#import "AESCrypt.h"
#import "DNPayAlertView.h"

@interface ManagerCoinViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSInteger _selectRow;
    NSMutableArray *_allCoinArray;
    NSMutableArray *_holdCoinArray;
    
    BOOL _isRecover;
    BOOL _isFromHomePage;
    NSString *_mnemonicWords;
    NSString *_loginPsd;
    NSString *_payPsd;
    NSString *_walletName;
}

@property(nonatomic,strong)UIButton *goToMainBtn;
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation ManagerCoinViewController

-(id)initWithIsRecover:(BOOL)isRecover
        isFromHomePage:(BOOL)isFromHomePage
         mnemonicWords:(NSString *)mnemonicWords
            walletName:(NSString*)walletName
              loginPsd:(NSString *)loginPsd
                payPsd:(NSString *)payPsd{
    self = [super init];
    if (self) {
        _isRecover = isRecover;
        _isFromHomePage = isFromHomePage;
        _mnemonicWords = mnemonicWords;
        _walletName = walletName;
        _loginPsd = loginPsd;
        _payPsd = payPsd;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_isRecover) {
        self.title = Localized(@"wallet_recoverCoin");
    }else {
        self.title = Localized(@"wallet_addCoin");
    }
    
     [self initData];
    
    if (_isFromHomePage) {
        [BLUnitsMethods drawTheRightBarBtnWithTitle:Localized(@"set_sure") target:self action:@selector(sureAction)];
    }else{
        [BLUnitsMethods drawTheRightBarBtnWithTitle:Localized(@"login_skip") target:self action:@selector(skipAction)];
    }
    
    [self initUI];
}

-(void)initData{
    
    _allCoinArray = [AllCoinDBManager queryAllCoinInfo];
    _holdCoinArray = [HoldCoinDBManager queryAllHoldCoin];
    
    if (_isFromHomePage && _holdCoinArray.count>0){
        for (CoinModel *model in _holdCoinArray) {
            for (CoinModel *tempModel in _allCoinArray) {
                if ([model.coinType isEqualToString:tempModel.coinType]) {
                    tempModel.isSelect = YES;
                }
            }
        }
    }
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
    [self.view addSubview:_tableView];
    
    if (_isFromHomePage) {
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            
            [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
                
                make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
                make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
                make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            }];
        } else {
            [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
                make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
            }];
        }
        
        [_tableView registerClass:[ManagerCoinCell class] forCellReuseIdentifier:@"ManagerCoinCellIdentify"];
    }else {
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            
            [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
                
                make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
                make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
                make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-60);
            }];
        } else {
            [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
                make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 60, 0));
            }];
        }
        
        [_tableView registerClass:[ManagerCoinCell class] forCellReuseIdentifier:@"ManagerCoinCellIdentify"];
        
        _goToMainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goToMainBtn setBackgroundColor:UIColorFromRGB(0x557EC5)];
        [_goToMainBtn setTitle:Localized(@"login_finish") forState:UIControlStateNormal];
        [_goToMainBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_goToMainBtn addTarget:self action:@selector(goToMainAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_goToMainBtn];
        
        if (@available(iOS 11.0, *)) {
            [_goToMainBtn mas_makeConstraints:^(MASConstraintMaker *make){
                make.left.equalTo(self.view.left).offset(0);
                make.right.equalTo(self.view.right).offset(0);
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(0);
                make.width.equalTo(kMainScreenWidth);
                make.height.equalTo(50);
            }];
        } else {
            [_goToMainBtn mas_makeConstraints:^(MASConstraintMaker *make){
                make.left.equalTo(self.view.left).offset(0);
                make.right.equalTo(self.view.right).offset(0);
                make.bottom.equalTo(self.view.bottom).offset(0);
                make.width.equalTo(kMainScreenWidth);
                make.height.equalTo(50);
            }];
        }
    }
}

#pragma mark - tableView delegate and source
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}

-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _allCoinArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ManagerCoinCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ManagerCoinCellIdentify" forIndexPath:indexPath];
    [cell setContentWithArray:_allCoinArray indexPath:indexPath];
    [cell.coinSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    return cell;
}

-(void)switchAction:(UISwitch*)sender{
    CoinModel *model = [_allCoinArray objectAtIndex:sender.tag-100];
    model.isSelect =! model.isSelect;
    [_tableView reloadData];
}

#pragma mark- 新建/恢复钱包---跳过（不绑定任何货币）
-(void)skipAction{
    [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"common_create_success") finsh:^{
        [self setWalletInfoWithSkip:YES coinArray:@[]];
        [BLAPPDELEGATE goToMainViewController];
    }];
}

#pragma mark- 新建/恢复钱包---新建（绑定货币）
-(void)goToMainAction{
    
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    for (CoinModel *model in _allCoinArray) {
        if (model.isSelect) {
            [tempArray addObject:model];
        }
    }
    
    if (tempArray.count == 0) {
        [self skipAction];
        return;
    }
    
    [BLHudView linkerUnEnableHUDShowToViewController:self];
    
    NSMutableArray *coinDicArray = [[NSMutableArray alloc]init];
    for (CoinModel *model in tempArray) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        model.address = [BLKeyManager getAddressWithCoinType:model.coinType mnemonicWords:_mnemonicWords];
        [dic setObject:model.address forKey:@"coinAddr"];
        [dic setObject:model.coinType forKey:@"coinType"];
        [coinDicArray addObject:dic];
    }
    
    [BLHttpsRequest basePostHttpsRequestWithBlock:^(NSDictionary *responseObject, NSString *rtnCode, NSString *errCode, NSString *errMsg, NSError *error){
        if ([rtnCode isEqualToString:BL_HTTP_CODE_OK]) {
            [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"common_create_success") finsh:^{
                [self setWalletInfoWithSkip:NO coinArray:tempArray];
                [BLAPPDELEGATE goToMainViewController];
            }];
        }else{
            [BLHudView linkerHUDStopOrShowWithMsg:errMsg finsh:nil];
        }
        
    } paramDic:@{@"addrs":coinDicArray} path:@"wallet_create"];
}

-(void)setWalletInfoWithSkip:(BOOL)skip coinArray:(NSArray*)coinArray{
    
    //初始化数据库
    [BLDBManager initDBSettings];
    [HoldCoinDBManager deleteAllHoldCoin];
    [ContactsDBManager deleteAllContacts];
    
    if (!skip && coinArray.count>0) {
        CoinModel *firstModel = [coinArray firstObject];
        firstModel.isDefault = YES;
        for (CoinModel *model in coinArray) {
            [HoldCoinDBManager insertHoldCoinDBWithModel:model];
        }
    }
    
    [BLWalletDBManager updateAllWalletIsDefaultNo];
    [BLWalletDBManager insertWalletDBWithWalletName:_walletName
                                   walletUrl:@""
                                    walletId:BL_WalletId
                                mnemonicWords:[AESCrypt encrypt:_mnemonicWords password:_payPsd]
                        seedKey:[AESCrypt encrypt:[MnemonicManager getSeedKeyWithMnemonicWords:_mnemonicWords] password:_payPsd]
                                    loginPsd:[NSString stringToHash256ToHex:_loginPsd]
                                      payPsd:[NSString stringToHash256ToHex:_payPsd]
                             needLoginPassword:NO
                                   isDefault:YES];
}

#pragma mark- 钱包已创建---管理货币
-(void)sureAction{
    DNPayAlertView *payAlert = [[DNPayAlertView alloc]init];
    [payAlert show];
    payAlert.payAlertViewSuccessBlock = ^(NSString *word) {
        _payPsd = word;
        [self updateWalletInfo];
    };
}

-(void)updateWalletInfo{
    
    [BLHudView linkerUnEnableHUDShowToViewController:self];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    for (CoinModel *model in _allCoinArray) {
        if (model.isSelect) {
            [tempArray addObject:model];
        }
    }
    
    NSMutableArray *coinDicArray = [[NSMutableArray alloc]init];
    for (CoinModel *model in tempArray) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        model.address = [BLKeyManager getAddressWithCoinType:model.coinType payPsd:_payPsd];
        [dic setObject:model.address forKey:@"coinAddr"];
        [dic setObject:model.coinType forKey:@"coinType"];
        [coinDicArray addObject:dic];
    }
    
    [BLHttpsRequest basePostHttpsRequestWithBlock:^(NSDictionary *responseObject, NSString *rtnCode, NSString *errCode, NSString *errMsg, NSError *error){
        if ([rtnCode isEqualToString:BL_HTTP_CODE_OK]) {
            [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"common_set_success") finsh:^{
                if (tempArray.count>0) {
                    for (CoinModel *model in tempArray) {
                        [HoldCoinDBManager insertHoldCoinDBWithModel:model];
                    }
                }else{
                    [HoldCoinDBManager deleteAllHoldCoin];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NotifyManagerCoin object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else{
            [BLHudView linkerHUDStopOrShowWithMsg:errMsg finsh:nil];
        }
    } paramDic:@{@"addrs":coinDicArray} path:@"wallet_addcoin"];
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
