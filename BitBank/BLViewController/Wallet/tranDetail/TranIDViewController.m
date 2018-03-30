//
//  TranIDViewController.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/13.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "TranIDViewController.h"

@interface TranIDViewController ()<UIWebViewDelegate>{
    NSString *_txId;
    
    UIWebView           *_myWebView;
    NSString            *_htmlRequestString;
    NSString            * _currentRequestString;
}

@property(nonatomic, strong) NSURLRequest *urlRequest;

@end

@implementation TranIDViewController

-(id)initWithTxId:(NSString*)txId{
    self = [super init];
    if (self) {
        _txId = txId;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    _myWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kScreenHeightNoStatusAndNoNaviBarHeight)];
    _myWebView.scalesPageToFit = YES;
    _myWebView.delegate = self;
    
    [self.view addSubview:_myWebView];
    
    _htmlRequestString = [NSString stringWithFormat:@"https://block.bitbank.com/tx/ubtc/%@",_txId];
    _currentRequestString = _htmlRequestString;
    
    _urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:_htmlRequestString]];
    
    [_myWebView loadRequest:_urlRequest];
}

-(void)dealloc{
    _myWebView.delegate = nil;
    _myWebView = nil;
}

//- (BOOL)navigationShouldPopOnBackButton
//{
//    if (![_currentRequestString isEqualToString:_htmlRequestString]) {
//        [_myWebView goBack];
//        return NO;
//    }
//    return YES;
//}

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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
