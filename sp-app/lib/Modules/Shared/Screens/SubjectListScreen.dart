import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:sp_app/Modules/Shared/Screens/FileListScreen.dart';
import 'package:sp_app/Helpers/ConstantData.dart';
import 'package:sliver_header_delegate/sliver_header_delegate.dart';
import 'package:sp_app/Modules/Shared/Widgets/BottomNavigationBar.dart';

class SubjectListScreen extends StatefulWidget {
  const SubjectListScreen({Key? key}) : super(key: key);

  @override
  _SubjectListScreenState createState() => _SubjectListScreenState();
}

class _SubjectListScreenState extends State<SubjectListScreen> {
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: FlexibleHeaderDelegate(
            expandedHeight: 60,
            collapsedHeight: 40,
            background: MutableBackground(
              collapsedColor: Colors.lightBlueAccent,
              expandedWidget: Container(
                padding: EdgeInsets.only(top: 15),
                color: Color(0xff6E7FFC),
                child: Text(
                  'Courses',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
        AnimationLimiter(
          child: SliverPadding(
            padding: const EdgeInsets.all(15),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200.0,
                mainAxisSpacing: 7,
                crossAxisSpacing: 7,
                childAspectRatio: 1,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: Container(
                        margin: EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            primary: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DisplayFile(subjectList[index]),
                              ),
                            );
                          },
                          child: Center(
                            child: Text(
                              subjectList[index],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.indigo),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                childCount: subjectList.length,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
