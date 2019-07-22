import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("关于我们"),centerTitle: true,),
      body: Container(
        child: Text("""
        重庆亚鑫达健康产业有限公司是2018-06-20在重庆市九龙坡区注册成立的有限责任公司(自然人投资或控股)，注册地址位于重庆市九龙坡区科城路68号34-4号。

重庆亚鑫达健康产业有限公司的统一社会信用代码/注册号是91500107MA5YYKPD2N，企业法人黄梁.
        """),
      ) ,
    );
  }
}