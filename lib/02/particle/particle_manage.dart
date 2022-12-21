import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:particle_album/02/particle/particle.dart';

///  Name: 粒子管理器
///  Created by Fitem on 2022/12/17
class ParticleManage extends ChangeNotifier {
  // 粒子集合
  List<Particle> particleList = [];

  // 是否完成运动
  bool isCompleted = false;

  // 粒子颗粒度
  double granularity = 200.0;

  // 粒子移动速度
  double speed = 5.0;

  // 粒子移动范围
  double range = 150.0;

  // 粒子动画类型
  Anim anim = Anim.particleMotion;

  Random random = Random();

  /// 初始化粒子
  void initParticles() {
    List<Particle> list = [];
    double size = 400 / granularity;
    for (int i = 0; i < granularity; i++) {
      for (int j = 0; j < granularity; j++) {
        double x = size * 0.5 + size * j;
        double y = size * 0.5 + size * i;
        list.add(Particle(
          x: x,
          y: y,
          cx: x - (random.nextDouble() * range - range ~/ 2),
          cy: y - (random.nextDouble() * range - range ~/ 2),
          size: size,
          ax: speed + random.nextDouble() * 10,
          ay: speed + random.nextDouble() * 10,
        ));
      }
    }
    setParticleList(list);
  }

  /// 设置粒子列表
  void setParticleList(List<Particle> list) {
    particleList = list;
    notifyListeners();
  }

  /// 添加粒子
  void addParticle(Particle particle) {
    particleList.add(particle);
    notifyListeners();
  }

  /// 更新粒子
  void onUpdate() {
    bool completed = true;
    for (Particle particle in particleList) {
      updateParticle(particle);
      completed = completed && isParticleCompleted(particle);
    }
    isCompleted = completed;
    notifyListeners();
  }

  /// 更新粒子位置
  void updateParticle(Particle particle) {
    if (particle.cx > particle.x) {
      particle.cx = max(particle.x, particle.cx - particle.ax);
    } else if (particle.cx < particle.x) {
      particle.cx = min(particle.x, particle.cx + particle.ax);
    }
    if (particle.cy > particle.y) {
      particle.cy = max(particle.y, particle.cy - particle.ay);
    } else if (particle.cy < particle.y) {
      particle.cy = min(particle.y, particle.cy + particle.ay);
    }
  }

  /// 重置粒子
  void reset() {
    for (Particle particle in particleList) {
      setParticleAnim(particle, anim);
    }
  }

  /// 设置粒子颗粒度
  void setGranularity(double granularity) {
    if (this.granularity == granularity) return;
    this.granularity = granularity;
    initParticles();
  }

  /// 设置粒子移动速度
  void setSpeed(double speed) {
    if (this.speed == speed) return;
    this.speed = speed;
    for (Particle particle in particleList) {
      particle.ax = speed + random.nextDouble() * 10;
      particle.ay = speed + random.nextDouble() * 10;
    }
  }

  /// 设置粒子离散距离
  void setRange(double range) {
    if (this.range == range) return;
    this.range = range;
    for (Particle particle in particleList) {
      particle.cx = particle.x - (random.nextDouble() * range - range ~/ 2);
      particle.cy = particle.y - (random.nextDouble() * range - range ~/ 2);
    }
  }

  /// 粒子是否已移动到指定位置
  bool isParticleCompleted(Particle particle) {
    return particle.cx == particle.x && particle.cy == particle.y;
  }

  /// 设置动画
  void setAnim(Anim anim) {
    this.anim = anim;
  }

  /// 设置粒子动画
  void setParticleAnim(Particle particle, Anim anim) {
    switch(anim) {
      case Anim.printer:
        particle.cx = particle.x ;
        particle.cy = particle.y - 400;
        particle.ax = speed;
        particle.ay = speed + 2;
        break;
      case Anim.particleMotion: // 粒子运动
        particle.cx = particle.x - (random.nextDouble() * range - range ~/ 2);
        particle.cy = particle.y - (random.nextDouble() * range - range ~/ 2);
        particle.ax = speed + random.nextDouble() * 10;
        particle.ay = speed + random.nextDouble() * 10;
        break;
      case Anim.origin:
        int index = granularity ~/ 2;
        particle.cx = index * particle.size - particle.size * 0.5;
        particle.cy = index * particle.size - particle.size * 0.5;
        particle.ax = speed;
        particle.ay = speed;
        break;
    }
  }
}

enum Anim {
  printer,
  particleMotion,
  origin,
}
