import 'package:flutter/material.dart';

///  Name: 粒子
///  Created by Fitem on 2022/12/17
class Particle {
  Particle({
    this.x = 0,
    this.y = 0,
    this.size = 0,
    this.color = Colors.white,
    this.cx = 0,
    this.cy = 0,
    this.ax = 0,
    this.ay = 0,
  });

  // x坐标
  double x;

  // y坐标
  double y;

  // 大小
  double size;

  // 颜色
  Color color;

  // 当前x坐标
  double cx;

  // 当前x坐标
  double cy;

  // 加速度ax
  double ax;

  // 加速度 ay
  double ay;
}
