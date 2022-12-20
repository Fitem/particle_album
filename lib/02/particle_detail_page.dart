import 'package:flutter/material.dart';

///  Name: 粒子详情页
///  Created by Fitem on 2022/12/20
class ParticleDetailPage extends StatefulWidget{
  const ParticleDetailPage({super.key});


  @override
  ParticleDetailPageState createState() => ParticleDetailPageState();
}

class ParticleDetailPageState extends State<ParticleDetailPage> {

  String url = "";

  void initData(BuildContext context) {
     var arguments = ModalRoute
        .of(context)
        ?.settings
        .arguments;
    if (arguments is String) {
      url = arguments;
    }
    debugPrint("url:$url");
  }

  @override
  Widget build(BuildContext context) {
    initData(context);
    return Container();
  }

}