//
//  SecurityViewController.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/26.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "SecurityViewController.h"
#import "SettingTableViewCell.h"
#import "ChangePasswordViewController.h"
#import "BLWalletDBManager.h"

@interface SecurityViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation SecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = Localized(@"setting_security");
    
    [self initUI];
}

-(void)initUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = 60;
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
    return 0.01;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingTableViewCellIdentify" forIndexPath:indexPath];
    [cell setSecurityVCContentWithIndexPath:indexPath];
    [cell.loginSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        ChangePasswordViewController *cVC = [[ChangePasswordViewController alloc]initWithType:BLChangePassword_Login];
        [self.navigationController pushViewController:cVC animated:YES];
    }else if (indexPath.row == 1) {
        ChangePasswordViewController *cVC = [[ChangePasswordViewController alloc]initWithType:BLChangePassword_Pay];
        [self.navigationController pushViewController:cVC animated:YES];
    }
}

-(void)switchAction:(UISwitch*)sender{
    UISwitch *tempSwitch = (UISwitch *)sender;
    if ([BLWalletDBManager getWalletNeedLoginPassword]){
        [tempSwitch setOn:NO];
        [BLWalletDBManager updateWalletNeedLoginPassword:NO];
    }else {
        [tempSwitch setOn:YES];
        [BLWalletDBManager updateWalletNeedLoginPassword:YES];
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
