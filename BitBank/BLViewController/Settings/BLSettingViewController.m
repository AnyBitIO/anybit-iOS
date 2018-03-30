//
//  BLSettingViewController.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/2/28.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "BLSettingViewController.h"
#import "SettingTableViewCell.h"
#import "SetlanguageViewController.h"
#import "ChangePasswordViewController.h"
#import "SetDefaultCoinViewController.h"
#import "MyAccountViewController.h"
#import "AboutUsViewController.h"
#import "CheckUpdateViewController.h"
#import "BLContactViewController.h"
#import "BLWalletDBManager.h"
#import "SecurityViewController.h"
#import "CommonWebViewController.h"

@interface BLSettingViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *_dataArray;
}

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation BLSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = Localized(@"bl_setting");
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reGetWalletName) name:NotifyChangeWallet object:nil];
    
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.leftBarButtonItem = nil;
}

-(void)initUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor clearColor];
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
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    
    [_tableView registerClass:[SettingTableViewCell class] forCellReuseIdentifier:@"SettingTableViewCellIdentify"];
}

#pragma mark - tableView delegate and source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 80;
    }else{
        return 60;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return 20;
    }
    return 0.01;
}

-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else if (section == 1) {
        return 3;
    }else if (section == 2) {
        return 3;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingTableViewCellIdentify" forIndexPath:indexPath];
    [cell setSettingVCContentWithIndexPath:indexPath];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0){
        if (indexPath.row == 0) {
            MyAccountViewController *maVC = [[MyAccountViewController alloc]init];
            maVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:maVC animated:YES];
        }else{
            BLContactViewController *cVC = [[BLContactViewController alloc]initWithCoinType:@"" block:nil];
            cVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:cVC animated:YES];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            SecurityViewController *sVC = [[SecurityViewController alloc]init];
            sVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sVC animated:YES];
        }else if (indexPath.row == 1){
            SetDefaultCoinViewController *sdVC = [[SetDefaultCoinViewController alloc]init];
            sdVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:sdVC animated:YES];
        }else if (indexPath.row == 2){
            SetlanguageViewController *slVC = [[SetlanguageViewController alloc]init];
            slVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:slVC animated:YES];
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            CommonWebViewController *cVC = [[CommonWebViewController alloc]initWithTitle:Localized(@"setting_FAQ") pageType:@"problem"];
            cVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:cVC animated:YES];
        }else if (indexPath.row == 1){
            AboutUsViewController *ciVC = [[AboutUsViewController alloc]init];
            ciVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:ciVC animated:YES];
        }else if (indexPath.row == 2){
            CheckUpdateViewController *cuVC = [[CheckUpdateViewController alloc]init];
            cuVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:cuVC animated:YES];
        }
    }
}

-(void)reGetWalletName{
    [_tableView  reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
