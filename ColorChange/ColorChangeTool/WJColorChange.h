//
//  WJColorChange.h
//  ColorChange
//
//  Created by wangjin on 2018/8/30.
//  Copyright © 2018年 ELah. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol WJColorChangeDelegate <NSObject>


/**
 滚动时候回调 传出当前的滚动视图

 @param scrollView 滚动视图
 */
- (void)WJColorScrollViewScroll:(UIScrollView *)scrollView;


/**
 滚动结束时候回调

 @param scrollView 滚动视图
 */
- (void)WJColorEndScroll:(UIScrollView *)scrollView;

@end

typedef enum : NSUInteger {
    SingleColor,//背景单色
    TransverseGradientColor, // 背景横向渐变色
} ColorType;

@interface WJColorChange : NSObject


/**
 初始化对象

 @param colorType 颜色类型设置
 @return 返回对象实体
 */
- (instancetype)initWithType:(ColorType)colorType;

/**
 设置颜色的方法 单色背景

 @param scrollView 滚动的视图
 @param colorArray 颜色数组
 @param changeView 需要颜色变化的View
 */
- (void)settingScrollView:(UIScrollView*)scrollView colorArray:(NSArray<UIColor *>*)colorArray needChangeColorView:(UIView *)changeView;


/**
 设置颜色的方法 渐变背景

 @param scrollView 滚动的视图
 @param colorArray 渐变颜色数组
 @param changeView 需要变化的View  --- 这里不能与滚动视图同对象 
 */
- (void)settingArrayScrollView:(UIScrollView*)scrollView colorArray:(NSArray<NSArray*>*)colorArray needChangeColorView:(UIView *)changeView;


/**
 颜色类型
 */
@property (nonatomic,assign) ColorType colorType;

@property (nonatomic,assign) id<WJColorChangeDelegate> delegate;

@end
