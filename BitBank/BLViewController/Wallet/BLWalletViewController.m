//
//  BLWalletViewController.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/2/28.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "BLWalletViewController.h"
#import "BLKeyManager.h"
#import "ManagerCoinViewController.h"
#import "BLSignatureManager.h"
#import "BLHttpsRequest.h"
#import "MnemonicManager.h"
#import "HoldCoinDBManager.h"
#import "BLWalletTableViewCell.h"
#import "AssetDetailViewController.h"
#import "BLKeyManager.h"
#import "GatheringViewController.h"
#import "PaymentViewController.h"
#import "WZSwitch.h"
#import "MJRefreshNormalHeader.h"
#import "MJRefreshBackNormalFooter.h"
#import "NSString+Utility.h"
#import "AllCoinDBManager.h"

@interface BLWalletViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UIView *_noCoinView;
    UILabel *_noCoinTitleLab;
    UIButton *_addBigBtn;
    
    UIView *_coinView;
    UILabel *_coinTitleLab;
    UIButton *_addSmallBtn;
    UILabel *_assetsLab;
    WZSwitch *_switchView;
    UIButton *_fuBtn;
    UIButton *_shouBtn;
    UIView *_whiteView;
    
    NSMutableArray *_dataDicArray;
    NSMutableArray *_holdCoinArray;
    CoinModel *_defaultModel;
}
@property(nonatomic,strong)UILabel *amountLab;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSString *usdtAmt;
@property(nonatomic,strong)NSString *cnyAmt;

@end

@implementation BLWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(NotifyCoinAction) name:NotifyManagerCoin object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(NotifyCoinAction) name:NotifyChangeDefaultCoin object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getAllDataFromServer) name:NotifyPaySuccess object:nil];

    _dataDicArray = [[NSMutableArray alloc]init];
    _defaultModel = [[CoinModel alloc]init];
    _usdtAmt = @"";
    _cnyAmt = @"";
    
    [self initNoCoinUI];
    
    [self initCoinUI];
    
    [self initData];
    
    [self getAllDataFromServer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.leftBarButtonItem = nil;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)initNoCoinUI{
    _noCoinView = [[UIView alloc]initWithFrame:self.view.bounds];
    _noCoinView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_noCoinView];
    
    _noCoinTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, fit_X_width+40, kMainScreenWidth, 20)];
    _noCoinTitleLab.font = SYS_FONT(17);
    _noCoinTitleLab.text = Localized(@"wallet_bitbank");
    _noCoinTitleLab.textColor = UIColorFromRGB(0xa7ddff);
    _noCoinTitleLab.textAlignment = NSTextAlignmentCenter;
    [_noCoinView addSubview:_noCoinTitleLab];
    
    _addBigBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addBigBtn.frame = CGRectMake(10, CGRectGetMaxY(_noCoinTitleLab.frame)+20, kMainScreenWidth-20, 80);
    [_addBigBtn setBackgroundImage:ImageNamed(@"dashedRectangle") forState:UIControlStateNormal];
    [_addBigBtn setImage:ImageNamed(@"add_coin") forState:UIControlStateNormal];
    [_addBigBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_addBigBtn setTitle:Localized(@"wallet_addCoin") forState:UIControlStateNormal];
    [_addBigBtn addTarget:self action:@selector(addCoinAction) forControlEvents:UIControlEventTouchUpInside];
    [_noCoinView addSubview:_addBigBtn];
}

