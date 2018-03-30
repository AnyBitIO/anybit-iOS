//
//  CheckSeedPsdViewController.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/1.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "CheckSeedPsdViewController.h"
#import "NSString+Utility.h"
#import "BLUnitsMethods.h"
#import "SetWalletNameViewController.h"
#import "NoCopyPasteTextView.h"
#import "SeedCollectionViewCell.h"

@interface CheckSeedPsdViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    UIButton *_skipBtn;
    UIButton *_backBtn;
    
    UIImageView *_logoView;
    UIView *_alphaView;
    UILabel *_checkSeedLab;
    
    NoCopyPasteTextView *_seedTextView;
    UILabel* _noticeLab;
    
    UIImageView *_attentionView;
    UIImageView *_attentionIcon;
    UILabel *_attentionLab;
    
    UIButton *_nextBtn;

    NSString *_mnemonicWords;
    NSMutableArray *_dataArray;
    NSMutableArray *_comparArray;
    NSString *_seedString;
}

@property(nonatomic,strong)UICollectionView *collectionView;

@end

@implementation CheckSeedPsdViewController

-(id)initWithMnemonicWords:(NSString *)mnemonicWords{
    self = [super init];
    if (self) {
        _mnemonicWords = mnemonicWords;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = Localized(@"login_checkSeedTitle");
    
    [self initData];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(10, fit_X_width+30, 13, 23);
    [_backBtn setBackgroundImage:ImageNamed(@"back") forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
    
//    _skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _skipBtn.frame = CGRectMake(self.view.frame.size.width-50, fit_X_width+30, 40, 30);
//    [_skipBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    [_skipBtn setTitle:Localized(@"login_skip") forState:UIControlStateNormal];
//    [_skipBtn setTitleColor:UIColorFromRGB(0xbdbdbd) forState:UIControlStateNormal];
//    [_skipBtn addTarget:self action:@selector(skipAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_skipBtn];
    
    _logoView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.center.x-55, fit_X_width+60, 110, 78)];
    _logoView.image = ImageNamed(@"logo");
    [self.view addSubview:_logoView];
    
    _alphaView = [[UIView alloc]init];
    _alphaView.backgroundColor = [UIColor whiteColor];
    _alphaView.alpha = 0.2;
    _alphaView.layer.cornerRadius = 5;
    [self.view addSubview:_alphaView];
    
    CGFloat infoHeight = [Localized(@"login_checkSeedInfo") heightForWidth:kMainScreenWidth-20-60 withFont:SYS_FONT(16)];
    _checkSeedLab = [[UILabel alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(_logoView.frame)+50, kMainScreenWidth-80, infoHeight)];
    _checkSeedLab.font = SYS_FONT(16);
    _checkSeedLab.numberOfLines = 0;
    _checkSeedLab.text = Localized(@"login_checkSeedInfo");
    _checkSeedLab.textColor = UIColorFromRGB(0x333333);
    [self.view addSubview:_checkSeedLab];
    
    _seedTextView = [[NoCopyPasteTextView alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(_checkSeedLab.frame)+20, kMainScreenWidth-80, 120)];
    _seedTextView.textColor = UIColorFromRGB(0x333333);
    _seedTextView.font = SYS_FONT(16);
    _seedTextView.editable = NO;
    _seedTextView.layer.cornerRadius = 5;
    [self.view addSubview:_seedTextView];
    
    _noticeLab = [[UILabel alloc]initWithFrame:CGRectMake(5, 2.5, kMainScreenWidth - 20, 30)];
    _noticeLab.text = Localized(@"login_seedNotice");
    _noticeLab.textColor = UIColorFromRGB(0xdadada);
    _noticeLab.font= SYS_FONT(15);
    _noticeLab.hidden= NO;
    [_seedTextView addSubview:_noticeLab];
    
    _attentionView = [[UIImageView alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(_seedTextView.frame)+10, kMainScreenWidth-80, 20)];
    _attentionView.backgroundColor = UIColorFromRGB(0xd02323);
    _attentionView.layer.cornerRadius = 11;
    _attentionView.hidden = YES;
    [self.view addSubview:_attentionView];
    
    _attentionIcon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 4.5, 11, 11)];
    _attentionIcon.image = ImageNamed(@"attention");
    [_attentionView addSubview:_attentionIcon];
    
    _attentionLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxY(_attentionIcon.frame)+10, 4.5, 150, 11)];
    _attentionLab.font = SYS_FONT(10);
    _attentionLab.text = Localized(@"login_seedError");
    _attentionLab.textColor = [UIColor whiteColor];
    [_attentionView addSubview:_attentionLab];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 15;
    layout.minimumInteritemSpacing = 15;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);//每一个 section 与周边的间距
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(_attentionView.frame)+10, kMainScreenWidth-80, 140) collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[SeedCollectionViewCell class] forCellWithReuseIdentifier:@"SeedCollectionViewCellIdentifier"];
    [self.view addSubview:self.collectionView];
    
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBtn.frame = CGRectMake(self.view.center.x-70, CGRectGetMaxY(_collectionView.frame)+30, 140, 50);
    [_nextBtn setBackgroundImage:ImageNamed(@"btn_recovery") forState:UIControlStateNormal];
    [_nextBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_nextBtn setTitle:Localized(@"login_next") forState:UIControlStateNormal];
    [_nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    _nextBtn.userInteractionEnabled = NO;
    [self.view addSubview:_nextBtn];
    
    _alphaView.frame = CGRectMake(10, CGRectGetMaxY(_logoView.frame)+24, kMainScreenWidth-20, CGRectGetMaxY(_nextBtn.frame)-CGRectGetMaxY(_logoView.frame));
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(void)initData{
    _dataArray = [[NSMutableArray alloc]init];
    _comparArray = [[NSMutableArray alloc]init];
    _seedString = @"";
    
    NSArray* tempArray = [_mnemonicWords componentsSeparatedByString:@" "];
    tempArray = [tempArray sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
        int seed = arc4random_uniform(2);
        if (seed) {
            return [str1 compare:str2];
        } else {
            return [str2 compare:str1];
        }
    }];
    
    for (NSString *str in tempArray) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:str forKey:@"name"];
        [dic setObject:@"0" forKey:@"select"];
        [_dataArray addObject:dic];
    }
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)skipAction{
    SetWalletNameViewController *slVC = [[SetWalletNameViewController alloc]initWithIsRecover:NO mnemonicWords:_mnemonicWords];
    [self.navigationController pushViewController:slVC animated:YES];
}

