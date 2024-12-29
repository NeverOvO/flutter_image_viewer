import 'package:flutter/material.dart';

import 'image_viewer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List imageUrl = [
    "https://img1.baidu.com/it/u=3840271671,3142495343&fm=253&fmt=auto&app=120&f=JPEG?w=879&h=500",
    "https://img1.baidu.com/it/u=1444694499,1134247140&fm=253&fmt=auto&app=120&f=JPEG?w=837&h=500",
    "https://img2.baidu.com/it/u=3422678176,163511578&fm=253&fmt=auto&app=120&f=JPEG?w=800&h=500",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: (){
              showDialog(
                context: context,
                barrierDismissible: false, // 禁止点击外部关闭对话框
                builder: (BuildContext context) {
                  return ImageViewer(imageList: imageUrl, initialPage: 0,);
                },
              );
              //使用Get弹窗
              // Get.dialog(
              //   ImageViewer(imageList: imageUrl, initialPage: 0,),
              //   useSafeArea: false,
              // );
            },
            child: Container(
              alignment: Alignment.center,
              child: Image(image: NetworkImage("https://img1.baidu.com/it/u=3840271671,3142495343&fm=253&fmt=auto&app=120&f=JPEG?w=879&h=500"),height: 200,width: 200,),
            ),
          ),
        ],
      ),
    );
  }
}
