## 第三方
<br>
 TZImagePickerController   --  图片浏览器
<br>
https://github.com/banchichen/TZImagePickerController
<br>
LxGridViewFlowLayout   -- collectionView布局 文件
<br>
https://github.com/DeveloperLx/LxGridView
<br>
SDWebImage
<br>

## 主要功能
<br>
1.参考 TZImagePickerControllerDemo
<br>
2.抽取 选择图片页面有关代码，简单封装到 KXPublicPhotoView 视图
<br>
3.更改部分代码，使第一次 长按 手势后 ，才显示 删除按钮
<br>

## 更改过程中 失误点
<br>
1. UICollectionView 的reload刷新，要写到LxGridViewFlowLayout 内部
<br>
2.由于 LxGridViewFlowLayout  内部长按时，使用的是 对应cell 的 截图，
所以第一长按对应cell 无法显示 删除 按钮，需要 在对应位置 ，添加 一次 删除按钮
<br>
![展示]https://github.com/KongXiangX/KXPublicStatus/blob/master/展示.gif
