import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:particle_album/particle/particle.dart';
import 'package:particle_album/particle/particle_manage.dart';
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
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 6), vsync: this);
    _controller.addListener(() {
      particleManage.onUpdate();
    });
    initParticleManage();
    initImage();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> initImage() async {
    ByteData data = await rootBundle.load("assets/images/hanzi.png");
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    imagePic = image.decodeImage(bytes)!;
    imageToParticle();
    // particleManage.onUpdate();
    _controller.forward();
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
    return GestureDetector(
      onTap: _onTap,
      child: CustomPaint(
        size: const Size(200, 200),
        painter: ParticlePainter(manage: particleManage),
      ),
    );
  }

  void initParticleManage() {
    particleManage.particleList.clear();
    // _manage.addParticle(Particle(x: 200, y: 250, size: 25, color: Colors.red));
    double size = 1;
    for (int i = 0; i < 200; i++) {
      for (int j = 0; j < 200; j++) {
        particleManage.addParticle(Particle(
          x: size + 2 * size * j,
          y: size + 2 * size * i,
          size: size,
        ));
      }
    }

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
    for(int i = 0; i < 200; i++) {
      for(int j = 0; j < 200; j++) {
        // image库获取的x、y和Flutter相反，需要把j做为x轴
        int x = width * j ~/ 200;
        int y = height * i ~/ 200;
        var pixel = imagePic!.getPixel(x, y);
        if(pixel != Colors.white.value) {
          particleManage.particleList[i * 200 + j].color = Colors.blue;
        }
      }
    }
  }

  void _onTap() {
    if(_controller.isCompleted) {
      particleManage.reset();
      _controller.reset();
      _controller.forward();
    }
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
    var particle = manage.particleList.last;
    debugPrint("${particle.cx},${particle.cy}");
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
