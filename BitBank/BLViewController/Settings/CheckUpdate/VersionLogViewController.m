//
//  VersionLogViewController.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/14.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "VersionLogViewController.h"
#import "VersionLogTableViewCell.h"
#import "NSString+Utility.h"

@interface VersionLogViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *_dataArray;
}

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation VersionLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = Localized(@"set_version_log");
    
    _dataArray = [[NSMutableArray alloc]init];
    
    [self initData];
    [self initUI];
}

-(void)initData{
    
    [_dataArray addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"version":@"V1.3.0",
                                                                          @"content":Localized(@"set_version_103"),
                                                                          @"height":[NSString stringWithFormat:@"%f",[Localized(@"set_version_103") heightForWidth:kMainScreenWidth-20-20*2 withFont:SYS_FONT(15)]],
                                                                          @"isShow":@"1"}]];
    [_dataArray addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"version":@"V1.0.1",
                                                                          @"content":Localized(@"set_version_101"),
                                                                          @"height":[NSString stringWithFormat:@"%f",[Localized(@"set_version_101") heightForWidth:kMainScreenWidth-20-20*2 withFont:SYS_FONT(15)]],
                                                                          @"isShow":@"0"
                                                                          }]];

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
            
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(10);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-10);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-10);
        }];
    } else {
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.view.mas_top).offset(10);
            make.left.equalTo(self.view.mas_left).offset(10);
            make.right.equalTo(self.view.mas_right).offset(-10);
            make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        }];
    }
    
    [_tableView registerClass:[VersionLogTableViewCell class] forCellReuseIdentifier:@"VersionLogTableViewCellIdentify"];
}

#pragma mark - tableView delegate and source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableDictionary *dic = [_dataArray objectAtIndex:section];
    if ([[dic objectForKey:@"isShow"] isEqualToString:@"1"]){
        return 1;
    }
    else{
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dic = [_dataArray objectAtIndex:indexPath.section];
    if ([[dic objectForKey:@"isShow"] isEqualToString:@"1"]){
        CGFloat height = [[dic objectForKey:@"height"] floatValue];
        return height+20;
    }
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VersionLogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VersionLogTableViewCellIdentify" forIndexPath:indexPath];
    [cell setContentWithArray:_dataArray indexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSMutableDictionary *dic = [_dataArray objectAtIndex:section];
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth-20, 40)];
    headView.backgroundColor = [UIColor whiteColor];
    
    UILabel * titleLab = [[UILabel alloc]initWithFrame:CGRectMake(20,15, headView.frame.size.width-20*2-30, 20)];
    titleLab.font = SYS_FONT(15);
    titleLab.textColor = UIColorFromRGB(0xABABAB);
    titleLab.text = [dic objectForKey:@"version"];
    [headView addSubview:titleLab];
    
    UILabel *lineLab = [[UILabel alloc]initWithFrame:CGRectMake(0,49.5, headView.frame.size.width, 0.5)];
    lineLab.backgroundColor = LINE_COLOR;
    [headView addSubview:lineLab];

    UIButton *bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bgBtn.frame = CGRectMake(0, 0, headView.frame.size.width, 40);
    bgBtn.tag = section;
    if ([[dic objectForKey:@"isShow"] isEqualToString:@"1"]){
        bgBtn.selected = YES;
    }else{
        bgBtn.selected = NO;
    }
    [bgBtn setImage:[UIImage imageNamed:@"upArrow"] forState:UIControlStateSelected];
    [bgBtn setImage:[UIImage imageNamed:@"downArrow"] forState:UIControlStateNormal];
    [bgBtn setImageEdgeInsets:UIEdgeInsetsMake(5,headView.frame.size.width-32, 0,0)];
    [bgBtn addTarget:self action:@selector(clickShowPlatforms:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:bgBtn];
    return headView;
}

-(void)clickShowPlatforms:(UIButton*)sender
{
    UIButton *btn = (UIButton*)sender;
    NSMutableDictionary *dic = [_dataArray objectAtIndex:btn.tag];
    
    NSMutableArray *indexPaths = [[NSMutableArray alloc]init];
    [indexPaths addObject:[NSIndexPath indexPathForRow:0 inSection:btn.tag]];
    
    if ([[dic objectForKey:@"isShow"] isEqualToString:@"1"]){
        btn.selected = NO;
        [dic setValue:@"0" forKey:@"isShow"];
        [_tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    }else{
        btn.selected = YES;
        [dic setValue:@"1" forKey:@"isShow"];
        [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
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
