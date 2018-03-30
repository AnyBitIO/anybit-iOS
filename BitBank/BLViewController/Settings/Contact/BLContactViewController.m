//
//  BLContactViewController.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/2/28.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "BLContactViewController.h"
#import "BLUnitsMethods.h"
#import "ContactTableViewCell.h"
#import "ContactModel.h"
#import "BMChineseSort.h"
#import "AddUserViewController.h"
#import "ContactsDBManager.h"
#import "AddUserViewController.h"
#import "BLHttpsRequest.h"
#import "NSString+Utility.h"

@interface BLContactViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate>{
    NSMutableArray *_dataArray;
    NSMutableArray *_filterArray;
    NSString *_searchString;
    BOOL _isSearch;
    
    //排序后的出现过的拼音首字母数组
    NSMutableArray *_indexArray;
    //排序好的结果数组
    NSMutableArray *_letterResultArr;
    
    NSString *_coinType;
    GetAddressBlock _addressBlock;
    
    UIImageView *_bgEmptyView;
}

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UISearchController *searchCon;
@property (nonatomic, strong)UITableView *searchResultTableView;

@end

@implementation BLContactViewController

-(id)initWithCoinType:(NSString *)coinType block:(GetAddressBlock)block{
    self = [super init];
    if (self) {
        _coinType = coinType;
        _addressBlock = block;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = Localized(@"bl_contact");
    
    [BLUnitsMethods drawTheRightBarBtnWithImage:ImageNamed(@"add_user") target:self action:@selector(addUserAction)];
    
    [self initData];
    
    [self initSearchView];
    
    [self initTableView];
    
    [self initEmptyView];
    
    [self getDataFromSerbver];
}

-(void)initData{
    _dataArray   = [[NSMutableArray alloc]init];
    _filterArray = [[NSMutableArray alloc]init];
    _searchString = @"";
    
    _dataArray = [ContactsDBManager queryAllContactsDB];
    if (_dataArray.count>0) {
        _indexArray = [BMChineseSort IndexWithArray:_dataArray Key:@"nickName"];
        _letterResultArr = [BMChineseSort sortObjectArray:_dataArray Key:@"nickName"];
    }
}

- (void)initTableView{
    
    _tableView =[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate   = self;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.estimatedRowHeight = 70;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    
    if (@available(iOS 11.0, *)) {
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(56);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }];
    }else{
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(44, 0, 0, 0));
        }];
    }
    
    if([_tableView respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]){
        _tableView.cellLayoutMarginsFollowReadableWidth = NO;
    }
    
    _searchResultTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _searchResultTableView.delegate = self;
    _searchResultTableView.dataSource = self;
    _searchResultTableView.backgroundColor = [UIColor whiteColor];
    _searchResultTableView.tableFooterView = [UIView new];
    _searchResultTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _searchResultTableView.estimatedRowHeight = 70;
    _searchResultTableView.rowHeight = UITableViewAutomaticDimension;
    [_searchCon.view addSubview:_searchResultTableView];
    
    
    if (@available(iOS 11.0, *)){
        _searchResultTableView.estimatedSectionHeaderHeight = 0;
        _searchResultTableView.estimatedSectionFooterHeight = 0;
        _searchResultTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        CGFloat searchBarHeight = CGRectGetHeight(_searchCon.searchBar.frame);
        [_searchResultTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_searchCon.view.mas_safeAreaLayoutGuideTop).offset(searchBarHeight);
            make.left.equalTo(_searchCon.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(_searchCon.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(_searchCon.view.mas_safeAreaLayoutGuideBottom);
        }];
    }else{
        [_searchResultTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_searchCon.view).insets(UIEdgeInsetsMake(64, 0, 0, 0));
        }];
    }
}

