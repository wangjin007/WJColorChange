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
@interface ViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionView *showCollectionView;
/// 记录刚开始时的偏移量
@property (nonatomic, assign) NSInteger startOffsetX;

@property (nonatomic,strong) WJColorChange *colorChange;

@property (nonatomic,strong) NSMutableArray *colorDataArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self dataInit];
    
    [self createUI];
    
    /** 渐变色对象设置 确保 collectionView对象存在
    colorDataArr 存在并且数组里存放对象为 UIColor*/
    
    self.colorChange = [[WJColorChange alloc]init];
    [self.colorChange settingScrollView:self.showCollectionView colorArray:self.colorDataArr needChangeColorView:self.showCollectionView];
}


- (void)dataInit {
    
    NSArray *colorArr = @[[UIColor redColor],[UIColor purpleColor],[UIColor orangeColor],[UIColor yellowColor],[UIColor orangeColor],[UIColor purpleColor],[UIColor redColor]];
    
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
        _showCollectionView.backgroundColor =  self.colorDataArr.firstObject;
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
