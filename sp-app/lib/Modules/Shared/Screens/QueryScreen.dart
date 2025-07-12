import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:just_audio/just_audio.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';

import 'package:sp_app/constant.dart';

class QueryScreen extends StatefulWidget {
  const QueryScreen({Key? key}) : super(key: key);

  @override
  _QueryScreenState createState() => _QueryScreenState();
}

class _QueryScreenState extends State<QueryScreen> {
  final database =
      FirebaseDatabase.instance.reference().child('-MkNvx3kYY_Y8ZocKm4C');
  AudioPlayer player = AudioPlayer();
  final _controller = ScrollController();
  final _controller_1 = ScrollController();
  FocusNode fo = FocusNode();
  FocusNode fo_1 = FocusNode();
  String ques = '';
  String user = '';
  String sub = '';
  String search = '';
  String date_1 = '';
  int searchindex = 9999;
  bool subjectchoosen = false;
  bool issearch = false;
  void initstate() {
    super.initState();
    player = AudioPlayer();
    setState(() {});
  }

  List<String> subjectList = [
    'OS',
    'C',
    'OOPS',
    'DAA',
    'SE',
    'TOC',
    'DS',
    'CD',
  ];

  @override
  void initState() {
    super.initState();
    message();
    date();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  String formattedDate = '';
  void date() {
    var now = new DateTime.now();
    var formatter = new DateFormat('dd/MM');
    formattedDate = formatter.format(now);
  }

  Future<bool> onbackpress() async {
    print('aa');
    FocusScope.of(context).unfocus();
    // text = true;
    print('aa');
    // setState(() {});
    return Future.value(true);
  }

  bool refresh = false;
  bool post = false;
  final fieldText = TextEditingController();
  final fieldText_1 = TextEditingController();

  Widget messageContainer() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    return Container(
      margin: EdgeInsets.only(
          top: (issearch) ? MediaQuery.of(context).size.height * 0.1 : 10,
          bottom: 10),
      height: (currentFocus.hasFocus && text)
          ? MediaQuery.of(context).size.height * 0.6
          : MediaQuery.of(context).size.height * 0.87,
      width: MediaQuery.of(context).size.width * 0.98,
      // color: Colors.indigo,
      child: AnimationLimiter(
        child: (msg1.length == 0)
            ? Container(
                height: MediaQuery.of(context).size.height * 1,
                width: MediaQuery.of(context).size.width * 1,
                color: Colors.white,
                child: Center(
                  child: Container(
                    color: Color(0xff6E7FFC),
                    height: 130,
                    width: 130,
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        (refresh)
                            ? Stack()
                            : (post)
                                ? Container(
                                    height: 40,
                                    width: 40,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                        Icons.done,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ),
                                  )
                                : Container(),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          (post) ? 'Posted' : 'Loading',
                          style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height * 0.025,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        (post)
                            ? Container()
                            : Container(
                                height: 40,
                                width: 40,
                                child: LoadingIndicator(
                                    indicatorType: Indicator.ballPulseSync,
                                    colors: const [Colors.white],
                                    strokeWidth: 0,
                                    backgroundColor: Colors.transparent,
                                    pathBackgroundColor: Colors.black),
                              ),
                      ],
                    ),
                  ),
                ),
              )
            : Container(
                margin: EdgeInsets.only(bottom: 50),
                child: ListView.builder(
                  controller: _controller,
                  itemCount: que1.length,
                  itemBuilder: (BuildContext context, int index) {
                    print(que1);
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                            child: InkWell(
                          onTap: () {
                            if (currentFocus.hasFocus) {
                              FocusScope.of(context).unfocus();
                              setState(() {});
                            } else {
                              getanswer(que1[index], user2[index], time[index]);
                              setState(() {});
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    constraints: BoxConstraints(
                                      minHeight:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.80,
                                      minWidth:
                                          MediaQuery.of(context).size.width *
                                              0.20,
                                    ),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          que1[index],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          user2[index],
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.011,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      time[index],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black45,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )

                            // Column(
                            //   mainAxisAlignment: MainAxisAlignment.start,
                            //   crossAxisAlignment: CrossAxisAlignment.end,
                            //   children: [
                            //     Container(
                            //       margin: EdgeInsets.only(left: 20, top: 30),
                            //       padding: EdgeInsets.only(
                            //           left: 15, right: 10, top: 10, bottom: 10),
                            //       decoration: BoxDecoration(
                            //           border: Border.all(
                            //               color: Colors.black, width: 2.0),
                            //           borderRadius: BorderRadius.all(
                            //               Radius.circular(15.0))),
                            //       child: InkWell(
                            //         onTap: () {
                            //           if (currentFocus.hasFocus) {
                            //             FocusScope.of(context).unfocus();
                            //             setState(() {});
                            //           } else {
                            //             getanswer(que1[index], user2[index]);
                            //             setState(() {});
                            //           }
                            //         },
                            //         child: Column(
                            //           crossAxisAlignment:
                            //               CrossAxisAlignment.start,
                            //           children: [
                            //             Text(
                            //               que1[index],
                            //               textAlign: TextAlign.start,
                            //               style: TextStyle(
                            //                 fontSize: MediaQuery.of(context)
                            //                         .size
                            //                         .width *
                            //                     0.06,
                            //                 color: Colors.black,
                            //               ),
                            //             ),
                            //             SizedBox(
                            //               height: 3,
                            //             ),
                            //             Text(
                            //               user2[index],
                            //               maxLines: 1,
                            //               overflow: TextOverflow.ellipsis,
                            //               style: TextStyle(
                            //                 fontSize: MediaQuery.of(context)
                            //                         .size
                            //                         .width *
                            //                     0.03,
                            //                 color: Colors.black,
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //       constraints: BoxConstraints(
                            //         minHeight: 60.0,
                            //         minWidth: 120.0,
                            //         maxWidth:
                            //             MediaQuery.of(context).size.width * 0.8,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            ),
                      ),
                    );
                    // );
                  },
                ),
              ),
      ),
    );
  }

  Widget answercontainer() {
    return SafeArea(
      child: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
          setState(() {});
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
          ),
          margin: EdgeInsets.only(top: 10, bottom: 10),
          height: MediaQuery.of(context).size.height * 0.7,
          child: AnimationLimiter(
            child: (ans1.length == 0)
                ? Center(
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.24,
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: FittedBox(
                              child: Image.asset('assets/images/3973481.jpg'),
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Container(
                            child: Text(
                              'Be the first person to answer',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Scrollbar(
                    // isAlwaysShown: true,
                    // thickness: 7,
                    // radius: Radius.circular(10),
                    // controller: _controller_1,
                    child: ListView.builder(
                      controller: _controller_1,
                      itemCount: ans1.length,
                      itemBuilder: (BuildContext context, int index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 20,
                                          top: (index == 0) ? 50 : 20),
                                      padding: EdgeInsets.only(
                                          left: 15,
                                          right: 10,
                                          top: 10,
                                          bottom: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.black, width: .4),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15.0),
                                        ),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                          setState(() {});
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    ans1[index],
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.02,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 3,
                                                  ),
                                                  Text(
                                                    user1[index],
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.014,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      constraints: BoxConstraints(
                                        minHeight: 60.0,
                                        minWidth: 120.0,
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      time1[index],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                        // );
                      },
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Future showdialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          int selected = 9999;
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                actions: [
                  TextButton(
                      onPressed: () {
                        if (selected == 9999) {
                          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          //   behavior: SnackBarBehavior.floating,
                          //   duration: Duration(seconds: 2),
                          //   elevation: 2,
                          //   margin: EdgeInsets.only(
                          //       bottom: 30.0, left: 20.0, right: 20.0),
                          //   content: Container(child: Text("select a subject")),
                          // ));
                          showDialog(
                            barrierColor: Colors.transparent,
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'),
                                )
                              ],
                              title: Text(
                                'Select a subject',
                              ),
                            ),
                          );
                        } else {
                          subjectchoosen = true;
                          sub = subjectList[selected];
                          print(sub);
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text(
                        'Post',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.02,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ))
                ],
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          elevation: 3,
                          primary: Colors.white),
                      onPressed: () async {
                        subjectchoosen = false;
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.cancel_sharp,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.only(top: 30, bottom: 20),
                        child: Text(
                            'Select the subject related to your question')),
                  ],
                ),
                content: Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent:
                            MediaQuery.of(context).size.width * 0.14,
                        childAspectRatio: 4 / 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: subjectList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 250),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: (index == selected)
                                            ? Colors.purple
                                            : Colors.black,
                                        width: 1.0),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                child: InkWell(
                                  onTap: () async {
                                    selected = index;
                                    setState(() {});
                                    print(subjectList[index]);
                                  },
                                  child: Center(
                                    child: Text(
                                      subjectList[index].toUpperCase(),
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ));
          });
        });
  }

  Widget textfield() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.07,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Container(
          margin: EdgeInsets.only(bottom: 10, right: 20, left: 20),
          height: MediaQuery.of(context).size.height * 0.07,
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            // border: Border.all(width: 2.0, color: Colors.grey),
            borderRadius: BorderRadius.circular(25.0),
            // color: Colors.grey,
          ),
          child: Center(
            child: TextField(
              // enabled: (answershown)?false:true,
              showCursor: true,
              maxLines: 5,
              controller: fieldText,
              focusNode: fo,
              onChanged: (t) {
                text = true;
                setState(() {});
              },
              onTap: () {
                text = true;
                setState(() {});
              },
              style: TextStyle(
                fontSize: 16,
              ),
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.send,
              autocorrect: false,
              textCapitalization: TextCapitalization.sentences,
              textAlign: TextAlign.left,
              cursorColor: Colors.blue,
              cursorHeight: MediaQuery.of(context).size.height * 0.03,
              onSubmitted: (t) async {
                if (fieldText.text == '') {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'))
                            ],
                            title: Text('Text is empty'),
                          ));
                } else {
                  // post = true;
                  text = true;

                  await showdialog();
                  fo.unfocus();
                  if (subjectchoosen) {
                    final SharedPreferences sharedpref =
                        await SharedPreferences.getInstance();
                    String? username = sharedpref.getString('name');
                    msg = Message(
                        message: fieldText.text,
                        username: username ?? '',
                        subject: sub);
                    // await player
                    //     .setAsset('assets/mixkit-message-pop-alert-2354.mp3');
                    fieldText.clear();
                    await messageadd();
                  }
                  setState(() {});
                }
              },
              decoration: kTextFieldDecoration.copyWith(
                suffixIcon: Container(
                  padding: EdgeInsets.only(right: 5.0),
                  child: InkWell(
                    child: Icon(Icons.send_sharp),
                    onTap: () async {
                      if (fieldText.text == '') {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'))
                            ],
                            title: Text('Text is empty'),
                          ),
                        );
                      } else {
                        post = true;
                        text = true;
                        await showdialog();
                        fo.unfocus();
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (subjectchoosen) {
                          final SharedPreferences sharedpref =
                              await SharedPreferences.getInstance();
                          String? username = sharedpref.getString('name');
                          // player.play();
                          msg = Message(
                              message: fieldText.text,
                              username: username ?? '',
                              subject: sub);
                          // await player.setAsset(
                          //     'assets/mixkit-message-pop-alert-2354.mp3');
                          await messageadd();
                          fieldText.clear();
                        }
                        setState(() {});
                      }
                    },
                  ),
                ),
                border: InputBorder.none,
                hintText: 'Ask your question',
                hintStyle: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget textfield_1() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          // height: MediaQuery.of(context).size.height * 0.07,
          decoration: BoxDecoration(
            color: Colors.white,
            // borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0)),
          ),
          child: Container(
            // margin: EdgeInsets.only(bottom: 10, right: 20, left: 20),
            height: MediaQuery.of(context).size.height * 0.06,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
                // border: Border.all(width: 1.0, color: Colors.grey),
                // borderRadius: BorderRadius.circular(25.0),
                ),
            child: Center(
              child: TextField(
                showCursor: true,
                maxLines: 5,
                controller: fieldText_1,
                focusNode: fo_1,
                style: TextStyle(
                  fontSize: 17,
                ),
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.send,
                autocorrect: false,
                textCapitalization: TextCapitalization.sentences,
                textAlign: TextAlign.left,
                cursorColor: Colors.blue,
                cursorHeight: MediaQuery.of(context).size.height * 0.03,
                onSubmitted: (t) async {
                  final SharedPreferences sharedpref =
                      await SharedPreferences.getInstance();
                  if (fieldText_1.text == '') {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          )
                        ],
                        title: Text('Text is empty'),
                      ),
                    );
                  } else {
                    post = true;
                    text = true;
                    fo_1.unfocus();
                    ans = Answer(
                        username: sharedpref.getString('name')!,
                        answer: fieldText_1.text);
                    // await player
                    //     .setAsset('assets/mixkit-message-pop-alert-2354.mp3');
                    fieldText_1.clear();
                    await answeradd();
                    setState(() {});
                  }
                },
                decoration: kTextFieldDecoration.copyWith(
                  suffixIcon: InkWell(
                    child: Icon(Icons.send_sharp),
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      final SharedPreferences sharedpref =
                          await SharedPreferences.getInstance();
                      if (fieldText_1.text == '') {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('OK'))
                                  ],
                                  title: Text('Text is empty'),
                                ));
                      } else {
                        post = true;
                        text = true;
                        fo_1.unfocus();
                        // player.play();
                        ans = Answer(
                            username: sharedpref.getString('name')!,
                            answer: fieldText_1.text);

                        // await player.setAsset(
                        //     'assets/mixkit-message-pop-alert-2354.mp3');
                        await answeradd();
                        fieldText_1.clear();
                        setState(() {});
                      }
                    },
                  ),
                  border: InputBorder.none,
                  hintText: 'Comment your answer',
                  hintStyle: TextStyle(fontSize: 17),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool text = false;
  bool answershown = false;
  Message msg = Message(message: '', username: '', subject: '');
  Answer ans = Answer(username: '', answer: '');
  List msg1 = [];
  List msg2 = [];
  List ans1 = [];
  List que1 = [];
  List user1 = [];
  List user2 = [];
  List time = [];
  List time1 = [];
  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    return WillPopScope(
      onWillPop: onbackpress,
      child: new SafeArea(
        child: Scaffold(
          body: LoadingOverlay(
            isLoading: answershown,
            color: Colors.black,
            progressIndicator: (msg1.length == 0)
                ? Container(
                    height: MediaQuery.of(context).size.height * 1,
                    width: MediaQuery.of(context).size.width * 1,
                    color: Colors.white,
                    child: Center(
                      child: Container(
                        color: Color(0xff6E7FFC),
                        height: 130,
                        width: 130,
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: Icon(
                                  Icons.done,
                                  color: Colors.white,
                                  size: 50,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              'Posted',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.025,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            (post)
                                ? Container()
                                : Container(
                                    height: 40,
                                    width: 40,
                                    child: LoadingIndicator(
                                        indicatorType: Indicator.ballPulseSync,
                                        colors: const [Colors.black],
                                        strokeWidth: 0,
                                        backgroundColor: Colors.transparent,
                                        pathBackgroundColor: Colors.black),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      height: MediaQuery.of(context).size.height * 0.8,
                      // width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25.0),
                          topRight: Radius.circular(25.0),
                        ),
                        color: Colors.white,
                      ),
                      child: Stack(
                        children: [
                          answercontainer(),
                          textfield_1(),
                          Align(
                            alignment: Alignment.topRight, //changes
                            child: Container(
                              padding: EdgeInsets.only(right: 10), //changes
                              margin: EdgeInsets.only(top: 5),
                              child: Align(
                                alignment: Alignment.topRight,
                                widthFactor: 7,
                                child: IconButton(
                                  onPressed: () async {
                                    answershown = false;
                                    text = false;
                                    setState(() {});
                                  },
                                  icon: Icon(Icons.close_rounded),
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            child: Stack(
              children: [
                GestureDetector(
                    onTap: () async {
                      if (currentFocus.hasFocus) {
                        FocusScope.of(context).unfocus();
                        messageContainer();
                      }
                    },
                    child: messageContainer()),
                textfield(),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(top: 13),
                    child: Visibility(
                      visible: issearch,
                      child: SlideInLeft(
                        from: 50,
                        duration: Duration(milliseconds: 300),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              height: MediaQuery.of(context).size.height * 0.07,
                              width: MediaQuery.of(context).size.width * 0.8,
                              // color: Colors.indigo,
                              child: new ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: subjectList.length,
                                  itemBuilder: (BuildContext ctxt, int index) {
                                    return InkWell(
                                      onTap: () {
                                        searchindex = index;
                                        search = subjectList[index];
                                        setState(() {});
                                        print(search);
                                        searchbysubject(search);
                                      },
                                      child: new Card(
                                        color: (searchindex == index)
                                            ? Color(0xff6E7FFC)
                                            : Colors.white,
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                            child: Center(
                                                child: Text(
                                              subjectList[index].toUpperCase(),
                                              style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.016,
                                                fontWeight: FontWeight.bold,
                                                color: !(searchindex == index)
                                                    ? Color(0xff6E7FFC)
                                                    : Colors.white,
                                              ),
                                            ))),
                                      ),
                                    );
                                  }),
                            ),
                            // Container(
                            //   height: MediaQuery.of(context).size.height * 0.06,
                            //   width: MediaQuery.of(context).size.width * 0.1,
                            //   color: Colors.lightBlue,
                            //   margin: EdgeInsets.only(top: 10),
                            //   child: ElevatedButton(
                            //     style: ElevatedButton.styleFrom(
                            //         shape: CircleBorder(),
                            //         elevation: 6,
                            //         primary: Colors.purple),
                            //     onPressed: () async {
                            //       print('a');
                            //       issearch = false;
                            //       setState(() {});
                            //     },
                            //     child: Text('press'),
                            //     // child: Icon(
                            //     //   Icons.refresh_outlined,
                            //     //   color: Colors.black,
                            //     // ),
                            //   ),
                            // ),
                            CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 30,
                              child: InkWell(
                                onTap: () async {
                                  fo.unfocus();
                                  issearch = false;
                                  searchindex = 9999;
                                  getquestion();
                                  setState(() {});
                                },
                                child: Icon(
                                  Icons.cancel,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: (!issearch),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.02,
                          left: 18),
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 30,
                        child: InkWell(
                          onTap: () async {
                            issearch = true;
                            setState(() {});
                          },
                          child: Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future message() async {
    msg1.clear();
    msg2.clear();
    setState(() {});
    print('entered 1');
    database.once().then((event) {
      Map<String, dynamic>.from((event.value)).values.forEach((element) {
        Map<String, dynamic> map =
            new Map<String, dynamic>.from(json.decode(element));
        msg1.add(map);
      });
      msg2 = new List.from(msg1.reversed);

      if (answershown) {
        getanswer(ques, user, date_1);
      } else if (issearch) {
        searchbysubject(search);
      } else {
        getquestion();
      }
      setState(() {});
      return;
    });
  }

  Future messageadd() async {
    Map<String, dynamic> map = {
      'message': msg.message,
      'username': msg.username,
      'type': 'q',
      'subject': msg.subject,
      'time': formattedDate
    };
    String rawJson = jsonEncode(map);
    print(rawJson);
    try {
      database.push().set(rawJson);
    } catch (e) {
      print(e);
    }
    text = false;
    fo.unfocus();
    await message();
    return;
  }

  Future getanswer(
      String question, String username, String date_function) async {
    ques = question;
    user = username;
    date_1 = date_function;
    time1.clear();
    ans1.clear();
    user1.clear();
    for (int i = 0; i < msg1.length; i++) {
      if (msg1[i]['message'] == question && msg1[i]['type'] == 'a') {
        print('a');
        print(msg1[i]['answer']);
        ans1.add(msg1[i]['answer']);
        user1.add(msg1[i]['username']);
        time1.add(msg1[i]['time']);
      }
    }
    print(time1);
    // ans1.add(ques);
    // user1.add(user);
    // time1.add(date_1);
    ans1 = new List.from(ans1.reversed);
    user1 = new List.from(user1.reversed);
    time1 = new List.from(time1.reversed);
    print(time1);
    answershown = true;
    setState(() {});
    print('as');
  }

  Future searchbysubject(String subject) async {
    que1.clear();
    user2.clear();
    time.clear();
    print(subject);
    for (int i = 0; i < msg1.length; i++) {
      if (msg2[i]['type'] == 'q' && msg2[i]['subject'] == subject) {
        print(msg2[i]['subject']);
        print('aaa');
        que1.add(msg2[i]['message']);
        user2.add(msg2[i]['username']);
        time.add(msg2[i]['time']);
      }
    }
    // que1 = new List.from(que1.reversed);
    // user2 = new List.from(user2.reversed);
    // time = new List.from(time.reversed);
    print(que1);
    print(time);
    setState(() {});
  }

  Future getquestion() async {
    print('entered');
    que1.clear();
    user2.clear();
    time.clear();
    for (int i = 0; i < msg1.length; i++) {
      if (msg2[i]['type'] == 'q') {
        que1.add(msg2[i]['message']);
        user2.add(msg2[i]['username']);
        time.add(msg2[i]['time']);
      }
    }
    print(time);
    setState(() {});
  }

  Future answeradd() async {
    Map<String, dynamic> map = {
      'message': ques,
      'username': ans.username,
      'answer': ans.answer,
      'type': 'a',
      'time': formattedDate
    };
    String rawJson = jsonEncode(map);
    print(rawJson);
    try {
      database.push().set(rawJson);
    } catch (e) {
      print(e);
    }
    await message();
    return;
  }
}

class Message {
  final String message;
  final String username;
  final String subject;
  const Message({
    required this.message,
    required this.username,
    required this.subject,
  });
}

class Answer {
  final String username;
  final String answer;
  const Answer({
    required this.username,
    required this.answer,
  });
}
