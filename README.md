# WJColorChange
## 滑动颜色渐变

### 效果1 背景单色渐变
![image](https://github.com/wangjin007/WJColorChange/blob/master/changeColor.gif)
### 效果2 背景横向渐变色渐变
![image](https://github.com/wangjin007/WJColorChange/blob/master/colorChange2.gif)

### 描述

这是一个简单易用的支持左右滑动修改视图颜色的工具类  
只需导入头文件，一行代码就可搞定。

### 用法 
    - (void)viewDidLoad {
    [super viewDidLoad];
    
    [self dataInit];
    
    [self createUI];
    
    //两种初始化方式 根据类型
    //1.
    /** 渐变色对象设置 确保 collectionView对象存在
    colorDataArr 存在并且数组里存放对象为 UIColor*/
    self.colorChange = [[WJColorChange alloc]initWithType:SingleColor];
    [self.colorChange settingScrollView:self.showCollectionView colorArray:self.colorDataArr needChangeColorView:self.showCollectionView];
    
    //2.
    /** 渐变色对象设置 
    colorDataArr 存的数组里放的是 颜色数组对象 颜色数组里存放对象为 UIColor*/
    self.colorChange = [[WJColorChange alloc]initWithType:TransverseGradientColor];
    [self.colorChange settingArrayScrollView:self.showCollectionView colorArray:self.colorDataArr needChangeColorView:self.view];
    
    
    }
    - (void)dataInit {
    
    //背景单颜色 数据初始化 范例
     NSArray *colorArr = @[[UIColor redColor],[UIColor purpleColor],[UIColor orangeColor],[UIColor yellowColor],[UIColor orangeColor],[UIColor purpleColor],[UIColor redColor]];
     [self.colorDataArr addObjectsFromArray:colorArr];
    
    //背景渐变色 数据初始化 范例
    NSArray *firstArray = @[UIColorFromRGBAlpha(0xB765DB, 1.0),UIColorFromRGBAlpha(0x655EE0, 1.0)];
    NSArray *secondArray = @[UIColorFromRGBAlpha(0xE871AC, 1.0),UIColorFromRGBAlpha(0xEE9666, 1.0)];
    NSArray *thirdArray = @[UIColorFromRGBAlpha(0x5FC1DE, 1.0),UIColorFromRGBAlpha(0x726AFF, 1.0)];
    NSArray *fourthArray = @[UIColorFromRGBAlpha(0x5BCED8, 1.0),UIColorFromRGBAlpha(0x009CD4, 1.0)];
    NSArray *fifthArray = @[UIColorFromRGBAlpha(0xEEB557, 1.0),UIColorFromRGBAlpha(0xEE9C57, 1.0)];

    NSArray *colorArr = @[firstArray,secondArray,fifthArray,fourthArray,thirdArray];
    
    [self.colorDataArr addObjectsFromArray:colorArr];
}
    

### 支持Cocoapods 
pod 'WJColorChange'
