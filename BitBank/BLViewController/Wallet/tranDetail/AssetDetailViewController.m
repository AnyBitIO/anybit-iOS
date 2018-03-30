//
//  AssetDetailViewController.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/12.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "AssetDetailViewController.h"
#import "AssetDetailTableViewCell.h"
#import "GatheringViewController.h"
#import "PaymentViewController.h"
#import "TranDetailViewController.h"
#import "BLHttpsRequest.h"
#import "NSString+Utility.h"
#import "TranModel.h"
#import "CoinView.h"
#import "MJRefreshNormalHeader.h"
#import "BLEmptyDataSourceAndDelegate.h"
#import "TransactionDBManager.h"

@interface AssetDetailViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSString *_coinAddress;
    NSString *_coinType;
    NSString *_coinCount;
    
    NSMutableArray *_tranArray;
    
    UIView *_whiteView;
    CoinView *_coinView;
    UILabel *_assetsLab;
    UIView *_lineView;
    UILabel *_adddressLab;
    
    UIView *_noRecodView;
    
    UITableView *_tableView;
    UIButton *_fuBtn;
    UIButton *_shouBtn;
    
    BLEmptyDataSourceAndDelegate * _emptyDataSet;
}

@end

@implementation AssetDetailViewController

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

    self.title = Localized(@"wallet_tran_record");
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getDataFromServer) name:NotifyPaySuccess object:nil];
    
    _tranArray = [TransactionDBManager queryAllTransactionWithCoinType:_coinType];
    
    [self initUI];
    
    [self noRecordView];
    
    [self getDataFromServer];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)initUI{
    
    _whiteView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, kMainScreenWidth-20, 100)];
    _whiteView.backgroundColor = [UIColor whiteColor];
    _whiteView.layer.cornerRadius = 8.0;
    [self.view addSubview:_whiteView];
    
    _coinView = [[CoinView alloc]initWithFrame:CGRectMake(10,15, 90, 30) coinType:_coinType];
    [_whiteView addSubview:_coinView];
    
    _assetsLab = [[UILabel alloc]initWithFrame:CGRectMake(120, 10, _whiteView.frame.size.width-120-20, 40)];
    _assetsLab.font = SYS_FONT(15);
    _assetsLab.textColor = UIColorFromRGB(0x666666);
    _assetsLab.textAlignment = NSTextAlignmentRight;
    _assetsLab.text = _coinCount;
    [_whiteView addSubview:_assetsLab];
    
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 60, _whiteView.frame.size.width-20, 0.5)];
    _lineView.backgroundColor = UIColorFromRGB(0xDEF0FC);
    [_whiteView addSubview:_lineView];
    
    _adddressLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 70, _whiteView.frame.size.width-40, 20)];
    _adddressLab.font = SYS_FONT(15);
    _adddressLab.textColor = UIColorFromRGB(0xbababa);
    _adddressLab.textAlignment = NSTextAlignmentRight;
    _adddressLab.text = _coinAddress;
    [_whiteView addSubview:_adddressLab];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.rowHeight = 90;
    [self.view addSubview:_tableView];
    
    if (@available(iOS 11.0, *)) {
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [_tableView registerClass:[AssetDetailTableViewCell class] forCellReuseIdentifier:@"AssetDetailTableViewCellIdentify"];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getDataFromServer)];
    header.lastUpdatedTimeLabel.hidden = YES;
    _tableView.mj_header = header;
 
    _fuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_fuBtn setImage:ImageNamed(@"btn_fukuan") forState:UIControlStateNormal];
    [_fuBtn setTitle:Localized(@"wallet_fuKuan") forState:UIControlStateNormal];
    [_fuBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    _fuBtn.titleLabel.font = SYS_FONT(16);
    [_fuBtn setBackgroundImage:ImageNamed(@"btn_recovery") forState:UIControlStateNormal];
    [_fuBtn setBackgroundImage:ImageNamed(@"btn_establish") forState:UIControlStateHighlighted];
    [_fuBtn setTitleColor:UIColorFromRGB(0x02a4ff) forState:UIControlStateNormal];
    [_fuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_fuBtn addTarget:self action:@selector(fuKuanAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_fuBtn];
    
    _shouBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shouBtn setImage:ImageNamed(@"btn_shoukuan") forState:UIControlStateNormal];
    [_shouBtn setTitle:Localized(@"wallet_shouKuan") forState:UIControlStateNormal];
    [_shouBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    _shouBtn.titleLabel.font = SYS_FONT(16);
    [_shouBtn setBackgroundImage:ImageNamed(@"btn_establish") forState:UIControlStateNormal];
    [_shouBtn setBackgroundImage:ImageNamed(@"btn_recovery") forState:UIControlStateHighlighted];
    [_shouBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_shouBtn setTitleColor:UIColorFromRGB(0x02a4ff) forState:UIControlStateHighlighted];
    [_shouBtn addTarget:self action:@selector(shouKuanAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_shouBtn];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(_whiteView.bottom).offset(20);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(_fuBtn.mas_top).offset(-10);
    }];
    
    if (@available(iOS 11.0, *)) {
        [_fuBtn mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(self.view.left).offset(10);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-10);
            make.width.equalTo((kMainScreenWidth-30)/2);
            make.height.equalTo(50);
        }];
        
        [_shouBtn mas_makeConstraints:^(MASConstraintMaker *make){
            make.right.equalTo(self.view.right).offset(-10);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-10);
            make.width.equalTo((kMainScreenWidth-30)/2);
            make.height.equalTo(50);
        }];
    } else {
        [_fuBtn mas_makeConstraints:^(MASConstraintMaker *make){
            make.left.equalTo(self.view.left).offset(10);
            make.bottom.equalTo(self.view.bottom).offset(-10);
            make.width.equalTo((kMainScreenWidth-30)/2);
            make.height.equalTo(50);
        }];
        
        [_shouBtn mas_makeConstraints:^(MASConstraintMaker *make){
            make.right.equalTo(self.view.right).offset(-10);
            make.bottom.equalTo(self.view.bottom).offset(-10);
            make.width.equalTo((kMainScreenWidth-30)/2);
            make.height.equalTo(50);
        }];
    }
    
}

