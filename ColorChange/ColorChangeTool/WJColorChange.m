//
//  WJColorChange.m
//  ColorChange
//
//  Created by wangjin on 2018/8/30.
//  Copyright © 2018年 ELah. All rights reserved.
//

// 增加了 横向渐变的效果 添加了 类型设置

#import "WJColorChange.h"

@interface WJColorChange ()<UIScrollViewDelegate>


/// 单颜色视图下的背景色
/// 开始颜色, 取值范围 0~1
@property (nonatomic, assign) CGFloat startR;
@property (nonatomic, assign) CGFloat startG;
@property (nonatomic, assign) CGFloat startB;
/// 完成颜色, 取值范围 0~1
@property (nonatomic, assign) CGFloat endR;
@property (nonatomic, assign) CGFloat endG;
@property (nonatomic, assign) CGFloat endB;


/// 渐变颜色视图下的背景色
/// 第一部分开始颜色
@property (nonatomic, assign) CGFloat firstStartR;
@property (nonatomic, assign) CGFloat firstStartG;
@property (nonatomic, assign) CGFloat firstStartB;

/// 第二部分开始颜色

@property (nonatomic, assign) CGFloat secondStartR;
@property (nonatomic, assign) CGFloat secondStartG;
@property (nonatomic, assign) CGFloat secondStartB;

/// 第一部分结束颜色
@property (nonatomic, assign) CGFloat firstEndR;
@property (nonatomic, assign) CGFloat firstEndG;
@property (nonatomic, assign) CGFloat firstEndB;

/// 第二部分结束颜色
@property (nonatomic, assign) CGFloat secondEndR;
@property (nonatomic, assign) CGFloat secondEndG;
@property (nonatomic, assign) CGFloat secondEndB;

/// 记录刚开始时的偏移量
@property (nonatomic, assign) NSInteger startOffsetX;
@property (nonatomic,strong) UIScrollView *yourScrollView;

//颜色数组 外面传进来的
@property (nonatomic,strong) NSArray *colorArray;
//需要变化的背景视图
@property (nonatomic,strong) UIView *needChangeView;
//渐变图层
@property (nonatomic,strong) CAGradientLayer *gradientLayer;

@end

@implementation WJColorChange

#pragma mark - PublicMethod

- (instancetype)initWithType:(ColorType)colorType {
    
    if (self = [super init]) {
        self.colorType = colorType;
    }
    return self;
}

- (void)settingScrollView:(UIScrollView*)scrollView colorArray:(NSArray<UIColor *>*)colorArray needChangeColorView:(UIView *)changeView{
    
    if (!scrollView) return;
    if (!colorArray) return;
    
    self.yourScrollView = scrollView;
    self.needChangeView = changeView;
    self.colorArray = colorArray;

    scrollView.delegate = self;
}

- (void)settingArrayScrollView:(UIScrollView*)scrollView colorArray:(NSArray<NSArray*>*)colorArray needChangeColorView:(UIView *)changeView {
    
    if (!scrollView) return;
    if (!colorArray) return;
    
    self.yourScrollView = scrollView;
    self.needChangeView = changeView;
    self.colorArray = colorArray;
    scrollView.delegate = self;
    
    NSArray *firstArray = colorArray.firstObject;
    //默认赋值
    [self settingGradientLayerWithStartColor:firstArray[0] endColor:firstArray[1] bgView:changeView];
}



#pragma mark - PrivateMethod
- (void)settingWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor {
    
    [self setupStartColor:startColor];
    [self setupEndColor:endColor];
}


- (void)settingTransverGradientWithFirstStartColor:(UIColor *)firstStartColor firstEndColor:(UIColor *)firstEndColor secondStartColor:(UIColor *)secondStartColor secondEndColor:(UIColor *)secondEndColor {
    
    [self setupFirstStartColor:firstStartColor];
    [self setupFirstEndColor:firstEndColor];
    
    [self setupSecondStartColor:secondStartColor];
    [self setupSecondEndColor:secondEndColor];
    
}


