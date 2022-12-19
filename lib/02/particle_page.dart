import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:particle_album/02/particle/particle.dart';
import 'package:particle_album/02/particle/particle_manage.dart';
import 'package:image/image.dart' as image;

///  Name: ParticlePage
///  Created by Fitem on 2022/12/17
class ParticlePage extends StatefulWidget {
  const ParticlePage({super.key});

  @override
  ParticlePageState createState() => ParticlePageState();
}

class ParticlePageState extends State<ParticlePage> with TickerProviderStateMixin {
  final ParticleManage particleManage = ParticleManage();
  image.Image? imagePic;
  // late AnimationController _controller;
  late Ticker _ticker;

  @override
  void initState() {
    super.initState();
    // _controller = AnimationController(duration: const Duration(seconds: 8), vsync: this);
    // _controller.addListener(() {
    //   particleManage.onUpdate();
    // });
    _ticker = createTicker(_updateTicker);
    initParticleManage();
    initImage();
  }

  @override
  void dispose() {
    // _controller.dispose();
    _ticker.stop(canceled: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('粒子相册'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        GestureDetector(
          onTap: _onTap,
          child: CustomPaint(
            size: const Size(400, 400),
            painter: ParticlePainter(manage: particleManage),
          ),
        ),
        const Spacer(),
        CarouselSlider(
          options: CarouselOptions(
            aspectRatio: 2.2,
            enlargeCenterPage: true,
            initialPage: 2,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 6),
            onPageChanged: _onPageChanged,
          ),
          items: imageSliders,
        )
      ],
    );
  }

  Future<void> initImage({int index = 0}) async {
    ByteData data = await rootBundle.load(imgList[index]);
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    imagePic = image.decodeImage(bytes)!;
    imageToParticle();
    if(_ticker.isTicking) {
      _ticker.stop();
    }
    _ticker.start();
  }

  void initParticleManage() {
    List<Particle> list = [];
    // _manage.addParticle(Particle(x: 200, y: 250, size: 25, color: Colors.red));
    double size = 1;
    var random = Random();
    for (int i = 0; i < 200; i++) {
      for (int j = 0; j < 200; j++) {
        double x = size + 2 * size * j;
        double y = size + 2 * size * i;
        list.add(Particle(
          x: x,
          y: y,
          cx: x - (random.nextDouble() * 200 - 100),
          cy: y - (random.nextDouble() * 200 - 100),
          size: size,
          ax: 2 + random.nextDouble() * 10,
          ay: 2 + random.nextDouble() * 10,
        ));
      }
    }
    particleManage.setParticleList(list);

    // 回形图形
    // toPaperClip();
    // 图片转换成粒子
    imageToParticle();
  }

  /// 回形图形
  void toPaperClip() {
    List<int> scales = [0, 1, 2, 3, 4];
    for (int i = 0; i < 50; i++) {
      for (int j = 0; j < 50; j++) {
        if (((i == 24 - scales[0] * 5 || i == 24 + scales[0] * 5) && j >= 24 - scales[0] * 5 && j <= 24 + scales[0] * 5) ||
            ((j == 24 - scales[0] * 5 || j == 24 + scales[0] * 5) && i >= 24 - scales[0] * 5 && i <= 24 + scales[0] * 5)) {
          particleManage.particleList[i * 50 + j].color = Colors.blue;
        }
        if (((i == 24 - scales[1] * 5 || i == 24 + scales[1] * 5) && j >= 24 - scales[1] * 5 && j <= 24 + scales[1] * 5) ||
            ((j == 24 - scales[1] * 5 || j == 24 + scales[1] * 5) && i >= 24 - scales[1] * 5 && i <= 24 + scales[1] * 5)) {
          particleManage.particleList[i * 50 + j].color = Colors.blue;
        }
        if (((i == 24 - scales[2] * 5 || i == 24 + scales[2] * 5) && j >= 24 - scales[2] * 5 && j <= 24 + scales[2] * 5) ||
            ((j == 24 - scales[2] * 5 || j == 24 + scales[2] * 5) && i >= 24 - scales[2] * 5 && i <= 24 + scales[2] * 5)) {
          particleManage.particleList[i * 50 + j].color = Colors.blue;
        }
        if (((i == 24 - scales[3] * 5 || i == 24 + scales[3] * 5) && j >= 24 - scales[3] * 5 && j <= 24 + scales[3] * 5) ||
            ((j == 24 - scales[3] * 5 || j == 24 + scales[3] * 5) && i >= 24 - scales[3] * 5 && i <= 24 + scales[3] * 5)) {
          particleManage.particleList[i * 50 + j].color = Colors.blue;
        }
        if (((i == 24 - scales[4] * 5 || i == 24 + scales[4] * 5) && j >= 24 - scales[4] * 5 && j <= 24 + scales[4] * 5) ||
            ((j == 24 - scales[4] * 5 || j == 24 + scales[4] * 5) && i >= 24 - scales[4] * 5 && i <= 24 + scales[4] * 5)) {
          particleManage.particleList[i * 50 + j].color = Colors.blue;
        }
      }
    }
  }

  /// 图片转换粒子
  void imageToParticle(){
    if(imagePic == null) return;
    int width = imagePic!.width;
    int height = imagePic!.height;
    double aspect =  width / height;
    int size = min(width, height);
    int left = aspect > 1 ? (width - height) ~/ 2 : 0;
    int top = aspect < 1 ? (height - width) ~/ 2 : 0;
    for(int i = 0; i < 200; i++) {
      for(int j = 0; j < 200; j++) {
        // image库获取的x、y和Flutter相反，需要把j做为x轴
        int x = left + j * size ~/ 200;
        int y = top + i * size ~/ 200;
        var pixel = imagePic!.getPixel(x, y);
        var color = Color(pixel);
        particleManage.particleList[i * 200 + j].color = Color.fromARGB(color.alpha, color.blue, color.green, color.red);
      }
    }
  }

  void _onTap() {
    if(!_ticker.isTicking) {
      particleManage.reset();
      _ticker.start();
    }
  }

  void _updateTicker(Duration elapsed) {
    particleManage.onUpdate();
    // 获取粒子已完成运动，则停止ticker监听
    if(particleManage.isCompleted) {
      _ticker.stop();
    }
  }

  void _onPageChanged(int index, CarouselPageChangedReason reason) {
    debugPrint("index=$index, ${reason.toString()}");
    particleManage.reset();
    initImage(index: index);
  }
}

