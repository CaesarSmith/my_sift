# my_sift
scale invariant feature transform based on opensift

### SIFT
 Scale invariant feature transform(SIFT)是由Lowe提出来的一种特征匹配算法, 已经被广泛应用于目标识别、图像匹配等各个方面:
 Lowe, D. Distinctive image features from scale-invariant keypoints. International Journal of Computer Vision, 60, 2 (2004), pp.91--110.
 
### 说明
 SIFT算法的源代码已经在opencv中提供，但由于受专利保护，无法查看和修改源代码，本项目基于[opensift](https://github.com/robwhess/opensift)修改而来, 由于opensifit依赖opencv2.3和GTK，环境配置比较复杂，且opencv2.3过于老旧，本地编译经常出错，因此本项目将opensift代码移植到opencv4.5环境中，并去掉了对GTK绘图工具箱的依赖。
 C代码的改动主要如下：
+ 将老旧的IPLImage结构体替换为cv::Mat类型
+ 将一些旧版函数替换为新版函数，启用了更为方便的表达
+ 其他数据结构的替换

目前C版本的代码移植完成了特征点提取和最近邻搜索的匹配过程，但RANSAC算法的运行过程还没有完全调通，基于opencv4.5, 本项目代码可直接在visual studio中运行，也可借助mingw编译独立运行

Matlab代码完全依照C代码，程序框架与C代码一致，运行结果与C稍微有点差异，这是因为在滤波、采样、内插的实现方式上matlab和opencv有差异，从而导致特征点检测上有些许数量差异(场景图用opencv跑出来特征点为1047个，matlab跑出来为1046个)，但特征向量等经核对两者完全一致。

下图分别显示了opencv的匹配结果和matlab的匹配结果
###### opencv4.5
![img](https://github.com/CaesarSmith/images/blob/master/sift_on_opencv.png)
###### matlab
![img](https://github.com/CaesarSmith/images/blob/master/sift_on_matlab.png)
###### 匹配结果如下
![img](https://github.com/CaesarSmith/images/blob/master/SFIT_registration.gif)


