import 'package:flutter/material.dart';

class ImageViewer extends StatefulWidget {
  final List imageList;
  final int initialPage;

  // 构造函数中提供默认值
  const ImageViewer({super.key, required this.imageList,this.initialPage = 0,});

  @override
  State<ImageViewer> createState() => ImageSwiperState();
}

class ImageSwiperState extends State<ImageViewer> {
  late PageController _pageController;
  bool _isParentScrollable = true;
  bool _singleImageMode = true;//单图模式判断避免非必要滑动

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialPage);
    if(widget.imageList.length == 1){
      _singleImageMode = true;
    }else{
      _singleImageMode = false;
    }
  }

  //保存图片示例代码
  // dio: ^5.7.0
  // image_gallery_saver: ^2.0.3
  // permission_handler: ^11.3.1

  // Future<void> saveImage(String imageUrl) async {
  //   bool hasPermission = await requestPermission();
  //   if (!hasPermission) {
  //     print("没有存储权限");
  //     return;
  //   }
  //
  //   await saveImageToGallery(imageUrl);
  // }
  //
  // Future<bool> requestPermission() async {
  //   var status = await Permission.photos.request();
  //   return status.isGranted;
  // }

  // Future<void> saveImageToGallery(String url) async {
  //   try {
  //     var response = await Dio().get(url,options: Options(responseType: ResponseType.bytes));
  //     var result = await ImageGallerySaver.saveImage(Uint8List.fromList(response.data),);
  //     // result != '' ? '保存成功' : '保存失败'
  //   } catch (e) {
  //     print("保存图片时出错: $e");
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Listener(
        onPointerDown: (_) {
          _isParentScrollable = true;
        },
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              physics: (_isParentScrollable && !_singleImageMode) ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
              itemCount: widget.imageList.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    NeverImageView(
                      imageUrl:widget.imageList[index],
                      onBoundaryReached: (bool isAtBoundary) {
                        setState(() {
                          _isParentScrollable = isAtBoundary;
                        });
                      },
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 30),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () async{
                                  //私聊时首次点击相册权限
                                  // saveImageToGallery(widget.imageList[index]);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                  padding: EdgeInsets.all(8),
                                  child: Icon(Icons.save_alt,color: Colors.white.withValues(alpha: 0.8),size: 20,),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class NeverImageView extends StatefulWidget {
  final String imageUrl;
  final ValueChanged<bool> onBoundaryReached;

  const NeverImageView({super.key, required this.imageUrl, required this.onBoundaryReached});

  @override
  NeverImageViewState createState() => NeverImageViewState();
}

class NeverImageViewState extends State<NeverImageView> with SingleTickerProviderStateMixin{
  double _scale = 1.0; // 当前缩放比例
  double _previousScale = 1.0; // 上一次缩放比例
  Offset _currentOffset = Offset.zero; // 当前拖动坐标
  double screenWidth = 0;//屏幕宽度
  double screenHeight = 0;//屏幕的高度
  double _transparency = 1;//滑动时背景的偏移量改变背景透明度
  bool _slideToClose = false;//滑动关闭标识位
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: (){
        Navigator.of(context).pop(); // 单击关闭
      },
      onScaleStart: (details) {
        widget.onBoundaryReached(false);
        _previousScale = _scale;
        _transparency = 1;
      },
      onScaleUpdate: (details) {
        setState(() {
          // 更新缩放比例
          _scale = _previousScale * details.scale;
          //限制放大比例，可自行修改
          if(_scale >= 3){
            _scale = 3;
          }

          //起始偏移量 增加当次偏移量，可以保证图片从手机按动的位置开始移动
          double dx = _currentOffset.dx + details.focalPointDelta.dx  * (1/_scale);
          double dy = _currentOffset.dy + details.focalPointDelta.dy * (1/_scale);

          if(_scale <= 1){
            //图片放大比例不足1时，可以监听进行图片的拖动关闭
            _transparency -= details.focalPointDelta.dy.abs() / 100;
            if(_transparency < 0.25){
              _transparency = 0.25;
            }

            //下拉上滑关闭图片
            //采用绝对值可以对上滑、下拉操作都进行关闭判断
            if(dy.abs() > screenHeight / 10) {//上拉下滑超过屏幕高度的1/10即可判定为需要关闭，阈值可以自行调整
              _slideToClose = true;
            }else{
              _slideToClose = false;
            }
          }else{
            //控制放大后图片的X边界
            if(dx > screenWidth * (_scale / 10 + 0.1)){
              dx = screenWidth *  (_scale / 10 + 0.1);
            }else if(-dx > screenWidth * (_scale / 10 + 0.1)){
              dx = -screenWidth * (_scale / 10 + 0.1);
            }
            //控制放大后图片的Y边界
            if(dy > screenHeight * (_scale / 20)){
              dy = screenHeight *  (_scale / 20);
            }else if(-dy > screenHeight * (_scale / 20)){
              dy = -screenHeight * (_scale / 20);
            }
          }

          // 更新偏移量
          _currentOffset = Offset(dx, dy);
        });
      },
      onScaleEnd: (details) {
        if(_slideToClose){
          _transparency = 0;
          Navigator.of(context).pop(); // 拖拽关闭
        }else{
          _transparency = 1;
        }

        if(_scale <= 1){
          widget.onBoundaryReached(true);
          _scale = 1;
          //如果图片放大比例不足1，变回1并回到原点，因为图片永远时根据屏幕的宽进行适配的
          _animateBackToInitialPosition(0,0);
        }else{
          //图片放大后不作回到原点处理,有需要也可以自行进行添加功能
        }
      },
      onDoubleTap: () {
        setState(() {
          if (_scale > 1.0) {
            widget.onBoundaryReached(true);
            _scale = 1.0; // 双击还原
            _currentOffset = Offset.zero; // 双击时重置偏移到初始位置
          }else{
            widget.onBoundaryReached(false);
            _scale = 2.0; // 双击放大
            _currentOffset = Offset.zero; // 双击时重置偏移到初始位置
          }
        });
      },
      child:ClipRect(
        child: Container(
          color: Colors.black.withValues(alpha: _transparency),
          height: screenHeight,
          width: screenWidth,
          alignment: Alignment.center,
          child: Transform(
            origin: Offset(screenWidth / 2, screenHeight / 2),
            transform: Matrix4.identity()
              ..scale(_scale)
              ..translate(_currentOffset.dx, _currentOffset.dy),
            //采用Image组件呈现图片
            child: Image(image: NetworkImage( widget.imageUrl,),width: screenWidth,height: screenHeight,),
            //采用CachedNetworkImage组件呈现图片
            // child:CachedNetworkImage(
            //   imageUrl: widget.imageUrl,
            //   imageBuilder: (context, imageProvider) => Container(
            //     decoration: BoxDecoration(
            //       image: DecorationImage(image: imageProvider, fit: BoxFit.contain,),
            //     ),
            //   ),//防止重新加载
            //   fit: BoxFit.contain,
            //   placeholder: (context, url) => const SizedBox(),
            //   errorWidget: (context, url, error) => Container(),
            // ),
          ),
        ),
      ),
    );
  }

  // 执行平滑回到初始位置的动画
  void _animateBackToInitialPosition(double dx,double dy) {
    final tween = Tween<Offset>(
      begin: _currentOffset,
      end: Offset(dx,dy),
    ).chain(CurveTween(curve: Curves.easeInOut));

    _animation = tween.animate(_animationController);

    _animationController.reset();
    _animationController.forward();
    _animation.addListener(() {
      setState(() {
        _currentOffset = _animation.value;
      });
    });
  }
}