class ParticlePainter extends CustomPainter {
  ParticlePainter({required this.manage}) : super(repaint: manage);

  final ParticleManage manage;
  final Paint particlePaint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    for (Particle particle in manage.particleList) {
      _drawParticle(canvas, particle);
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) {
    return oldDelegate.manage != manage;
  }

  /// 绘制粒子
  void _drawParticle(Canvas canvas, Particle particle) {
    canvas.drawCircle(Offset(particle.cx, particle.cy), particle.size,
        particlePaint..color = particle.color);
  }
}

final List<String> imgList = [
  "assets/images/image01.jpg",
  "assets/images/image02.jpg",
  "assets/images/image03.jpg",
  "assets/images/image04.jpg",
  "assets/images/image05.jpg",
  "assets/images/image06.jpg",
  "assets/images/image07.jpg",
  "assets/images/image08.jpg",
];

final List<Widget> imageSliders = imgList
    .map((item) => Container(
      margin: const EdgeInsets.all(5.0),
      child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          child: Stack(
            children: <Widget>[
              Image.asset(item, fit: BoxFit.cover, width: 1000.0),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(200, 0, 0, 0),
                        Color.fromARGB(0, 0, 0, 0)
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  child: Text(
                    'No. ${imgList.indexOf(item)} image',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          )),
    )).toList();