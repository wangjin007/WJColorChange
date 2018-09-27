//
//  ViewController.m
//  ColorChange
//
//  Created by wangjin on 2018/8/30.
//  Copyright © 2018年 ELah. All rights reserved.
//

#import "ViewController.h"
#import "WJCell.h"
#import "WJColorChange.h"
#import "WJFlowLayout.h"

#define UIColorFromRGBAlpha(rgbValue,alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]
@interface ViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionView *showCollectionView;

@property (nonatomic,strong) WJColorChange *colorChange;

@property (nonatomic,strong) NSMutableArray *colorDataArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self dataInit];
    
    [self createUI];
    
//    /** 渐变色对象设置 确保 collectionView对象存在
//    colorDataArr 存在并且数组里存放对象为 UIColor*/
//
//    self.colorChange = [[WJColorChange alloc]initWithType:SingleColor];
//    [self.colorChange settingScrollView:self.showCollectionView colorArray:self.colorDataArr needChangeColorView:self.showCollectionView];
    
    self.colorChange = [[WJColorChange alloc]initWithType:TransverseGradientColor];
    [self.colorChange settingArrayScrollView:self.showCollectionView colorArray:self.colorDataArr needChangeColorView:self.view];
    
    
}


- (void)dataInit {
    
//    NSArray *colorArr = @[[UIColor redColor],[UIColor purpleColor],[UIColor orangeColor],[UIColor yellowColor],[UIColor orangeColor],[UIColor purpleColor],[UIColor redColor]];
//
//    [self.colorDataArr addObjectsFromArray:colorArr];
    
    
    NSArray *firstArray = @[UIColorFromRGBAlpha(0xB765DB, 1.0),UIColorFromRGBAlpha(0x655EE0, 1.0)];
    NSArray *secondArray = @[UIColorFromRGBAlpha(0xE871AC, 1.0),UIColorFromRGBAlpha(0xEE9666, 1.0)];
    NSArray *thirdArray = @[UIColorFromRGBAlpha(0x5FC1DE, 1.0),UIColorFromRGBAlpha(0x726AFF, 1.0)];
    NSArray *fourthArray = @[UIColorFromRGBAlpha(0x5BCED8, 1.0),UIColorFromRGBAlpha(0x009CD4, 1.0)];
    NSArray *fifthArray = @[UIColorFromRGBAlpha(0xEEB557, 1.0),UIColorFromRGBAlpha(0xEE9C57, 1.0)];

    NSArray *colorArr = @[firstArray,secondArray,fifthArray,fourthArray,thirdArray];
    
    [self.colorDataArr addObjectsFromArray:colorArr];
}


- (void)createUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.showCollectionView];
}


#pragma mark - set/get
- (UICollectionView *)showCollectionView {
    
    if (!_showCollectionView) {
        WJFlowLayout *layout = [[WJFlowLayout alloc]init];
        _showCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:layout];
        _showCollectionView.backgroundColor = [UIColor clearColor];
        _showCollectionView.delegate = self;
        _showCollectionView.dataSource = self;
        [_showCollectionView registerClass:[WJCell class] forCellWithReuseIdentifier:@"WJCell"];
        _showCollectionView.pagingEnabled = YES;
        _showCollectionView.showsHorizontalScrollIndicator = NO;
    }
    return _showCollectionView;
}

- (NSMutableArray *)colorDataArr {
    
    if (!_colorDataArr) {
        _colorDataArr = [[NSMutableArray alloc]init];
    }
    
    return _colorDataArr;
}


#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.colorDataArr.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WJCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WJCell" forIndexPath:indexPath];
    
    return cell;
}





@end
