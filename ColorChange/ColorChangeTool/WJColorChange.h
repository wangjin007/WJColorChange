//
//  WJColorChange.h
//  ColorChange
//
//  Created by wangjin on 2018/8/30.
//  Copyright © 2018年 ELah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJColorChange : NSObject


/**
 设置颜色的方法

 @param scrollView 滚动的视图
 @param colorArray 颜色数组
 @param changeView 需要颜色变化的View
 */
- (void)settingScrollView:(UIScrollView*)scrollView colorArray:(NSArray<UIColor *>*)colorArray needChangeColorView:(UIView *)changeView;

@end
