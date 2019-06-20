import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        // appBar: AppBar(
        //   title: Text("登录"),
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        // ),
        body: Column(
          children: <Widget>[
            new Stack(children: <Widget>[
              Image.network(
                "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1561258674&di=3f890ec18f85e5c686951197f9d206ec&imgtype=jpg&er=1&src=http%3A%2F%2Fwww.gmqgroup.com%2Fdata%2Fupload%2Fueditor%2F20180412%2F5acf19258e7f9.jpg",
                height: 200,
                fit: BoxFit.cover,
              ),
              Positioned(
                width: MediaQuery.of(context).size.width,
                child: AppBar(
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: Text(
                    "登录",
                  ),
                ),

                // backgroundColor: Colors.transparent,
              ),
            ]),
            Form(
              key: _loginForm,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                 
                  children: <Widget>[
                     
                    TextFormField(
                      controller: _phoneCtr,
                      keyboardType: TextInputType.phone,
                      maxLength: 11,
                      validator: (phone) {
                        if (!phoneExp.hasMatch(phone)) {
                          return "手机号码不正确";
                        }
                      },
                      decoration: InputDecoration(
                          labelText: "手机号",
                          contentPadding: EdgeInsets.zero,
                          counterText: "",
                          // hintText: "手机号",
                          prefixIcon: Icon(
                            Icons.phone_iphone,
                            color: Colors.green,
                          ),
                          border: OutlineInputBorder()),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: <Widget>[
                    //     Container(
                    //         width: MediaQuery.of(context).size.width * 0.66,
                    //         child: TextFormField(
                    //           keyboardType: TextInputType.number,
                    //           maxLength: 4,
                    //           validator: (sms) {
                    //             if (sms == null || sms.length != 4) {
                    //               return "请输入正确的验证码";
                    //             }
                    //           },
                    //           decoration: InputDecoration(
                    //               contentPadding:
                    //                   EdgeInsets.symmetric(vertical: 15.0),
                    //               labelText: "验证码",
                    //               hintText: "验证码",
                    //               counterText: "",
                    //               prefixIcon: Icon(
                    //                 Icons.sms,
                    //                 color: Colors.green,
                    //               ),
                    //               border: OutlineInputBorder()),
                    //         )),
                    //     FlatButton(
                    //       padding: EdgeInsets.zero,
                    //       child: Text(
                    //         _leftCount == 0 ? "发送验证码" : _leftCount.toString(),
                    //         style: TextStyle(color: Colors.green),
                    //       ),
                    //       onPressed: _leftCount == 0
                    //           ? () {
                    //               if (phoneExp.hasMatch(_phoneCtr.text)){
                    //                 setState(() {
                    //                 _leftCount = 60;
                    //               });
                    //               //验证
                    //               _countdonwn =
                    //                   countDown(_leftCount, (int count) {
                    //                 setState(() {
                    //                   _leftCount = count;
                    //                 });
                    //               });
                    //               }else{
                                    
                    //               }
                                  
                    //             }
                    //           : null,
                    //     )
                    //   ],
                    // ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      obscureText: true,
                      maxLength: 16,
                      validator: (val) {
                        if (val.length < 6) {
                          return "密码为6-16位";
                        }
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          labelText: "密码",
                          hintText: "密码",
                          counterText: "",
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.green,
                          ),
                          border: OutlineInputBorder()),
                    ),
                    SizedBox(
                      height: 30,
                      width: double.infinity,
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                           _logType = !_logType; 
                          });
                        },
                        child:_logType ?Text("使用短信验证码登录",style:TextStyle(fontSize: 12,color: Colors.blue),textAlign: TextAlign.left,): ,
                      )
                      
                    ),
                    new StoreConnector<AppState, Store<AppState>>(
                        converter: (store) => store,
                        builder: (context, store) {
                          return new ProgressButton(
                            color: Colors.green,
                            defaultWidget: Text(
                              "登录",
                              style: TextStyle(color: Colors.white),
                            ),
                            progressWidget: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.lightGreen)),
                            onPressed: () async {
                              var _formState = _loginForm.currentState;
                              if (_formState.validate()) {
                                _formState.save();

                                // int score = await Future.delayed(
                                //     const Duration(milliseconds: 3000), () {
                                //   print("object close");
                                // });
                                // // // // After [onPressed], it will trigger animation running backwards, from end to beginning

                                // return () async {
                                var user = await login(
                                    User(
                                        phone: "15520010009",
                                        passWord: "12121212",
                                        nickName: "0009",
                                        avatar:
                                            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1560704834807&di=ce70fc5cd9a615af0f266b3004bdb0d0&imgtype=0&src=http%3A%2F%2Fimg3.duitang.com%2Fuploads%2Fitem%2F201605%2F07%2F20160507191419_J2m8R.thumb.700_0.jpeg"),
                                    "1245");
                                // // Optional returns is returning a VoidCallback that will be called
                                // // after the animation is stopped at the beginning.
                                // // A best practice would be to do time-consuming task in [onPressed],
                                // // and do page navigation in the returned VoidCallback.
                                // // So that user won't missed out the reverse animation.
                                print("user");
                                if (user.nickName != "") {
                                  store.dispatch(RefreshUserAction(user));
                                  Navigator.of(context).pop(user);
                                  // Navigator.of(context).pushAndRemoveUntil(
                                  //     MaterialPageRoute(builder: (context) {
                                  //   return MainPage();
                                  // }), (router) => false);
                                }
                              }
                              ;
                              // }
                            },
                          );
                        }),
                    SizedBox(
                      height: 10,
                    ),
                    new Text.rich(
                      new TextSpan(
                          text: '点击发送按钮代表已同意 ',
                          style: new TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w400),
                          children: [
                            new TextSpan(
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () {
                                    print("xxx");
                                  },
                                text: '用户协议',
                                style: new TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w400,
                                )),
                            new TextSpan(
                                text: ' 和 ',
                                style: new TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w400,
                                )),
                            new TextSpan(
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () {
                                    print("object");
                                  },
                                text: '隐私政策',
                                style: new TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w400,
                                )),
                          ]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}