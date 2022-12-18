import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:particle_album/particle/particle.dart';

///  Name: 粒子管理器
///  Created by Fitem on 2022/12/17
class ParticleManage extends ChangeNotifier {
  List<Particle> particleList = [];

  /// 设置粒子列表
  void setParticleList(List<Particle> list) {
    particleList = list;
  }

  /// 添加粒子
  void addParticle(Particle particle) {
    particleList.add(particle);
    notifyListeners();
  }

  void onUpdate() {
    for (Particle particle in particleList) {
      updateParticle(particle);
    }
    notifyListeners();
  }

  /// 更新粒子位置
  void updateParticle(Particle particle) {
    if (particle.cx < particle.x) {
      particle.cx = min(particle.x, particle.cx + 5);
    }
    if (particle.cy < particle.y) {
      particle.cy = min(particle.y, particle.cy + 5);
    }
  }

  void reset() {
    for (Particle particle in particleList) {
      // particle.cx = 0;
      particle.cy = 0;
    }
  }
}
