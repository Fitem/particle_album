import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:particle_album/02/particle_detail_page.dart';
import 'package:particle_album/02/particle_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // 确定初始化
  SystemChrome.setPreferredOrientations( // 使设备竖屏显示
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '粒子相册',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/",
      routes: {
        "/": (ctx) => const ParticlePage(),
        "/detail": (ctx) => const ParticleDetailPage(),
      },
    );
  }
}