-(void)initSearchView{
    _searchCon = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchCon.delegate = self;
    _searchCon.searchResultsUpdater = self;
    _searchCon.dimsBackgroundDuringPresentation = NO;
    [_searchCon.searchBar sizeToFit];
    _searchCon.searchBar.delegate = self;
    
    _searchCon.searchBar.tintColor = [UIColor whiteColor];
    [_searchCon.searchBar setBackgroundImage:[BLUnitsMethods imageWithColor:UIColorFromRGB(0x557ec5)] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    _searchCon.searchBar.placeholder = Localized(@"contact_serach_notice");
    [self.view addSubview:_searchCon.searchBar];
    
    self.definesPresentationContext = YES;
}

-(void)initEmptyView{
    _bgEmptyView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    _bgEmptyView.image = ImageNamed(@"other_bg");
    [self.view addSubview:_bgEmptyView];
    
    UIImageView *noContacntView = [[UIImageView alloc]initWithFrame:CGRectMake(_bgEmptyView.center.x-85.5, _bgEmptyView.center.y-72.5, 171, 145)];
    noContacntView.image = ImageNamed(@"noContacnt");
    [_bgEmptyView addSubview:noContacntView];
    
    [self hiddenEmptyView];
}


-(void)addUserAction{
    AddUserViewController *aVC = [[AddUserViewController alloc]initWithModel:nil addUserBlock:^(ContactModel *model) {
        [_dataArray addObject:model];
        [_indexArray removeAllObjects];
        [_letterResultArr removeAllObjects];
        if (_dataArray.count>0) {
            _indexArray = [BMChineseSort IndexWithArray:_dataArray Key:@"nickName"];
            _letterResultArr = [BMChineseSort sortObjectArray:_dataArray Key:@"nickName"];
        }
        [self hiddenEmptyView];
        [_tableView reloadData];
    } ];
    aVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:aVC animated:YES];
}

#pragma mark - tableView delegate and source
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_searchCon.searchBar resignFirstResponder];
}

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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _tableView){
        return [_indexArray count];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tableView){
        return [[_letterResultArr objectAtIndex:section] count];
    }
    return [_filterArray count];
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _tableView){
        return 25;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;{
    return 0.01;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"identifier";
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil){
        cell = [[ContactTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (tableView == _tableView){
        ContactModel *model = [[_letterResultArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [cell setContentWithModel:model];
    }else{
        ContactModel *model = [_filterArray objectAtIndex:indexPath.row];
        [cell setContentWithModel:model];
    }
    return cell;
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *modifyRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        if (tableView == _tableView){
            ContactModel *model = [[_letterResultArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            [self deleteContactWithModel:model];
        }else{
            ContactModel *model = [_filterArray objectAtIndex:indexPath.row];
            [self deleteContactWithModel:model];
        }
    }];
    modifyRowAction.backgroundColor = [UIColor redColor];
    return @[modifyRowAction];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == _tableView){
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 25)];
        UILabel *textLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kMainScreenWidth-30, 25)];
        textLab.text = [_indexArray objectAtIndex:section];
        [headView addSubview:textLab];
        return headView;
    }
    return nil;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
   
    if (tableView == _tableView){
        return _indexArray;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    if (tableView == _tableView){
        return index;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == _tableView){
        ContactModel *editModel = [[_letterResultArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        if (_addressBlock) {
            _addressBlock(editModel.address);
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            AddUserViewController *aVC = [[AddUserViewController alloc]initWithModel:editModel addUserBlock:^(ContactModel *model) {
                [_dataArray removeObject:editModel];
                [_dataArray addObject:model];
                [_indexArray removeAllObjects];
                [_letterResultArr removeAllObjects];
                if (_dataArray.count>0) {
                    _indexArray = [BMChineseSort IndexWithArray:_dataArray Key:@"nickName"];
                    _letterResultArr = [BMChineseSort sortObjectArray:_dataArray Key:@"nickName"];
                }
                [_tableView reloadData];
            } ];
            aVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aVC animated:YES];
        }
    }else{
        ContactModel *filterModel = [_filterArray objectAtIndex:indexPath.row];
        if (_addressBlock) {
            _addressBlock(filterModel.address);
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            AddUserViewController *aVC = [[AddUserViewController alloc]initWithModel:filterModel addUserBlock:^(ContactModel *model) {
                [_dataArray removeObject:filterModel];
                [_dataArray addObject:model];
                [_indexArray removeAllObjects];
                [_letterResultArr removeAllObjects];
                if (_dataArray.count>0) {
                    _indexArray = [BMChineseSort IndexWithArray:_dataArray Key:@"nickName"];
                    _letterResultArr = [BMChineseSort sortObjectArray:_dataArray Key:@"nickName"];
                }
                [_tableView reloadData];
                
                [_filterArray removeObject:filterModel];
                [_filterArray addObject:model];
                [_searchResultTableView reloadData];
            } ];
            aVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aVC animated:YES];
        }
    }
    
}

#pragma mark - UISearchBar Delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    _isSearch = YES;
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    _isSearch = NO;
    [_filterArray removeAllObjects];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self getDataFromSerbver];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    _searchString = searchController.searchBar.text;
    [_searchResultTableView reloadData];
}


