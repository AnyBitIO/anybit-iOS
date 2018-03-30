//
//  BLEmptyDataSourceAndDelegate.h
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/21.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIScrollView+EmptyDataSet.h"

@protocol BLEmptyDataSetDelegate <NSObject>

@optional

- (CGFloat)verticalOffsetForYSEmptyDataSet:(UIScrollView *)scrollView;

@end


@interface BLEmptyDataSourceAndDelegate : NSObject <DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
#pragma mark - 属性
@property (nonatomic, strong) UIImage * bgImage;        // 背景图片
@property (nonatomic, copy) NSString * titleStr;        // 标题
@property (nonatomic, copy) NSString * descriptionStr;  // 描述
@property (nonatomic, strong) UIView * customView;      //
@property (nonatomic, assign) BOOL canScroll;         //是否可滑动
@property (nonatomic,weak) id<BLEmptyDataSetDelegate>blEmptyDataSetDelegate;

#pragma mark -
#pragma mark - 初始化（实例方法）
/** 标题 + 描述 */
- (instancetype)initWithTitle:(NSString *)title description:(NSString *)des;
/** 背景图片 + 标题 + 描述 */
- (instancetype)initWithImage:(UIImage *)bgImage title:(NSString *)title description:(NSString *)des;


#pragma mark - 初始化（类方法）
+ (instancetype)emptyDataSetWithCustom:(UIView *)customView canScroll:(BOOL)canScroll;

+ (instancetype)emptyDataSetWithTitle:(NSString *)title
                          description:(NSString *)des;

+ (instancetype)emptyDataSetWithTitle:(NSString *)title
                          description:(NSString *)des
                            canScroll:(BOOL)canScroll;

+ (instancetype)emptyDataSetWithImage:(UIImage *)bgImage
                                title:(NSString *)title
                          description:(NSString *)des
                            canScroll:(BOOL)canScroll;


@end
