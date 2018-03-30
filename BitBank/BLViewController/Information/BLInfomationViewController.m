//
//  BLInfomationViewController.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/2/28.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "BLInfomationViewController.h"

@interface BLInfomationViewController (){
    
    UIImageView *_imageView;
    UILabel *_textLab;
}

@end

@implementation BLInfomationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = Localized(@"bl_infomation");
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.center.x-85, self.view.center.y-183, 172, 183)];
    _imageView.image = ImageNamed(@"no_infoBar");
    [self.view addSubview:_imageView];
    
    _textLab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageView.frame)+30, kMainScreenWidth, 20)];
    _textLab.font = SYS_FONT(16);
    _textLab.textColor = UIColorFromRGB(0x999999);
    _textLab.textAlignment = NSTextAlignmentCenter;
    _textLab.text = Localized(@"information_coming");
    [self.view addSubview:_textLab];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = nil;
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
