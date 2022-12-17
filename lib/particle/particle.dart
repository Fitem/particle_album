import 'package:flutter/material.dart';

///  Name: 粒子
///  Created by Fitem on 2022/12/17
class Particle {
  Particle({
    this.x = 0,
    this.y = 0,
    this.size = 0,
    // this.color = Colors.red,
    this.color = Colors.white,
  });

  // x坐标
  double x;

  // y坐标
  double y;

  // 大小
  double size;

  // 颜色
  Color color;
}
