# WJColorChange
## 滑动颜色渐变

### 效果

![image](https://github.com/wangjin007/WJColorChange/blob/master/changeColor.gif)

### 描述

这是一个简单易用的支持左右滑动修改视图颜色的工具类  
只需导入头文件，一行代码就可搞定。

### 用法
    - (void)viewDidLoad {
        [super viewDidLoad];
        
    /** 渐变色对象设置 确保 collectionView对象存在
    colorDataArr 存在并且数组里存放对象为 UIColor*/
    
     self.colorChange = [[WJColorChange alloc]init];
     [self.colorChange settingScrollView:self.showCollectionView colorArray:self.colorDataArr     needChangeColorView:self.showCollectionView];
}

### 支持Cocoapods 
pod 'WJColorChange'
