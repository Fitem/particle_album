import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:particle_album/01/particle/particle.dart';

///  Name: 粒子管理器
///  Created by Fitem on 2022/12/17
class ParticleManage extends ChangeNotifier {
  List<Particle> particleList = [];
  bool isCompleted = false;

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
    var random = Random();
    for (Particle particle in particleList) {
      particle.cx = particle.x - (random.nextDouble() * 200 - 100);
      particle.cy = particle.y - (random.nextDouble() * 200 - 100);
    }
  }

  /// 粒子是否已移动到指定位置
  bool isParticleCompleted(Particle particle) {
    return particle.cx == particle.x && particle.cy == particle.y;
  }
}