-(void)nextAction{
    NSString *compare_normal = [NSString stringWithoutSpaceWithString:_mnemonicWords];
    NSString *compare_Edit = [NSString stringWithoutSpaceWithString:_seedString];
    
    if (![compare_normal isEqualToString:compare_Edit]){
        _seedTextView.layer.borderColor = UIColorFromRGB(0xd02323).CGColor;
        _seedTextView.layer.borderWidth = 2.0;
        _attentionView.hidden = NO;
        return;
    }
    
    SetWalletNameViewController *slVC = [[SetWalletNameViewController alloc]initWithIsRecover:NO mnemonicWords:_mnemonicWords];
    [self.navigationController pushViewController:slVC animated:YES];
}

#pragma mark- UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_dataArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SeedCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"SeedCollectionViewCellIdentifier" forIndexPath:indexPath];
    NSDictionary *dic = [_dataArray objectAtIndex:indexPath.row];
    [cell setMnemonicWords:dic];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = [_dataArray objectAtIndex:indexPath.row];
    CGFloat seedWidth = [[dic objectForKey:@"name"] widthForHeight:25 withFont:SYS_FONT(16)];
    return CGSizeMake(seedWidth+8, 25);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 7.5, 0, 7.5);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 7.5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 7.5;
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    NSMutableDictionary *dic = [_dataArray objectAtIndex:indexPath.row];
    if ([[dic objectForKey:@"select"] isEqualToString:@"1"]) {
        [dic setObject:@"0" forKey:@"select"];
        [_comparArray removeObject:dic];
    }else{
        [dic setObject:@"1" forKey:@"select"];
        [_comparArray addObject:dic];
    }
    [self setNextBtnAndTextFieldWithArray:_comparArray];
    [_collectionView reloadData];

}

-(void)setNextBtnAndTextFieldWithArray:(NSMutableArray*)array{
    _seedString = @"";
    for (NSDictionary *dic in array) {
        _seedString = [_seedString stringByAppendingFormat:@"%@",[NSString stringWithFormat:@" %@",[dic objectForKey:@"name"]]];
    }
    _seedTextView.text = _seedString;
    
    if(array.count == 18){
        _noticeLab.hidden = YES;
        _noticeLab.hidden= YES;
        _nextBtn.userInteractionEnabled = YES;
        [_nextBtn setBackgroundImage:ImageNamed(@"btn_establish") forState:UIControlStateNormal];
        [_nextBtn setBackgroundImage:ImageNamed(@"btn_recovery") forState:UIControlStateHighlighted];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextBtn setTitleColor:UIColorFromRGB(0x02a4ff) forState:UIControlStateHighlighted];
    }else{
        _noticeLab.hidden = NO;
        _nextBtn.userInteractionEnabled = NO;
        [_nextBtn setBackgroundImage:ImageNamed(@"btn_recovery") forState:UIControlStateNormal];
        [_nextBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        if (array.count == 0) {
            _noticeLab.hidden= NO;
        }else{
            _noticeLab.hidden= YES;;
        }
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
