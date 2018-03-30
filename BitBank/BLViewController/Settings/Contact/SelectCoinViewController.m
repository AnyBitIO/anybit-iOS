//
//  SelectCoinViewController.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/22.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "SelectCoinViewController.h"
#import "AllCoinDBManager.h"
#import "SelectCoinTableViewCell.h"
#import "CoinModel.h"

@interface SelectCoinViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *_dataArray;
    SelectCoinBlock _selectCoinBlock;
}

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation SelectCoinViewController

-(id)initWithBlcok:(SelectCoinBlock)block{
    self = [super init];
    if (self) {
        _selectCoinBlock = block;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = Localized(@"contact_select_currency");
    
    _dataArray = [AllCoinDBManager queryAllCoinInfo];
    
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
    
    [_tableView registerClass:[SelectCoinTableViewCell class] forCellReuseIdentifier:@"SelectCoinTableViewCellIdentify"];
}

#pragma mark - tableView delegate and source

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
    SelectCoinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectCoinTableViewCellIdentify" forIndexPath:indexPath];
    [cell setContentWithArray:_dataArray indexPath:indexPath];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CoinModel *selectModel = [_dataArray objectAtIndex:indexPath.row];
    if (_selectCoinBlock) {
        _selectCoinBlock(selectModel.coinType);
    }
    [self.navigationController popViewControllerAnimated:YES];
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
