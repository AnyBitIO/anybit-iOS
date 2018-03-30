//
//  CommonWebViewController.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/27.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "CommonWebViewController.h"
#import "BLHttpsRequest.h"
#import "NSString+Utility.h"

@interface CommonWebViewController ()<UIWebViewDelegate>{
    NSString *_title;
    NSString *_pageType;
    NSString *_htmlRequestString;
    NSString *_currentRequestString;
    UIWebView *_myWebView;
}

@property(nonatomic, strong) NSURLRequest *urlRequest;

@end

@implementation CommonWebViewController

-(id)initWithTitle:(NSString*)title  pageType:(NSString*)pageType{
    self = [super init];
    if (self) {
        _title = title;
        _pageType = pageType;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = _title;
    
    _myWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kScreenHeightNoStatusAndNoNaviBarHeight)];
    _myWebView.scalesPageToFit = YES;
    _myWebView.delegate = self;
    [self.view addSubview:_myWebView];
    
    [self getUrl];
}

-(void)dealloc{
    _myWebView.delegate = nil;
    _myWebView = nil;
}

-(void)getUrl{
    [BLHudView linkerUnEnableHUDShowToViewController:self];
    
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
    } paramDic:@{@"pageType":_pageType} path:@"web_page"];
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
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [BLHudView linkerHUDStopOrShowWithMsg:Localized(@"wallet_loading_fail") finsh:nil];
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