-(void)initCoinUI{
    
    _coinView = [[UIView alloc]initWithFrame:self.view.bounds];
    _coinView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_coinView];
    
    _coinTitleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, fit_X_width+40, 100, 20)];
    _coinTitleLab.font = SYS_FONT(17);
    _coinTitleLab.text = Localized(@"wallet_bitbank");
    _coinTitleLab.textColor = UIColorFromRGB(0xa7ddff);
    [_coinView addSubview:_coinTitleLab];
    
    _addSmallBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addSmallBtn.frame = CGRectMake(kMainScreenWidth-33, fit_X_width+35, 23, 23);
    [_addSmallBtn setBackgroundImage:ImageNamed(@"add_coin") forState:UIControlStateNormal];
    [_addSmallBtn addTarget:self action:@selector(addCoinAction) forControlEvents:UIControlEventTouchUpInside];
    [_coinView addSubview:_addSmallBtn];
    
    _amountLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_coinTitleLab.frame)+10, kMainScreenWidth, 20)];
    _amountLab.font = SYS_FONT(23);
    _amountLab.textColor = [UIColor whiteColor];
    _amountLab.textAlignment = NSTextAlignmentCenter;
    [_coinView addSubview:_amountLab];

    _assetsLab = [[UILabel alloc]initWithFrame:CGRectMake(_coinView.center.x-50, CGRectGetMaxY(_amountLab.frame)+10, 50, 20)];
    _assetsLab.font = SYS_FONT(15);
    _assetsLab.text = Localized(@"wallet_total_assets");
    _assetsLab.textColor = [UIColor whiteColor];
    _assetsLab.textAlignment = NSTextAlignmentRight;
    [_coinView addSubview:_assetsLab];
    
    __weak BLWalletViewController *weakSelf = self;
    _switchView = [[WZSwitch alloc]initWithFrame:CGRectMake(_coinView.center.x, CGRectGetMaxY(_amountLab.frame)+13.5, 30, 15)];
    [_switchView setTextFont:SYS_FONT(10)];
    _switchView.block = ^(BOOL state) {
    if (!state) {
        weakSelf.amountLab.text = [NSString stringWithFormat:@"¥%@",weakSelf.cnyAmt];
    }else{
        weakSelf.amountLab.text = [NSString stringWithFormat:@"$%@",weakSelf.usdtAmt];
    }
    [weakSelf.tableView reloadData];
        
    };
    [_coinView addSubview:_switchView];
    
    _fuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _fuBtn.frame = CGRectMake(_coinView.center.x-56-50, CGRectGetMaxY(_assetsLab.frame)+20, 56, 56);
    [_fuBtn addTarget:self action:@selector(fuKuanAction) forControlEvents:UIControlEventTouchUpInside];
    [_coinView addSubview:_fuBtn];
    
    _shouBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _shouBtn.frame = CGRectMake(_coinView.center.x+50, CGRectGetMaxY(_assetsLab.frame)+20, 56, 56);
    [_shouBtn addTarget:self action:@selector(shouKuanAction) forControlEvents:UIControlEventTouchUpInside];
    [_coinView addSubview:_shouBtn];
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:NDappLanguage] isEqualToString:@"zh-Hans"]) {
        _assetsLab.frame = CGRectMake(_coinView.center.x-40, CGRectGetMaxY(_amountLab.frame)+10, 50, 20);
        _switchView.frame = CGRectMake(_coinView.center.x+10, CGRectGetMaxY(_amountLab.frame)+13.5, 30, 15);
        _amountLab.text = [NSString stringWithFormat:@"¥%@",_cnyAmt];
        [_switchView setSwitchState:NO animation:NO];
        [_fuBtn setBackgroundImage:ImageNamed(@"wallet_fukuan_zh") forState:UIControlStateNormal];
        [_shouBtn setBackgroundImage:ImageNamed(@"wallet_shoukuan_zh") forState:UIControlStateNormal];
    }else{
        _assetsLab.frame = CGRectMake(_coinView.center.x-65, CGRectGetMaxY(_amountLab.frame)+10, 90, 20);
        _switchView.frame = CGRectMake(_coinView.center.x+25, CGRectGetMaxY(_amountLab.frame)+13.5, 30, 15);
        _amountLab.text = [NSString stringWithFormat:@"¥%@",_usdtAmt];
        [_switchView setSwitchState:YES animation:NO];
        [_fuBtn setBackgroundImage:ImageNamed(@"wallet_fukuan_en") forState:UIControlStateNormal];
        [_shouBtn setBackgroundImage:ImageNamed(@"wallet_shoukuan_en") forState:UIControlStateNormal];
    }
    
    _whiteView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_shouBtn.frame)+20, _coinView.frame.size.width-20, kScreenHeightNoStatusAndNOTabBarHeight-(CGRectGetMaxY(_shouBtn.frame)+20))];
    _whiteView.backgroundColor = [UIColor whiteColor];
    _whiteView.layer.cornerRadius = 8.0;
    [_coinView addSubview:_whiteView];
    
    NSArray *titleArray = @[Localized(@"wallet_currency"),Localized(@"wallet_count"),Localized(@"wallet_assets")];
    for (int i=0; i<3; i++) {
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(_whiteView.frame.size.width/3*i, 0,_whiteView.frame.size.width/3, 50)];
        titleLab.font = SYS_FONT(15);
        titleLab.text = [titleArray objectAtIndex:i];
        titleLab.textColor = UIColorFromRGB(0x666666);
        titleLab.textAlignment = NSTextAlignmentCenter;
        [_whiteView addSubview:titleLab];
    }
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, _whiteView.frame.size.width, _whiteView.frame.size.height-50-6) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.rowHeight = 50;
    [_whiteView addSubview:_tableView];
    
    if (@available(iOS 11.0, *)) {
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [_tableView registerClass:[BLWalletTableViewCell class] forCellReuseIdentifier:@"BLWalletTableViewCellIdentify"];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getAllDataFromServer)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
    
