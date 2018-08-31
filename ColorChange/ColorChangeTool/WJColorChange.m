//
//  WJColorChange.m
//  ColorChange
//
//  Created by wangjin on 2018/8/30.
//  Copyright © 2018年 ELah. All rights reserved.
//

#import "WJColorChange.h"

@interface WJColorChange ()<UIScrollViewDelegate>

/// 开始颜色, 取值范围 0~1
@property (nonatomic, assign) CGFloat startR;
@property (nonatomic, assign) CGFloat startG;
@property (nonatomic, assign) CGFloat startB;
/// 完成颜色, 取值范围 0~1
@property (nonatomic, assign) CGFloat endR;
@property (nonatomic, assign) CGFloat endG;
@property (nonatomic, assign) CGFloat endB;

/// 记录刚开始时的偏移量
@property (nonatomic, assign) NSInteger startOffsetX;
@property (nonatomic,strong) UIScrollView *yourScrollView;
@property (nonatomic,strong) NSArray *colorArray;
@property (nonatomic,strong) UIView *needChangeView;

@end

@implementation WJColorChange

#pragma mark - PublicMethod

- (void)settingScrollView:(UIScrollView*)scrollView colorArray:(NSArray<UIColor *>*)colorArray needChangeColorView:(UIView *)changeView{
    
    if (!scrollView) return;
    if (!colorArray) return;
    
    self.yourScrollView = scrollView;
    self.colorArray = colorArray;
    self.needChangeView = changeView;
    scrollView.delegate = self;
}


#pragma mark - PrivateMethod
- (void)settingWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor {
    
    [self setupStartColor:startColor];
    [self setupEndColor:endColor];
}

- (void)changeViewColorWithCustomView:(UIView *)customView progress:(CGFloat)progress {
    
    [self changeBgViewGradientEffectWithProgress:progress bgView:customView];
}


#pragma mark - - - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    _startOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 1、定义获取需要的数据
    CGFloat progress = 0;
    NSInteger originalIndex = 0;
    NSInteger targetIndex = 0;
    // 2、判断是左滑还是右滑
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    CGFloat scrollViewW = scrollView.bounds.size.width;
    
    if (currentOffsetX > _startOffsetX) { // 左滑
        // 1、计算 progress
        progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW);
        // 2、计算 originalIndex
        originalIndex = currentOffsetX / scrollViewW;
        // 3、计算 targetIndex
        targetIndex = originalIndex + 1;
        if (targetIndex >= self.colorArray.count) {
            targetIndex = self.colorArray.count - 1;
        }
        
        
    } else { // 右滑
        
        // 1、计算 progress
        progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW));
        // 2、计算 targetIndex
        targetIndex = currentOffsetX / scrollViewW;
        // 3、计算 originalIndex
        originalIndex = targetIndex + 1;
        if (originalIndex >= self.colorArray.count) {
            originalIndex = self.colorArray.count - 1;
        }
    }
    
    //3.如果在第一个 不进行颜色改变
    if (currentOffsetX <=0) {
        return;
    }
    [self settingWithStartColor:self.colorArray[originalIndex] endColor:self.colorArray[targetIndex]];
    [self changeViewColorWithCustomView:self.needChangeView progress:progress];
}

#pragma mark - - - 颜色渐变方法抽取
- (void)changeBgViewGradientEffectWithProgress:(CGFloat)progress bgView:(UIView *)bgView {

    CGFloat r = self.endR - self.startR;
    CGFloat g = self.endG - self.startG;
    CGFloat b = self.endB - self.startB;
    
    UIColor *changingColor = [UIColor colorWithRed:self.startR +  r * progress  green:self.startG +  g * progress  blue:self.startB +  b * progress alpha:1.0];
    bgView.backgroundColor = changingColor;

//    NSLog(@"R----%lf\n G-----%lf\n B------%lf",self.startR +  r * progress,self.startG +  g * progress,self.startB +  b * progress);
}

#pragma mark - - - 颜色设置的计算
/**
 开始颜色设置

 @param color 开始颜色
 */
- (void)setupStartColor:(UIColor *)color {
    
    CGFloat components[3];
    [self getRGBComponents:components forColor:color];
    self.startR = components[0];
    self.startG = components[1];
    self.startB = components[2];
}

/**
 结束颜色设置

 @param color 结束颜色
 */
- (void)setupEndColor:(UIColor *)color {
    
    CGFloat components[3];
    [self getRGBComponents:components forColor:color];
    self.endR = components[0];
    self.endG = components[1];
    self.endB = components[2];
}

/**
 *  指定颜色，获取颜色的RGB值
 *
 *  @param components RGB数组
 *  @param color      颜色
 */
- (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color {
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel, 1, 1, 8, 4, rgbColorSpace, 1);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    for (int component = 0; component < 3; component++) {
        components[component] = resultingPixel[component] / 255.0f;
    }
}

@end

