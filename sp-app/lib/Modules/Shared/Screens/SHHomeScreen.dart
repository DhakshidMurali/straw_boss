import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sp_app/Auth/LoginScreen.dart';
import "package:sp_app/Helpers/Capitalize.dart";
import 'package:sp_app/Modules/Shared/Screens/ChangePasswordScreen.dart';
import 'package:sp_app/Modules/Shared/Screens/SubjectListScreen.dart';
import 'package:sp_app/Modules/Shared/Widgets/CustomSnackBar.dart';
import 'package:sp_app/Modules/Staff/Screens/STFormStatus.dart';
import 'package:sp_app/Modules/Staff/Widgets/Neumorphic_Chart/pie_chart_view.dart';
import 'package:sp_app/Modules/Students/Screens/Quiz/IntroQuizScreen.dart';
import 'package:sp_app/Modules/Students/Screens/STSubmitFromScreen.dart';
import 'package:sp_app/Provider/Data.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../constant.dart';
import 'DownloadsScreen.dart';
import 'QueryScreen.dart';
import 'SHCreateFormScreen.dart';

class SHHomeScreen extends StatefulWidget {
  final name;
  SHHomeScreen(this.name);

  @override
  _SHHomeScreenState createState() => _SHHomeScreenState();
}

class _SHHomeScreenState extends State<SHHomeScreen>
    with TickerProviderStateMixin {
  late double screenWidth, screenHeight;
  final now = DateTime.now();
  bool isCollapsed = true;
  var selected;
  var isStaff = false;

  var icons = [
    Icons.home,
    Icons.label,
    Icons.my_library_books,
    Icons.cloud_download_sharp,
  ];
  int currentIndex = 0;
  int count = 0;
  bool _isLoading = false;

  final Duration duration = const Duration(milliseconds: 500);
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _menuScaleAnimation;
  late Animation<Offset> _slideAnimation;

  var data = [];
  var calender = [];

  var _refresh = RefreshController(initialRefresh: false);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(duration: duration, vsync: this);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(_controller);
    _menuScaleAnimation =
        Tween<double>(begin: 0.5, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(_controller);
    setData();
    selected = now;
    calender = [
      DateTime(now.year, now.month, now.day - 3),
      DateTime(now.year, now.month, now.day - 2),
      DateTime(now.year, now.month, now.day - 1),
      now,
      DateTime(now.year, now.month, now.day + 1),
      DateTime(now.year, now.month, now.day + 2),
      DateTime(now.year, now.month, now.day + 3),
      DateTime(now.year, now.month, now.day + 4),
      DateTime(now.year, now.month, now.day + 5),
      DateTime(now.year, now.month, now.day + 6),
      DateTime(now.year, now.month, now.day + 7),
    ];
  }

  Future<void> setData() async {
    final SharedPreferences sharedpref = await SharedPreferences.getInstance();
    print(sharedpref.getString('id'));
    final provider = Provider.of<Data>(context, listen: false);
    var providerData = provider.data;
    setState(() {
      isStaff = sharedpref.getString('role') == 'staff' ? true : false;
    });
    for (int i = 0; i < providerData.length; i++) {
      if (!providerData[i]['completed'].contains(sharedpref.getString('id')))
        setState(() {
          count++;
        });
    }
  }

  final FirebaseAuth? _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<String?> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    final UserCredential authResult =
        await _auth!.signInWithCredential(credential);
    final User? user = authResult.user;
    print(user!.email);
    print('bala');

    final SharedPreferences sharedpref = await SharedPreferences.getInstance();
    print({"email": sharedpref.getString('email')});

    final provider = Provider.of<Data>(context, listen: false);
    var res = await provider.linkGoogle({
      "email": sharedpref.getString('email'),
      "gmail": user.email.toString()
    });

    if (res == '200')
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar(
          content: 'Gmail Linked Successfully',
        ),
      );
    else
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar(
          content: 'Try Later',
        ),
      );
    return user.email;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  setBottomBarIndex(index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;

    return Scaffold(
      // backgroundColor: Color.fromRGBO(193, 214, 233, 1),
      backgroundColor: isCollapsed ? Colors.white : Color(0xff2C364E),
      floatingActionButton: isStaff
          ? currentIndex == 0
              ? FloatingActionButton(
                  backgroundColor: Colors.indigoAccent,
                  onPressed: () {
                    setState(() => (_isLoading == true)
                        ? (_isLoading = false)
                        : (_isLoading = true));
                  },
                  child: _isLoading
                      ? Icon(
                          Icons.cancel_outlined,
                          color: Colors.white,
                        )
                      : Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                )
              : null
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: !isCollapsed
          ? null
          : AnimatedBottomNavigationBar(
              elevation: 20,
              onTap: (index) {
                if (index == currentIndex)
                  return;
                else {
                  setState(() {
                    if (index == 1 || index == 2 || index == 3)
                      _isLoading = false;
                    currentIndex = index;
                  });
                }
              },
              activeIndex: currentIndex,
              icons: icons,
              backgroundColor: Colors.white,
              inactiveColor: Colors.indigo,
              activeColor: Colors.lightBlue,
              height: 60,
              gapLocation: isStaff ? GapLocation.center : GapLocation.none,
              notchSmoothness: NotchSmoothness.verySmoothEdge,
            ),
      body: LoadingOverlay(
        color: Colors.black,
        progressIndicator: Align(
          alignment: Alignment.bottomCenter,
          child: AnimationLimiter(
            child: Container(
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * .07),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 375),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(
                      child: widget,
                    ),
                  ),
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Colors.lightBlue,
                            elevation: 10,
                            child: MaterialButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SHCreateFormScreen('quiz', widget.name),
                                  ),
                                );
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * .2,
                                child: Text(
                                  "Quiz",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Colors.lightBlue,
                            elevation: 10,
                            child: MaterialButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SHCreateFormScreen('form', widget.name),
                                  ),
                                );
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * .2,
                                child: Text(
                                  "Form",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: Colors.lightBlue,
                            elevation: 10,
                            child: MaterialButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SHCreateFormScreen('ack', widget.name),
                                  ),
                                );
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * .23,
                                child: Text(
                                  "Acknowledge",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        isLoading: _isLoading,
        child: SafeArea(
          child: currentIndex == 0
              ? Stack(
                  children: <Widget>[menu(context), HomeScreen()],
                )
              : currentIndex == 1
                  ? QueryScreen()
                  : currentIndex == 2
                      ? SubjectListScreen()
                      : DownloadsScreen(),
        ),
      ),
    );
  }

  Widget menu(context) {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _menuScaleAnimation,
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangePasswordScreen(false),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * .25,
                        child: Text(
                          "Change\nPassword",
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .16,
                      ),
                      Icon(
                        Icons.password_rounded,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    elevation: 0,
                  ),
                  onPressed: () async {
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    await preferences.clear();

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * .25,
                        child: Text("Logout",
                            style:
                                TextStyle(color: Colors.white, fontSize: 17)),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .16,
                      ),
                      Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  margin: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * .4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          "Link with Google",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: InkWell(
                          onTap: () async {
                            signInWithGoogle();
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: SvgPicture.asset(
                              'assets/icons/google.svg',
                              fit: BoxFit.cover,
                              allowDrawingOutsideViewBox: true,
                            ),
                            radius: MediaQuery.of(context).size.width * .038,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget HomeScreen() {
    return AnimatedPositioned(
      duration: duration,
      top: 0,
      bottom: 0,
      left: isCollapsed ? 0 : 0.6 * screenWidth,
      right: isCollapsed ? 0 : -0.2 * screenWidth,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          animationDuration: duration,
          borderRadius:
              isCollapsed ? null : BorderRadius.all(Radius.circular(40)),
          elevation: isCollapsed ? 0 : 8,
          child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            header: WaterDropHeader(),
            footer: CustomFooter(
              builder: (context, mode) {
                Widget body;
                // if (mode == LoadStatus.idle) {
                //   body = Container();
                // } else if (mode == LoadStatus.loading) {
                //   body = Container();
                // } else if (mode == LoadStatus.failed) {
                //   body = Text("Load Failed!Click retry!");
                // } else if (mode == LoadStatus.canLoading) {
                //   body = Text("release to load more");
                // } else {
                //   body = Text("No more Data");
                // }
                return Container(
                    // height: 55.0,
                    // child: Center(child: body),
                    );
              },
            ),
            controller: _refresh,
            onRefresh: () async {
              print('bala');
              final provider = Provider.of<Data>(context, listen: false);

              await provider.getWorks();

              setState(() {
                _refresh.refreshCompleted();
              });
            },
            // onLoading: _onLoading,
            child: ListView(
              children: <Widget>[
                Container(
                  height: 90,
                  child: Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.transparent,
                          elevation: 0,
                        ),
                        onPressed: () {
                          setState(() {
                            if (isCollapsed)
                              _controller.forward();
                            else
                              _controller.reverse();

                            isCollapsed = !isCollapsed;
                          });
                        },
                        child: Icon(
                          Icons.menu,
                          color: Color(0xff2C364E),
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 15.0, horizontal: 5),
                        child: Row(
                          children: [
                            // Container(child: circleavatar),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hello there,",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                Text(
                                  widget.name.toUpperCase() ?? '',
                                  style: TextStyle(
                                    color: Color(0xff2C364E),
                                    fontSize: 19,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20.0, left: 20),
                  padding: EdgeInsets.symmetric(vertical: 1.0),
                  height: 100,
                  child: new ListView.builder(
                    itemBuilder: (context, index) {
                      return selected != calender[index]
                          ? InkWell(
                              onTap: () {
                                setState(() {
                                  selected = calender[index];
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 5.5, vertical: 2),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 40.0,
                                      child: Text(
                                        DateFormat('E')
                                            .format(calender[index])
                                            .toString(),
                                        style: TextStyle(
                                          color: Color(0xffa6a5ba),
                                          fontSize: 14.5,
                                          // fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      width: 40.0,
                                      child: Text(
                                        DateFormat('d')
                                            .format(calender[index])
                                            .toString(),
                                        style: TextStyle(
                                          color: Color(0xff2C364E),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: Color(0xff6E7FFC),
                              ),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 5.5, vertical: 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 40.0,
                                    child: Text(
                                      DateFormat('E')
                                          .format(calender[index])
                                          .toString(),
                                      style: TextStyle(
                                        color: Colors.grey.shade100,
                                        fontSize: 15,
                                        // fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: 40.0,
                                    child: Text(
                                      DateFormat('d')
                                          .format(calender[index])
                                          .toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                  ),
                                ],
                              ),
                            );
                    },
                    scrollDirection: Axis.horizontal,
                    itemCount: calender.length,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  height: MediaQuery.of(context).size.height * 0.14,
                  width: MediaQuery.of(context).size.width * 1,
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.circular(25.0),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xff6E7FFC), Colors.lightBlueAccent],
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * .11,
                        child: Icon(
                          Icons.task_alt,
                          size: MediaQuery.of(context).size.width * .08,
                          color: Colors.white,
                        ),
                      ),
                      Consumer<Data>(builder: (context, tripsProvider, child) {
                        data = tripsProvider.data;

                        if (data.length > 0)
                          return Container(
                            margin: EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "You have got $count task",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 19,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * .66,
                                  child: Text(
                                    "Check your task status for today"
                                        .toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                          );
                        else
                          return Container(
                            margin: EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "You are done with you work",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          );
                      }),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child:
                      Consumer<Data>(builder: (context, tripsProvider, child) {
                    data = tripsProvider.data;
                    if (data.length > 0)
                      return AnimationLimiter(
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () async {
                                final SharedPreferences sharedpref =
                                    await SharedPreferences.getInstance();

                                if (sharedpref.getString('role') == 'staff')
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          STFormStatus(data[index]),
                                    ),
                                  );
                                if (sharedpref.getString('role') == 'student') {
                                  if (data[index]['type'] == 'form' ||
                                      data[index]['type'] == 'ack')
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            STSubmitFormScreen(data[index]),
                                      ),
                                    );
                                  if (data[index]['type'] == 'quiz') {
                                    if (!data[index]['completed']
                                        .contains(sharedpref.getString('id')))
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              IntroQuizScreen(data[index]),
                                        ),
                                      );
                                    else
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        customSnackBar(
                                          content: 'Already Completed',
                                        ),
                                      );
                                  }
                                }
                              },
                              child: AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 375),
                                child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: new Container(
                                        height: 150,
                                        padding: const EdgeInsets.all(8.0),
                                        child: Neumorphic(
                                          style: NeumorphicStyle(
                                            shape: NeumorphicShape.flat,
                                            // depth: 20, //customize depth here
                                            color: Colors.white,
                                            border: NeumorphicBorder(
                                              color: Color.fromRGBO(
                                                  193, 214, 233, 1),
                                              width: 0.8,
                                            ),
                                          ),
                                          child: new Container(
                                            width: 40.0,
                                            height: 100.0,
                                            decoration: BoxDecoration(
                                              border: Border(
                                                left: BorderSide(
                                                  color: data[index]['type'] ==
                                                          'form'
                                                      ? Colors.green
                                                      : data[index]['type'] !=
                                                              'quiz'
                                                          ? Colors.red
                                                          : Colors.blue,
                                                  width: 5,
                                                ),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .5,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 8.0,
                                                      left: 24,
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          data[index]['title']!
                                                              .toString()
                                                              .capitalizeFirstofEach,
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.brown,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        if (isStaff)
                                                          Text(
                                                            data[index]
                                                                    ['class']!
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        if (!isStaff)
                                                          Text(
                                                            data[index][
                                                                    'creatorName']!
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          data[index]
                                                              ['lastDate'],
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .05,
                                                ),
                                                PieChartView(data[index]),
                                              ],
                                            ),
                                            alignment: Alignment.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          scrollDirection: Axis.vertical,
                          itemCount: data.length,
                        ),
                      );
                    else
                      return Container(
                          // child: Text(
                          //   'You are done',
                          //   style: TextStyle(
                          //     fontWeight: FontWeight.bold,
                          //   ),
                          //   textAlign: TextAlign.center,
                          // ),
                          );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