-(void)getDataFromSerbver{
    
    [BLHudView linkerUnEnableHUDShowToViewController:self];
    
    [BLHttpsRequest basePostHttpsRequestWithBlock:^(NSDictionary *responseObject, NSString *rtnCode, NSString *errCode, NSString *errMsg, NSError *error) {
        if ([rtnCode isEqualToString:BL_HTTP_CODE_OK]) {
            [BLHudView linkerHUDStopOrShowWithMsg:nil finsh:nil];
            NSDictionary *returnDic = [responseObject objectForKey:@"data"];
            NSArray *contacters = [returnDic objectForKey:@"contacters"];
            NSMutableArray *array = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in contacters) {
                ContactModel *model = [[ContactModel alloc]init];
                model.address = [NSString stringWithoutNil:[dic objectForKey:@"contacterAddr"]];
                model.nickName = [NSString stringWithoutNil:[dic objectForKey:@"nickName"]];
                model.coinType = [NSString stringWithoutNil:[dic objectForKey:@"coinType"]];
                [array addObject:model];
            }
            
            if (_isSearch) {
                [_filterArray removeAllObjects];
                [_filterArray addObjectsFromArray:array];
                [_searchResultTableView reloadData];
            }else{
                for (ContactModel *model in array) {
                    [ContactsDBManager insertContactsDBWithModel:model];
                }
                [_dataArray removeAllObjects];
                [_dataArray addObjectsFromArray:array];
                if (_dataArray.count>0) {
                    _indexArray = [BMChineseSort IndexWithArray:_dataArray Key:@"nickName"];
                    _letterResultArr = [BMChineseSort sortObjectArray:_dataArray Key:@"nickName"];
                }
                [self hiddenEmptyView];
                [_tableView reloadData];
            }
        }else{
            [BLHudView linkerHUDStopOrShowWithMsg:errMsg finsh:nil];
        }
    } paramDic:@{@"nickName":_searchString,@"coinType":_coinType} path:@"contacter_query"];
}

-(void)deleteContactWithModel:(ContactModel*)model{
    
    [BLHudView linkerUnEnableHUDShowToViewController:self];
    
    [BLHttpsRequest basePostHttpsRequestWithBlock:^(NSDictionary *responseObject, NSString *rtnCode, NSString *errCode, NSString *errMsg, NSError *error){
        if ([rtnCode isEqualToString:BL_HTTP_CODE_OK]) {
            [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"contact_delete_success") finsh:^{
                
                for (ContactModel *tempModel in _dataArray) {
                    if ([model.address isEqualToString:tempModel.address]&&
                        [model.coinType isEqualToString:tempModel.coinType]) {
                        [_dataArray removeObject:tempModel];
                        [ContactsDBManager deleteContactsDBWithModel:tempModel];
                        [_indexArray removeAllObjects];
                        [_letterResultArr removeAllObjects];
                        if (_dataArray.count>0) {
                            _indexArray = [BMChineseSort IndexWithArray:_dataArray Key:@"nickName"];
                            _letterResultArr = [BMChineseSort sortObjectArray:_dataArray Key:@"nickName"];
                        }
                        [_tableView reloadData];
                        break;
                    }
                }
                
                if (_isSearch) {
                    [_filterArray removeObject:model];
                    [ContactsDBManager deleteContactsDBWithModel:model];
                    [_searchResultTableView reloadData];
                }
                
                [self hiddenEmptyView];
            }];
        }else{
            [BLHudView linkerHUDStopOrShowWithMsg:errMsg finsh:nil];
        }
    } paramDic:@{@"contacterAddr":model.address,@"coinType":model.coinType} path:@"contacter_delete"];
}

-(void)hiddenEmptyView{
    if (_dataArray.count>0) {
        _bgEmptyView.hidden = YES;
    }else{
        _bgEmptyView.hidden = NO;;
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
