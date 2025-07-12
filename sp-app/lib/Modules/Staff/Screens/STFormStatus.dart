import 'dart:io' show Platform;
import 'package:loading_indicator/loading_indicator.dart';
import 'package:loading_overlay/loading_overlay.dart';
import "package:sp_app/Helpers/Capitalize.dart";
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import "package:sp_app/Helpers/Capitalize.dart";
import 'package:sp_app/Modules/Shared/Widgets/CustomSnackBar.dart';
import 'package:sp_app/Provider/Data.dart';
import 'package:url_launcher/url_launcher.dart';

class STFormStatus extends StatefulWidget {
  final data;
  STFormStatus(this.data);
  @override
  _STFormStatusState createState() => _STFormStatusState();
}

class _STFormStatusState extends State<STFormStatus> {
  bool isCompleted = true;
  List isExpandedComp = [];
  List isExpandedUnComp = [];
  bool isLoading = false;

  Future whatsapp(number) async {
    var whatsapp = "+91$number";
    var whatsapp_url = "whatsapp://send?phone=" +
        whatsapp +
        "&text=Complete the ${widget.data['title']} Work";
    var whatappURL_ios = "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
    if (Platform.isIOS) {
      if (await canLaunch(whatappURL_ios)) {
        await launch(whatappURL_ios, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("Whatsapp is not installed")));
      }
    } else {
      print(whatsapp_url);
      if (await canLaunch(whatsapp_url)) {
        await launch(whatsapp_url);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: new Text("Whatsapp is not installed")));
      }
    }
  }

  Future phoneCall(number) async {
    var phone = "+91$number";
    var phone_url = 'tel://$phone';
    if (await canLaunch(phone_url)) {
      await launch(phone_url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: new Text("Error Occured"),
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    for (int i = 0; i < widget.data['completed'].length; i++) {
      isExpandedComp.add(false);
    }
    for (int i = 0; i < widget.data['unCompleted'].length; i++) {
      isExpandedUnComp.add(false);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      color: Colors.black,
      isLoading: isLoading,
      progressIndicator: Center(
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            color: Color(0xff6E7FFC),
            height: 130,
            width: 130,
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Loading',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.025,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Container(
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
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff6E7FFC),
          title: Text(
            widget.data['title'].toString().capitalizeFirstofEach,
          ),
        ),
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.only(top: 15),
            child: Column(
              children: [
                Container(
                  height: 60,
                  margin: EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: ToggleButtons(
                        borderRadius: BorderRadius.circular(10),
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * .4,
                            child: Center(
                              child: Text(
                                "Completed",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * .4,
                            child: Center(
                              child: Text(
                                "Not Completed",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                        onPressed: (int index) {
                          setState(() {
                            if (index == 0) {
                              isCompleted = true;
                            } else {
                              isCompleted = false;
                            }
                          });
                        },
                        color: Color(0xff6E7FFC),
                        selectedColor: Colors.white,
                        fillColor: Color(0xff6E7FFC),
                        isSelected: [isCompleted, !isCompleted],
                        borderColor: Colors.transparent,
                      ),
                    ),
                  ),
                ),
                if (isCompleted)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                        color: Color(0xff6E7FFC),
                      )),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          primary: Colors.transparent,
                          // shape: StadiumBorder(),
                        ),
                        onPressed: () async {
                          print(widget.data["_id"]);
                          setState(() {
                            isLoading = true;
                          });
                          final provider =
                              Provider.of<Data>(context, listen: false);
                          print(widget.data["_id"]);
                          var result = await provider.sendMail({
                            "workId": widget.data["_id"],
                          });

                          if (result['code'] == '200') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              customSnackBar(
                                content: 'Email sent Successfully',
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              customSnackBar(
                                content: 'Try Later',
                              ),
                            );
                          }
                          setState(() {
                            isLoading = false;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.attach_email,
                                color: Color(0xff6E7FFC),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Send mail',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Color(0xff6E7FFC),
                                  letterSpacing: 0.7,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () async {
                        if (isCompleted) {
                          if (widget.data['type'] != 'ack')
                            setState(() {
                              isExpandedComp[index] = !isExpandedComp[index];
                            });
                        } else {
                          setState(() {
                            isExpandedUnComp[index] = !isExpandedUnComp[index];
                          });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4),
                        child: Card(
                          child: AnimatedContainer(
                            margin: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * 0.01,
                              horizontal:
                                  MediaQuery.of(context).size.height * 0.01,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            duration: Duration(milliseconds: 300),
                            child: Column(
                              children: [
                                new Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  padding: const EdgeInsets.all(8.0),
                                  child: new Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                isCompleted
                                                    ? widget.data['completed']
                                                            [index]
                                                            ['studentName']!
                                                        .toString()
                                                        .capitalizeFirstofEach
                                                    : widget.data['unCompleted']
                                                            [index]['name']!
                                                        .toString()
                                                        .capitalizeFirstofEach,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xff2C364E),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(isCompleted
                                            ? widget.data['type'] != 'ack'
                                                ? isExpandedComp[index]
                                                    ? Icons.expand_less
                                                    : Icons.expand_more
                                                : null
                                            : isExpandedUnComp[index]
                                                ? Icons.expand_less
                                                : Icons.expand_more),
                                      ],
                                    ),
                                    alignment: Alignment.center,
                                  ),
                                ),
                                AnimatedContainer(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  height: isCompleted
                                      ? isExpandedComp[index]
                                          ? widget.data['type'] == 'quiz'
                                              ? 40
                                              : widget.data['questions']
                                                          .length *
                                                      22.toDouble() +
                                                  10.0
                                          : 0
                                      : isExpandedUnComp[index]
                                          ? 50
                                          : 0,
                                  duration: Duration(milliseconds: 200),
                                  child: isCompleted
                                      ? isExpandedComp[index]
                                          ? widget.data['type'] != 'quiz'
                                              ? ListView.builder(
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemBuilder:
                                                      (context, indexVal) {
                                                    final questions = widget
                                                        .data['questions'];
                                                    print(questions);
                                                    final answers =
                                                        widget.data['completed']
                                                            [index]['answers'];
                                                    print(answers);
                                                    return Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 8),
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5.5,
                                                              vertical: 2),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(questions[
                                                                  indexVal]
                                                              ['question']),
                                                          Text(answers[indexVal]
                                                              ['answer']),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  itemCount: widget
                                                      .data['completed'][index]
                                                          ['answers']
                                                      .length,
                                                )
                                              : Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8),
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 5.5,
                                                      vertical: 2),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text('Score'),
                                                      Text(widget
                                                          .data['completed']
                                                              [index]['answers']
                                                              [0]['answer']
                                                          .toString()),
                                                    ],
                                                  ),
                                                )
                                          : null
                                      : isExpandedUnComp[index]
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Remainder : ',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary:
                                                          Colors.transparent,
                                                      elevation: 0,
                                                    ),
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      child: SvgPicture.asset(
                                                        'assets/icons/call.svg',
                                                        fit: BoxFit.cover,
                                                        allowDrawingOutsideViewBox:
                                                            true,
                                                      ),
                                                      radius:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .038,
                                                    ),
                                                    onPressed: () {
                                                      phoneCall(widget.data[
                                                              'unCompleted']
                                                          [index]['phone']);
                                                    },
                                                  ),
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary:
                                                          Colors.transparent,
                                                      elevation: 0,
                                                    ),
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      child: SvgPicture.asset(
                                                        'assets/icons/whats.svg',
                                                        fit: BoxFit.cover,
                                                        allowDrawingOutsideViewBox:
                                                            true,
                                                      ),
                                                      radius:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .038,
                                                    ),
                                                    onPressed: () {
                                                      whatsapp(widget.data[
                                                              'unCompleted']
                                                          [index]['phone']);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            )
                                          : null,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  scrollDirection: Axis.vertical,
                  itemCount: isCompleted
                      ? (widget.data['completed'].length)
                      : (widget.data['unCompleted'].length),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
