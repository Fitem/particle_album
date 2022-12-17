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
 void addParticle(Particle particle){
   particleList.add(particle);
   notifyListeners();
 }

 void update(){
    notifyListeners();
 }
}
