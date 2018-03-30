//
//  SetlanguageViewController.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/1.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "SetlanguageViewController.h"
#import "BLUnitsMethods.h"
#import "SetlanguageTableViewCell.h"

@interface SetlanguageViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSInteger _selectRow;
}

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation SetlanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = Localized(@"set_language");
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:NDappLanguage] isEqualToString:@"en"]){
        _selectRow = 1;
    }else {
        _selectRow = 0;
    }
    
    [BLUnitsMethods drawTheRightBarBtnWithTitle:Localized(@"set_sure") target:self action:@selector(sureAction)];
    
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
    
    [_tableView registerClass:[SetlanguageTableViewCell class] forCellReuseIdentifier:@"SetlanguageTableViewCellIdentify"];
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
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SetlanguageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetlanguageTableViewCellIdentify" forIndexPath:indexPath];
    [cell setContentWithIndexPath:indexPath selectRow:_selectRow];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_selectRow != indexPath.row)
    {
        _selectRow = indexPath.row;
        [_tableView reloadData];
    }
}

-(void)sureAction{
    
    [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"common_set_success") finsh:^{
        if (_selectRow == 0){
            [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:NDappLanguage];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotifyLanguageChanged object:nil];
        }else if (_selectRow == 1){
            [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:NDappLanguage];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotifyLanguageChanged object:nil];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