//    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getAllDataFromServer)];
//    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
//    self.tableView.mj_footer.ignoredScrollViewContentInsetBottom = 30;
}

-(void)initData{
    _holdCoinArray = [HoldCoinDBManager queryAllHoldCoin];
    
    if (_holdCoinArray.count == 0){
        _noCoinView.hidden = NO;
        _coinView.hidden = YES;
    }else{
        _noCoinView.hidden = YES;
        _coinView.hidden = NO;
    }
    
    for (CoinModel *tempModel in _holdCoinArray) {
        if (tempModel.isDefault) {
            _defaultModel.coinValue = tempModel.coinValue;
            _defaultModel.coinType = tempModel.coinType;
            _defaultModel.address = tempModel.address;
            _defaultModel.isDefault = YES;
            break;
        }
    }
}

#pragma mark- 添加货币
-(void)addCoinAction{
    ManagerCoinViewController *mVC = [[ManagerCoinViewController alloc]initWithIsRecover:NO isFromHomePage:YES mnemonicWords:@"" walletName:@"" loginPsd:@"" payPsd:@""];
    mVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mVC animated:YES];
}

#pragma mark- 收款
-(void)shouKuanAction{
    if (_defaultModel.isDefault) {
        for (NSDictionary *dic in _dataDicArray) {
            if ([_defaultModel.coinType isEqualToString:[dic objectForKey:@"coinType"]]) {
                _defaultModel.count = [dic objectForKey:@"num"];
            }
        }
        GatheringViewController *gVC = [[GatheringViewController alloc]initWithCoinAddress:_defaultModel.address coinType:_defaultModel.coinType coinCount:_defaultModel.count];
        gVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:gVC animated:YES];
    }else{
        [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"setting_set_coin") finsh:nil];
    }
}

#pragma mark- 付款
-(void)fuKuanAction{

    if (_defaultModel.isDefault) {
        for (NSDictionary *dic in _dataDicArray) {
            if ([_defaultModel.coinType isEqualToString:[dic objectForKey:@"coinType"]]) {
                _defaultModel.count = [dic objectForKey:@"num"];
            }
        }
        PaymentViewController *pVC = [[PaymentViewController alloc]initWithCoinAddress:_defaultModel.address coinType:_defaultModel.coinType coinCount:_defaultModel.count];
        pVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pVC animated:YES];
    }else{
        [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"setting_set_coin") finsh:nil];
    }
}