#pragma mark - - - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    _startOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    if ([self.delegate respondsToSelector:@selector(WJColorScrollViewScroll:)]) {
        
        [self.delegate WJColorScrollViewScroll:scrollView];
    }
    
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
    
    if (self.colorType == SingleColor) {
        [self settingWithStartColor:self.colorArray[originalIndex] endColor:self.colorArray[targetIndex]];
        [self changeBgViewGradientEffectWithProgress:progress bgView:self.needChangeView];
    }else {
        
        NSArray *originalArray = self.colorArray[originalIndex];
        NSArray *targetArray = self.colorArray[targetIndex];
        [self settingTransverGradientWithFirstStartColor:originalArray[0] firstEndColor:targetArray[0] secondStartColor:originalArray[1] secondEndColor:targetArray[1]];
        [self changeTransverseViewGradientEffectWithProgress:progress bgView:self.needChangeView];
    }

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if ([self.delegate respondsToSelector:@selector(WJColorEndScroll:)]) {
        [self.delegate WJColorEndScroll:scrollView];
    }
}

#pragma mark - - - 颜色渐变方法抽取
- (void)changeBgViewGradientEffectWithProgress:(CGFloat)progress bgView:(UIView *)bgView {

    CGFloat r = self.endR - self.startR;
    CGFloat g = self.endG - self.startG;
    CGFloat b = self.endB - self.startB;
    
    UIColor *changingColor = [UIColor colorWithRed:self.startR +  r * progress  green:self.startG +  g * progress  blue:self.startB +  b * progress alpha:1.0];
    bgView.backgroundColor = changingColor;
}

- (void)changeTransverseViewGradientEffectWithProgress:(CGFloat)progress bgView:(UIView *)bgView {
    
    CGFloat fr = self.firstEndR - self.firstStartR;
    CGFloat fg = self.firstEndG - self.firstStartG;
    CGFloat fb = self.firstEndB - self.firstStartB;

    CGFloat sr = self.secondEndR - self.secondStartR;
    CGFloat sg = self.secondEndG - self.secondStartG;
    CGFloat sb = self.secondEndB - self.secondStartB;
    
    UIColor *fChangingColor = [UIColor colorWithRed:self.firstStartR +  fr * progress  green:self.firstStartG +  fg * progress  blue:self.firstStartB +  fb * progress alpha:1.0];
    UIColor *sChangingColor = [UIColor colorWithRed:self.secondStartR +  sr * progress  green:self.secondStartG +  sg * progress  blue:self.secondStartB +  sb * progress alpha:1.0];
    
    [self settingGradientLayerWithStartColor:fChangingColor endColor:sChangingColor bgView:bgView];
}


/**
 设置图层的横向渐变

 @param startColor 开始色
 @param endColor 结束色
 @param bgView 背景视图
 */
- (void)settingGradientLayerWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor bgView:(UIView *)bgView{
    //横向渐变的路径
    self.gradientLayer.colors = @[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor];//这里颜色渐变
    self.gradientLayer.locations = @[@0.0, @1.0];//颜色位置
    self.gradientLayer.startPoint = CGPointMake(0, 0);
    self.gradientLayer.endPoint = CGPointMake(1.0, 0);
    self.gradientLayer.frame = bgView.bounds;
    [bgView.layer addSublayer:self.gradientLayer];
    [bgView.layer insertSublayer:self.gradientLayer atIndex:0];
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

- (void)setupFirstStartColor:(UIColor *)color {
    
    CGFloat components[3];
    [self getRGBComponents:components forColor:color];
    self.firstStartR = components[0];
    self.firstStartG = components[1];
    self.firstStartB = components[2];
}


- (void)setupFirstEndColor:(UIColor *)color {
    
    CGFloat components[3];
    [self getRGBComponents:components forColor:color];
    self.firstEndR = components[0];
    self.firstEndG = components[1];
    self.firstEndB = components[2];
}

- (void)setupSecondStartColor:(UIColor *)color {
    CGFloat components[3];
    [self getRGBComponents:components forColor:color];
    self.secondStartR = components[0];
    self.secondStartG = components[1];
    self.secondStartB = components[2];
    
}

- (void)setupSecondEndColor:(UIColor *)color {
    
    CGFloat components[3];
    [self getRGBComponents:components forColor:color];
    self.secondEndR = components[0];
    self.secondEndG = components[1];
    self.secondEndB = components[2];
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

#pragma mark -- set/get
- (CAGradientLayer *)gradientLayer {
    
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
    }
    return _gradientLayer;
}
@end

