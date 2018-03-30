//
//  BLEmptyDataSourceAndDelegate.m
//  BitBank
//
//  Created by 张蒙蒙 on 2018/3/21.
//  Copyright © 2018年 张蒙蒙. All rights reserved.
//

#import "BLEmptyDataSourceAndDelegate.h"

@implementation BLEmptyDataSourceAndDelegate

#pragma mark - instance method
/**
 *  title + description
 *
 *   title
 *   des
 */
- (instancetype)initWithTitle:(NSString *)title description:(NSString *)des
{
    return [self initWithImage:nil title:title description:des];
}

/**
 *  图片 + title + description
 *
 *   bgImage
 *   title
 *   des
 *
 */
- (instancetype)initWithImage:(UIImage *)bgImage title:(NSString *)title description:(NSString *)des
{
    if (self = [super init]) {
        self.bgImage = bgImage;
        self.titleStr = title;
        self.descriptionStr = des;
    }
    
    return self;
}

/**
 *  图片 + title + description
 *
 *   bgImage
 *   title
 *   des
 *
 */
- (instancetype)initWithImage:(UIImage *)bgImage title:(NSString *)title description:(NSString *)des canScroll:(BOOL)canScroll
{
    if (self = [super init]) {
        self.bgImage = bgImage;
        self.titleStr = title;
        self.descriptionStr = des;
        self.canScroll = canScroll;
    }
    
    return self;
}

/**
 *  customView
 *
 */
- (instancetype)initCustomView:(UIView *)custemView canScroll:(BOOL)canScroll
{
    if (self = [super init]) {
        self.customView = custemView;
        self.canScroll = canScroll;
    }
    return self;
}


#pragma mark - class method
+ (instancetype)emptyDataSetWithCustom:(UIView *)customView canScroll:(BOOL)canScroll
{
    return [[BLEmptyDataSourceAndDelegate alloc] initCustomView:customView canScroll:canScroll];
}

+ (instancetype)emptyDataSetWithTitle:(NSString *)title
                          description:(NSString *)des
{
    return [[BLEmptyDataSourceAndDelegate alloc] initWithImage:nil title:title description:des];
}

+ (instancetype)emptyDataSetWithTitle:(NSString *)title
                          description:(NSString *)des
                            canScroll:(BOOL)canScroll
{
    return [[BLEmptyDataSourceAndDelegate alloc] initWithImage:nil title:title description:des canScroll:canScroll];
}

+ (instancetype)emptyDataSetWithImage:(UIImage *)bgImage
                                title:(NSString *)title
                          description:(NSString *)des
                            canScroll:(BOOL)canScroll;
{
    return [[BLEmptyDataSourceAndDelegate alloc] initWithImage:bgImage title:title description:des canScroll:canScroll];
}


#pragma mark - DZNEmptyDataSetDelegate -
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return self.canScroll;
}

#pragma mark - DZNEmptyDataSetSource -
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.titleStr != nil) {
        return [BLEmptyDataSourceAndDelegate getAttributeStrWithStr:self.titleStr];
    }
    return nil;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.descriptionStr != nil) {
        return [BLEmptyDataSourceAndDelegate getAttributeStrWithStr:self.descriptionStr];
    }
    return nil;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.bgImage != nil) {
        return self.bgImage;
    }
    return nil;
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.customView != nil) {
        return self.customView;
    }
    return nil;
}

#pragma mark - 返回属性化字符串
+ (NSAttributedString *)getAttributeStrWithStr:(NSString *)str
{
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0x9E9E9E),NSFontAttributeName: SYS_FONT(16)}];
    return attrStr;
}

-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    CGFloat offset = 0.0;
    if (self.blEmptyDataSetDelegate && [self.blEmptyDataSetDelegate respondsToSelector:@selector(verticalOffsetForYSEmptyDataSet:)])
    {
        offset = [self.blEmptyDataSetDelegate verticalOffsetForYSEmptyDataSet:scrollView];
        
    }
    return offset;
}


@end