#pragma mark- 添加/减少货币
-(void)NotifyCoinAction{
    
    _holdCoinArray = [HoldCoinDBManager queryAllHoldCoin];
    
    _defaultModel.coinValue = 0;
    _defaultModel.coinType = @"";
    _defaultModel.address = @"";
    _defaultModel.isDefault = NO;
    
    for (CoinModel *tempModel in _holdCoinArray) {
        if (tempModel.isDefault) {
            _defaultModel.coinValue = tempModel.coinValue;
            _defaultModel.coinType = tempModel.coinType;
            _defaultModel.address = tempModel.address;
            _defaultModel.isDefault = YES;
            break;
        }
    }
    
    if (_holdCoinArray.count == 0){
        _noCoinView.hidden = NO;
        _coinView.hidden = YES;
    }else{
        _noCoinView.hidden = YES;
        _coinView.hidden = NO;
        [self getAllDataFromServer];
    }
}

#pragma mark - tableView delegate and source
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_dataDicArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BLWalletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BLWalletTableViewCellIdentify" forIndexPath:indexPath];
    [cell setContentWithArray:_dataDicArray indexPath:indexPath iscnyAmt:!_switchView.on];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = [_dataDicArray objectAtIndex:indexPath.row];
    uint coinValue = [AllCoinDBManager queryCoinValueWithName:[dic objectForKey:@"coinType"]];
    NSString *address = [HoldCoinDBManager getCoinAddressWithCoinValue:coinValue];
    
    AssetDetailViewController *tVC = [[AssetDetailViewController alloc]initWithCoinAddress:address coinType:[dic objectForKey:@"coinType"] coinCount:[dic objectForKey:@"num"]];
    tVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:tVC animated:YES];
}


-(void)getAllDataFromServer{
    
    if (_holdCoinArray.count>0) {
        NSMutableArray *coinArray = [[NSMutableArray alloc]init];
        for (CoinModel *model in _holdCoinArray) {
            [coinArray addObject:model.coinType];
        }
        
        [BLHttpsRequest basePostHttpsRequestWithBlock:^(NSDictionary *responseObject, NSString *rtnCode, NSString *errCode, NSString *errMsg, NSError *error) {
            if (_tableView.mj_header.isRefreshing) {
                [_tableView.mj_header endRefreshing];
            }
            if ([rtnCode isEqualToString:BL_HTTP_CODE_OK]) {
                [_dataDicArray removeAllObjects];
                NSDictionary *returnDic = [responseObject objectForKey:@"data"];
                _usdtAmt = [NSString stringWithoutNil:[returnDic objectForKey:@"totalUsdtAmt"]];
                _cnyAmt = [NSString stringWithoutNil:[returnDic objectForKey:@"totalCnyAmt"]];
                NSArray *assets = [returnDic objectForKey:@"assets"];
                for (NSDictionary *tempDic in assets) {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                    [dic setObject:[NSString stringWithoutNil:[tempDic objectForKey:@"num"]] forKey:@"num"];
                    [dic setObject:[NSString stringWithoutNil:[tempDic objectForKey:@"usdtAmt"]] forKey:@"usdtAmt"];
                    [dic setObject:[NSString stringWithoutNil:[tempDic objectForKey:@"cnyAmt"]] forKey:@"cnyAmt"];
                    [dic setObject:[NSString stringWithoutNil:[tempDic objectForKey:@"coinType"]] forKey:@"coinType"];
                    [_dataDicArray addObject:dic];
                }
                if (!_switchView.on) {
                    _amountLab.text = [NSString stringWithFormat:@"¥%@",_cnyAmt];
                }else{
                    _amountLab.text = [NSString stringWithFormat:@"$%@",_usdtAmt];
                }
                [_tableView reloadData];
            }else{
                [BLHudView linkerHUDStopOrShowWithMsg:errMsg finsh:nil];
            }
        } paramDic:@{@"assets":coinArray} path:@"asset_query"];
    }else{
        if (_tableView.mj_header.isRefreshing) {
            [_tableView.mj_header endRefreshing];
        }
    }
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
