//
//  BLMarketViewController.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/2/28.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "BLMarketViewController.h"
#import "BLHttpsRequest.h"
#import "NSString+Utility.h"
#import "MJRefreshNormalHeader.h"

@interface BLMarketViewController ()<UIWebViewDelegate>{
    NSString *_htmlRequestString;
    NSString *_currentRequestString;
    UIWebView *_myWebView;
}
@property(nonatomic, strong) NSURLRequest *urlRequest;

@end

@implementation BLMarketViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.navigationItem.title = Localized(@"bl_market");
    
    _myWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kScreenHeightNoStatusAndNoNaviBarNOTabBarHeight)];
    _myWebView.scalesPageToFit = YES;
    _myWebView.delegate = self;
    [self.view addSubview:_myWebView];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getAllDataFromServer)];
    header.lastUpdatedTimeLabel.hidden = YES;
    _myWebView.scrollView.mj_header = header;
    
    [self getUrl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = nil;
}

-(void)dealloc{
    _myWebView.delegate = nil;
    _myWebView = nil;
}

-(void)getUrl{
    [BLHttpsRequest basePostHttpsRequestWithBlock:^(NSDictionary *responseObject, NSString *rtnCode, NSString *errCode, NSString *errMsg, NSError *error){
        if ([rtnCode isEqualToString:BL_HTTP_CODE_OK]) {
            [BLHudView linkerHUDStopOrShowWithMsg:nil finsh:nil];
            
            NSDictionary *returnDic = [responseObject objectForKey:@"data"];
            _htmlRequestString = [NSString stringWithoutNil:[returnDic objectForKey:@"pageUrl"]];
            _currentRequestString = _htmlRequestString;
            _urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:_htmlRequestString]];
            [_myWebView loadRequest:_urlRequest];
            
        }else{
            [BLHudView linkerHUDStopOrShowWithMsg:errMsg finsh:nil];
        }
    } paramDic:@{@"pageType":@"market"} path:@"web_page"];
}

-(void)getAllDataFromServer{
    [self getUrl];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    _currentRequestString = [NSString stringWithFormat:@"%@", request.URL];
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [BLHudView linkerUnEnableHUDShowToViewController:self];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [BLHudView linkerHUDStopOrShowWithMsg:nil finsh:nil];
    if (_myWebView.scrollView.mj_header.isRefreshing){
        [_myWebView.scrollView.mj_header endRefreshing];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"wallet_loading_fail") finsh:nil];
    if (_myWebView.scrollView.mj_header.isRefreshing){
        [_myWebView.scrollView.mj_header endRefreshing];
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