-(void )noRecordView{
    _noRecodView = [[UIView alloc]initWithFrame:CGRectMake(0, 130, _tableView.bounds.size.width, _tableView.bounds.size.height)];
    _noRecodView.backgroundColor = [UIColor redColor];
    _noRecodView.layer.cornerRadius = 8;

    UIImageView *noImageView = [[UIImageView alloc]init];
    noImageView.image = ImageNamed(@"no_record");
    [_noRecodView addSubview:noImageView];
    
    [noImageView mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.centerX.equalTo(_noRecodView.centerX);
         make.centerY.equalTo(_noRecodView.centerY).offset(-80);
         make.width.equalTo(172);
         make.height.equalTo(161);
     }];
    

    UILabel *noRecodLab = [[UILabel alloc]init];
    noRecodLab.font = SYS_FONT(15);
    noRecodLab.textColor = UIColorFromRGB(0xbababa);
    noRecodLab.textAlignment = NSTextAlignmentCenter;
    noRecodLab.text = Localized(@"wallet_tran_no_record");
    [_noRecodView addSubview:noRecodLab];
    
    [noRecodLab mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.centerX.equalTo(_noRecodView.centerX);
         make.top.equalTo(noImageView.bottom).offset(20);;
     }];
    
    _emptyDataSet = [BLEmptyDataSourceAndDelegate emptyDataSetWithCustom:_noRecodView canScroll:YES];
    _tableView.emptyDataSetSource = _emptyDataSet;
    _tableView.emptyDataSetDelegate = _emptyDataSet;
}

#pragma mark- 付款
-(void)shouKuanAction{
    GatheringViewController *gVC = [[GatheringViewController alloc]initWithCoinAddress:_coinAddress coinType:_coinType coinCount:_coinCount];
    [self.navigationController pushViewController:gVC animated:YES];
}

#pragma mark-收款
-(void)fuKuanAction{
    PaymentViewController *pVC = [[PaymentViewController alloc]initWithCoinAddress:_coinAddress coinType:_coinType coinCount:_coinCount];
    [self.navigationController pushViewController:pVC animated:YES];
}


#pragma mark - tableView delegate and source
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_tranArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AssetDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AssetDetailTableViewCellIdentify" forIndexPath:indexPath];
    [cell setContentWithArray:_tranArray indexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TranModel *model = [_tranArray objectAtIndex:indexPath.section];
    TranDetailViewController *tVC = [[TranDetailViewController alloc]initWithModel:model coinType:_coinType];
    [self.navigationController pushViewController:tVC animated:YES];
}

-(void)getDataFromServer{
    [BLHttpsRequest basePostHttpsRequestWithBlock:^(NSDictionary *responseObject, NSString *rtnCode, NSString *errCode, NSString *errMsg, NSError *error) {
        if (_tableView.mj_header.isRefreshing) {
            [_tableView.mj_header endRefreshing];
        }
        if ([rtnCode isEqualToString:BL_HTTP_CODE_OK]) {
            [_tranArray removeAllObjects];
            NSDictionary *returnDic = [responseObject objectForKey:@"data"];
            _coinCount = [NSString stringWithoutNil:[returnDic objectForKey:@"num"]];
            _assetsLab.text = _coinCount;
            NSArray *inputs = [returnDic objectForKey:@"trans"];
            for (NSDictionary *dic in inputs) {
                TranModel *model = [[TranModel alloc]init];
                model.uniqueId = [NSString stringWithoutNil:[dic objectForKey:@"id"]];
                model.txId = [NSString stringWithoutNil:[dic objectForKey:@"txId"]];
                model.targetAddr = [NSString stringWithoutNil:[dic objectForKey:@"targetAddr"]];
                model.tranType = [NSString stringWithoutNil:[dic objectForKey:@"tranType"]];
                model.tranState = [NSString stringWithoutNil:[dic objectForKey:@"tranState"]];
                model.tranAmt = [NSString stringWithoutNil:[dic objectForKey:@"tranAmt"]];
                model.createTime = [NSString stringWithoutNil:[dic objectForKey:@"createTime"]];
                model.bak = [NSString stringWithoutNil:[dic objectForKey:@"bak"]];
                [_tranArray addObject:model];
                [TransactionDBManager insertTransactionDBWithModel:model coinType:_coinType];
            }
            [_tableView reloadData];
        }else{
            [BLHudView linkerHUDStopOrShowWithMsg:errMsg finsh:nil];
        }
    } paramDic:@{@"coinAddr":_coinAddress,@"coinType":_coinType} path:@"tran_query"];
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
