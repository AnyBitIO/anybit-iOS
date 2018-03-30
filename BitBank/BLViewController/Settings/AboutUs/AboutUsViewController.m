//
//  AboutUsViewController.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/8.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "AboutUsViewController.h"
#import "AboutUsTableViewCell.h"
#import "NSString+Utility.h"
#import "AboutUsTableViewCell.h"
#import "CommonWebViewController.h"
#import "RecommendShareViewController.h"

@interface AboutUsViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UIView *_bgView;
    UIImageView *_logoImageView;
    UILabel *_textLab;
}

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = Localized(@"setting_about_us");
    

    _bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, kMainScreenWidth-20, kScreenHeightNoStatusAndNoNaviBarHeight-20)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgView];
    
    _logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_bgView.center.x-41, 60, 82, 82)];
    _logoImageView.image = ImageNamed(@"icon_logo");
    [_bgView addSubview:_logoImageView];
    
    CGFloat textHeight = [Localized(@"set_about_us") heightForWidth:300 withFont:SYS_FONT(15)];
    _textLab = [[UILabel alloc] initWithFrame:CGRectMake(_bgView.center.x-150, CGRectGetMaxY(_logoImageView.frame)+20, 300, textHeight)];
    _textLab.font = SYS_FONT(15);
    _textLab.textColor = UIColorFromRGB(0x666666);
    _textLab.textAlignment = NSTextAlignmentCenter;
    _textLab.text = Localized(@"set_about_us");
    _textLab.numberOfLines = 0;
    [_bgView addSubview:_textLab];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_textLab.frame)+60, _bgView.frame.size.width-20, 60*4) style:UITableViewStyleGrouped];
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
    
    [_tableView registerClass:[AboutUsTableViewCell class] forCellReuseIdentifier:@"AboutUsTableViewCellIdentify"];
    
}

#pragma mark - tableView delegate and source
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;{
    return 0.01;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AboutUsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AboutUsTableViewCellIdentify" forIndexPath:indexPath];
    [cell setContentWithIndexPath:indexPath];
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
        CommonWebViewController *cVC = [[CommonWebViewController alloc]initWithTitle:Localized(@"set_terms_of_use") pageType:@"service"];
        [self.navigationController pushViewController:cVC animated:YES];
    }else if (indexPath.row == 1) {
        CommonWebViewController *cVC = [[CommonWebViewController alloc]initWithTitle:Localized(@"set_privacy_policy") pageType:@"privacy"];
        [self.navigationController pushViewController:cVC animated:YES];
    }else if (indexPath.row == 2) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:Localized(@"set_mail") message:@"info@blocklinker.com" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:Localized(@"common_cancel")  style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction *copyAction = [UIAlertAction actionWithTitle:Localized(@"set_copy")  style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"wallet_copy_success") finsh:^{
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = @"info@blocklinker.com";
            }];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:copyAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else if (indexPath.row == 3) {
        RecommendShareViewController *rVC = [[RecommendShareViewController alloc]init];
        [self.navigationController pushViewController:rVC animated:YES];
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
