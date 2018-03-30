//
//  TranDetailViewController.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/13.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "TranDetailViewController.h"
#import "TranDetailTableViewCell.h"
#import "NSString+Utility.h"
#import "TranIDViewController.h"
#import "CoinView.h"

@interface TranDetailViewController ()<UITableViewDataSource,UITableViewDelegate>{
    TranModel *_tranModel;
    NSString *_coinType;
    
    UIImageView *_imageView;
    UIView *_titieView;
    CoinView *_coinView;
    UILabel *_countLab;
    UITableView *_tableView;
}

@end

@implementation TranDetailViewController

-(id)initWithModel:(TranModel*)model coinType:(NSString *)coinType{
    self = [super init];
    if (self) {
        _tranModel = model;
        _coinType = coinType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = Localized(@"wallet_tran_detail");
    
    [self initUI];
}

-(void)initUI{
    
    _titieView = [[UIView alloc]initWithFrame:CGRectMake(20, 33, kMainScreenWidth-40, 105)];
    _titieView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_titieView];
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, kMainScreenWidth-20, 20)];
    _imageView.image = ImageNamed(@"bg_transaction");
    [self.view addSubview:_imageView];
    
    [self initTitieView];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.estimatedRowHeight = 60;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    
    if (@available(iOS 11.0, *)) {
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(_titieView.bottom).offset(0);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(20);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-20);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-20);
        }];
    }else{
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titieView.bottom).offset(0);
            make.left.equalTo(self.view.left).offset(20);
            make.right.equalTo(self.view.right).offset(-20);
            make.bottom.equalTo(self.view.bottom).offset(-20);
        }];
    }
    
    [_tableView registerClass:[TranDetailTableViewCell class] forCellReuseIdentifier:@"TranDetailTableViewCellIdentify"];
}

-(void)initTitieView{
    _coinView = [[CoinView alloc]initWithFrame:CGRectMake(_titieView.center.x-52.2,15, 90, 30) coinType:_coinType];
    [_titieView addSubview:_coinView];
    
    _countLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, _titieView.frame.size.width, 25)];
    _countLab.font = SYS_FONT(20);
    _countLab.textColor = UIColorFromRGB(0x666666);
    _countLab.text = [NSString stringWithFormat:@"%@%@",_tranModel.tranAmt,_coinType];
    _countLab.textAlignment = NSTextAlignmentCenter;
    [_titieView addSubview:_countLab];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 6;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TranDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TranDetailTableViewCellIdentify" forIndexPath:indexPath];
    [cell setContentWithModel:_tranModel indexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 2) {
        [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"wallet_copy_success") finsh:^{
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = _tranModel.targetAddr;
        }];
    }else if (indexPath.row == 4) {
        TranIDViewController *tVC = [[TranIDViewController alloc]initWithTxId:_tranModel.txId];
        [self.navigationController pushViewController:tVC animated:YES];
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
