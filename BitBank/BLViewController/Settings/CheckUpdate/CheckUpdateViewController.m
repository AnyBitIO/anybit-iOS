//
//  CheckUpdateViewController.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/8.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "CheckUpdateViewController.h"
#import "CheckUpdateTableViewCell.h"
#import "VersionLogViewController.h"
#import "BLHttpsRequest.h"
#import "NSString+Utility.h"

@interface CheckUpdateViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UIView *_bgView;
    UIImageView *_logoImageView;
    UILabel *_versionLab;
    
    NSString *_currentVersion;
    BOOL _isNewest;
    
    UILabel *_noticeVersionLab;
    
    NSString *_serverVersion;
    NSString *_downloadUrl;
}

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation CheckUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = Localized(@"setting_check_update");
    
    _isNewest = YES;
    
    _currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, kMainScreenWidth-20, kScreenHeightNoStatusAndNoNaviBarHeight-20)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgView];

    _logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_bgView.center.x-41, 60, 82, 82)];
    _logoImageView.image = ImageNamed(@"icon_logo");
    [_bgView addSubview:_logoImageView];
    
    _versionLab = [[UILabel alloc] initWithFrame:CGRectMake(_bgView.center.x-100, CGRectGetMaxY(_logoImageView.frame)+20, 200, 20)];
    _versionLab.font = SYS_FONT(15);
    _versionLab.textColor = UIColorFromRGB(0x666666);
    _versionLab.textAlignment = NSTextAlignmentCenter;
    _versionLab.text = [NSString stringWithFormat:@"%@：V%@",Localized(@"set_current_version"),_currentVersion];
    [_bgView addSubview:_versionLab];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_versionLab.frame)+60, _bgView.frame.size.width-20, 60*2) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.rowHeight = 60;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_bgView addSubview:_tableView];
    
    if (@available(iOS 11.0, *)) {
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [_tableView registerClass:[CheckUpdateTableViewCell class] forCellReuseIdentifier:@"CheckUpdateTableViewCellIdentify"];

    
    _noticeVersionLab = [[UILabel alloc] initWithFrame:CGRectMake(_bgView.center.x-100, _bgView.frame.size.height-50, 200, 20)];
    _noticeVersionLab.font = SYS_FONT(15);
    _noticeVersionLab.textColor = UIColorFromRGB(0xBABABA);
    _noticeVersionLab.textAlignment = NSTextAlignmentCenter;
    if (_isNewest) {
        _noticeVersionLab.text = Localized(@"set_newset_version");
    }else{
        _noticeVersionLab.text = Localized(@"set_check_newset_version");
    }
    [_bgView addSubview:_noticeVersionLab];
    
    [self getDataFromServer];
}

-(void)getDataFromServer{
    
    [BLHudView linkerUnEnableHUDShowToViewController:self];
    
    [BLHttpsRequest basePostHttpsRequestWithBlock:^(NSDictionary *responseObject, NSString *rtnCode, NSString *errCode, NSString *errMsg, NSError *error){
        if ([rtnCode isEqualToString:BL_HTTP_CODE_OK]) {
            [BLHudView linkerHUDStopOrShowWithMsg:@"" finsh:^{
                NSDictionary *returnDic = [responseObject objectForKey:@"data"];
                _serverVersion = [NSString stringWithoutNil:[returnDic objectForKey:@"verson"]];
                _downloadUrl = [NSString stringWithoutNil:[returnDic objectForKey:@"download_url"]];
                
                NSString *serVersion = [_serverVersion stringByReplacingOccurrencesOfString:@"."withString:@""];
                NSString *curVersion = [_currentVersion stringByReplacingOccurrencesOfString:@"."withString:@""];
                if ([serVersion integerValue]>[curVersion integerValue]) {
                    _isNewest = NO;
                }else{
                    _isNewest = YES;
                }
                if (_isNewest) {
                    _noticeVersionLab.text = Localized(@"set_newset_version");
                }else{
                    _noticeVersionLab.text = Localized(@"set_check_newset_version");
                }
                [_tableView reloadData];
            }];
        }else{
            [BLHudView linkerHUDStopOrShowWithMsg:errMsg finsh:nil];
        }
    } paramDic:@{} path:@"version_check"];
}

#pragma mark - tableView delegate and source
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;{
    return 0.01;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CheckUpdateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CheckUpdateTableViewCellIdentify" forIndexPath:indexPath];
    [cell setContentWithIndexPath:indexPath isNewest:_isNewest];
    return cell;
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == 0) {
        VersionLogViewController *vVC = [[VersionLogViewController alloc]init];
        [self.navigationController pushViewController:vVC animated:YES];
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
