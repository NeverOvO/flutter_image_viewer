# flutter_image_viewer

Flutter基础代码实现的仿手机QQ图片放大查看器组件

## 主要功能

- 图片放大查看
- 图片上下拖动关闭
- 多图片数组滑动翻页查看
- 随意添加相关功能，例如下载图片、分享图片等

## 使用方法

```
showDialog(
  context: context,
  barrierDismissible: false,
  builder: (BuildContext context) {
    return ImageViewer(imageList: imageUrl, initialPage: 0,);
  },
);
```
使用Get弹窗
```
Get.dialog(
  ImageViewer(imageList: imageUrl, initialPage: 0,),
  useSafeArea: false,
);
```

## 视频演示

单图查看演示

https://github.com/user-attachments/assets/f459fb4a-cd8c-4d33-81d4-c892137b0b87

多图查看演示

https://github.com/user-attachments/assets/c8b935aa-b090-4454-973a-75eca907e983

## 功能提醒

- 在放大倍数为1时，才可以进行随意拖动关闭，滑动到下一个图片查看
- 放大后只能滑动查看图片，且无法切换到下一个图片
- 双击图片可以进行放大或者还原图片倍数
- 单击可以关闭图片

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
