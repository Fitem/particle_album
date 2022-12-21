import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:particle_album/02/particle/particle.dart';
import 'package:particle_album/02/particle/particle_manage.dart';
import 'package:image/image.dart' as image;

///  Name: 粒子详情页
///  Created by Fitem on 2022/12/20
class ParticleDetailPage extends StatefulWidget {
  const ParticleDetailPage({super.key});

  @override
  ParticleDetailPageState createState() => ParticleDetailPageState();
}

class ParticleDetailPageState extends State<ParticleDetailPage>
    with TickerProviderStateMixin {
  String url = "";
  final ParticleManage particleManage = ParticleManage();
  image.Image? imagePic;
  late Ticker _ticker;
  double speed = 0;
  double granularity = 0;
  double range = 0;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_updateTicker);
    initParticleManage();
  }

  @override
  void dispose() {
    _ticker.stop(canceled: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initData(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('粒子详情'),
        actions: [
          PopupMenuButton(
            // add icon, by default "3 dot" icon
            // icon: Icon(Icons.book)
            itemBuilder: (context) {
              return [
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text("打印动画"),
                ),
                const PopupMenuItem<int>(
                  value: 1,
                  child: Text("粒子运动动画"),
                ),
                const PopupMenuItem<int>(
                  value: 2,
                  child: Text("原点动画"),
                ),
                const PopupMenuItem<int>(
                  value: 3,
                  child: Text("打印机2动画"),
                ),
                const PopupMenuItem<int>(
                  value: 4,
                  child: Text("粒子运动2动画"),
                ),
              ];
            },
            onSelected: _onAnimChanged,
          )
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        GestureDetector(
          onTap: _onForward,
          child: CustomPaint(
            size: const Size(400, 400),
            painter: ParticlePainter(manage: particleManage),
          ),
        ),
        const Spacer(),
        _buildGranularity(),
        _buildSpeed(),
        _buildRange(),
        const Spacer(),
      ],
    );
  }

  /// 粒子颗粒度
  Widget _buildGranularity() {
    return Column(
      children: [
        Text("粒子颗粒度：$granularity"),
        Slider(
          value: granularity,
          min: 50,
          max: 400,
          activeColor: Colors.redAccent,
          divisions: 7,
          inactiveColor: Colors.green.withAlpha(99),
          onChanged: (value) => _onSliderChange(value, SliderType.granularity),
          onChangeEnd: (value) =>
              _onSliderChangeEnd(value, SliderType.granularity),
        )
      ],
    );
  }

  /// 速度控制
  Widget _buildSpeed() {
    return Column(
      children: [
        Text("粒子运动速度：$speed"),
        Slider(
          value: speed,
          min: 1.0,
          max: 10.0,
          activeColor: Colors.redAccent,
          divisions: 9,
          inactiveColor: Colors.green.withAlpha(99),
          onChanged: (value) => _onSliderChange(value, SliderType.speed),
          onChangeEnd: (value) => _onSliderChangeEnd(value, SliderType.speed),
        )
      ],
    );
  }

  /// 粒子离散范围
  Widget _buildRange() {
    return Column(
      children: [
        Text("粒子离散范围：$range"),
        Slider(
          value: range,
          min: 50.0,
          max: 300.0,
          activeColor: Colors.redAccent,
          divisions: 5,
          inactiveColor: Colors.green.withAlpha(99),
          onChanged: (value) => _onSliderChange(value, SliderType.range),
          onChangeEnd: (value) => _onSliderChangeEnd(value, SliderType.range),
        )
      ],
    );
  }

  /// 初始化数据，获取url
  void initData(BuildContext context) {
    var arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments is String) {
      url = arguments;
      initImage().then((value) => imageToParticle());
      debugPrint("url:$url");
    }
  }

  /// 初始化图片
  Future<void> initImage() async {
    ByteData data = await rootBundle.load(url);
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    imagePic = image.decodeImage(bytes)!;
  }

  /// 初始化粒子管理器
  void initParticleManage() {
    granularity = particleManage.granularity;
    speed = particleManage.speed;
    range = particleManage.range;
    // 初始化粒子
    particleManage.initParticles();
  }

  /// 图片转换粒子
  void imageToParticle() {
    if (imagePic == null) return;
    int granularity = particleManage.granularity.toInt();
    int width = imagePic!.width;
    int height = imagePic!.height;
    double aspect = width / height;
    int size = min(width, height);
    int left = aspect > 1 ? (width - height) ~/ 2 : 0;
    int top = aspect < 1 ? (height - width) ~/ 2 : 0;
    for (int i = 0; i < granularity; i++) {
      for (int j = 0; j < granularity; j++) {
        // image库获取的x、y和Flutter相反，需要把j做为x轴
        int x = left + j * size ~/ granularity;
        int y = top + i * size ~/ granularity;
        var pixel = imagePic!.getPixel(x, y);
        var color = Color(pixel);
        particleManage.particleList[i * granularity + j].color =
            Color.fromARGB(color.alpha, color.blue, color.green, color.red);
      }
    }
    _startTicket();
  }

  void _startTicket() {
    if (_ticker.isTicking) {
      _ticker.stop();
    }
    _ticker.start();
  }

  void _onForward() {
    if (_ticker.isTicking) {
      _ticker.stop();
    }
    particleManage.reset();
    _ticker.start();
  }

  void _updateTicker(Duration elapsed) {
    particleManage.onUpdate();
    // 获取粒子已完成运动，则停止ticker监听
    if (particleManage.isCompleted) {
      _ticker.stop();
    }
  }

  /// 更新滑动条进度
  void _onSliderChange(double value, SliderType type) {
    debugPrint("_onSliderChange: $type, $value");
    setState(() {
      switch (type) {
        case SliderType.granularity:
          granularity = value;
          break;
        case SliderType.speed:
          speed = value;
          break;
        case SliderType.range:
          range = value;
          break;
      }
    });
  }

  /// 粒子运动速度变化
  void _onSliderChangeEnd(double value, SliderType type) {
    switch (type) {
      case SliderType.granularity:
        particleManage.setGranularity(value);
        imageToParticle();
        break;
      case SliderType.speed:
        particleManage.setSpeed(value);
        _onForward();
        break;
      case SliderType.range:
        particleManage.setRange(value);
        _onForward();
        break;
    }
  }

  /// 粒子动画切换
  void _onAnimChanged(value) {
    switch (value) {
      case 0: // 打印机
        particleManage.setAnim(Anim.printer);
        _onForward();
        break;
      case 1: // 粒子运动
        particleManage.setAnim(Anim.particleMotion);
        _onForward();
        break;
      case 2: // 原点
        particleManage.setAnim(Anim.origin);
        _onForward();
        break;
      case 3: // 波浪
        particleManage.setAnim(Anim.printer2);
        _onForward();
        break;
      case 4: // 波浪
        particleManage.setAnim(Anim.particleMotion2);
        _onForward();
        break;
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
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) {
    return oldDelegate.manage != manage;
  }

  /// 绘制粒子
  void _drawParticle(Canvas canvas, Particle particle) {
    canvas.drawCircle(Offset(particle.cx, particle.cy), particle.size * 0.5,
        particlePaint..color = particle.color);
  }
}

enum SliderType {
  granularity,
  speed,
  range,
}
