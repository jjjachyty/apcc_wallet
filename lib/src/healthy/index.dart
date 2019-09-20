import 'package:flutter/material.dart';

class HealthyPage extends StatefulWidget {
  @override
  _HealthyPageState createState() => _HealthyPageState();
}

class _HealthyPageState extends State<HealthyPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 13);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
        body: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
             icon: Icon( Icons.arrow_back),
              color: Colors.blue,
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
          ),
          Container(
              height: MediaQuery.of(context).size.height*0.4,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      ListTile(
                        leading: Container(
                          width: 100,
                          child: Row(
                            children: <Widget>[
                              Image.asset(
                                  "assets/images/healthy/cardiology_red.png"),
                              Text(
                                "0.0",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        trailing: Container(
                            width: 100,
                            child: Row(
                              children: <Widget>[
                                Image.asset("assets/images/healthy/water.png"),
                                Text(
                                  "0.0",
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            )),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      ListTile(
                        leading: Container(
                            width: 100,
                            child: Row(
                              children: <Widget>[
                                Image.asset("assets/images/healthy/lungs.png"),
                                Text(
                                  "0.0",
                                  style: TextStyle(
                                      color: Colors.redAccent.shade100,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            )),
                        trailing: Container(
                            width: 100,
                            child: Row(
                              children: <Widget>[
                                Image.asset("assets/images/healthy/kidney.png"),
                                Text(
                                  "0.0",
                                  style: TextStyle(
                                      color: Colors.redAccent.shade100,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            )),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      ListTile(
                        leading: Container(
                            width: 100,
                            child: Row(
                              children: <Widget>[
                                Image.asset("assets/images/healthy/weight.png"),
                                Text(
                                  "0.0",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            )),
                        trailing: Container(
                            width: 100,
                            child: Row(
                              children: <Widget>[
                                Image.asset("assets/images/healthy/height.png"),
                                Text(
                                  "0.0",
                                  style: TextStyle(
                                      color: Colors.greenAccent,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            )),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Image.asset(
                        "assets/images/healthy/body.png",
                        height: 500,
                        width: 500,
                      ),
                    ),
                  ),
                ],
              )),
          TabBar(
            labelColor: Colors.blue.shade900,
            indicatorColor: Colors.blue,
            isScrollable: true,
            tabs: <Widget>[
              new Tab(
                text: "内科",
              ),
              new Tab(
                text: "外科",
              ),
              new Tab(
                text: "中医科",
              ),
              new Tab(
                 text: "五官科",
              ),
              new Tab(
                 text: "肿瘤科",
              ),
              new Tab(
                 text: "皮肤科",
              ),
              new Tab(
                 text: "感染科",
              ),
              new Tab(
                 text: "儿科/男科/妇产科",
              ),
              new Tab(
                 text: "精神心理科",
              ),
              new Tab(
                 text: "营养科",
              ),
              new Tab(
                 text: "麻醉医学科",
              ),
              new Tab(
                 text: "医学影像科",
              ),
              new Tab(
                 text: "其他科",
              ),
            ],
            controller: _tabController,
          ),
          Container(
          height: MediaQuery.of(context).size.height*0.4,
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
              Center(child: Text("未上传数据"),),
              Center(child: Text("未上传数据"),),
              Center(child: Text("未上传数据"),),
              Center(child: Text("未上传数据"),),
              Center(child: Text("未上传数据"),),
              Center(child: Text("未上传数据"),),
              Center(child: Text("未上传数据"),),
              Center(child: Text("未上传数据"),),
              Center(child: Text("未上传数据"),),
              Center(child: Text("未上传数据"),),
              Center(child: Text("未上传数据"),),
              Center(child: Text("未上传数据"),),
              Center(child: Text("未上传数据"),),
              
              ],
            ),
          )
        ],
      ),
    ));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
