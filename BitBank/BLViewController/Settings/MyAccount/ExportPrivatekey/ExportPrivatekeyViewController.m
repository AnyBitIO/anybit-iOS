//
//  ExportPrivatekeyViewController.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/8.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "ExportPrivatekeyViewController.h"
#import "DNPayAlertView.h"
#import "ExportPrivatekeyTableViewCell.h"
#import "CoinModel.h"
#import "PrivateDetailViewController.h"
#import "HoldCoinDBManager.h"

@interface ExportPrivatekeyViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *_dataArray;
    NSInteger _selectRow;
    NSString *_payPsd;
}

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation ExportPrivatekeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = Localized(@"setting_export_privatekey");
    
    _dataArray = [HoldCoinDBManager queryAllHoldCoin];
    
    [self initUI];
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
            make.edges.equalTo(self.view);
        }];
    }
    
    [_tableView registerClass:[ExportPrivatekeyTableViewCell class] forCellReuseIdentifier:@"ExportPrivatekeyTableViewCellIdentify"];
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
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ExportPrivatekeyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExportPrivatekeyTableViewCellIdentify" forIndexPath:indexPath];
    [cell setContentWithArray:_dataArray indexPath:indexPath];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DNPayAlertView *payAlert = [[DNPayAlertView alloc]init];
    [payAlert show];
    payAlert.payAlertViewCloseBlock = ^(void) {
        [self.navigationController popViewControllerAnimated:YES];
    };
    payAlert.payAlertViewSuccessBlock = ^(NSString *word) {
        
        _selectRow = indexPath.row;
        _payPsd = word;
        [self performSelector:@selector(goToPrivateDetailAction) withObject:nil afterDelay:.5f];
    };
}

-(void)goToPrivateDetailAction{
    CoinModel *selectModel = [_dataArray objectAtIndex:0];
    PrivateDetailViewController *pVC = [[PrivateDetailViewController alloc]initWithModel:selectModel payPsd:_payPsd];
    [self.navigationController pushViewController:pVC animated:YES];
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
