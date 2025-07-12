import 'package:flutter/material.dart';
import './pie_chart.dart';

class PieChartView extends StatelessWidget {
  PieChartView(this.data);

  final data;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Expanded(
      // flex: 4
      child: Container(
        height: MediaQuery.of(context).size.height * .1,
        child: LayoutBuilder(
          builder: (context, constraint) => Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(193, 214, 233, 1),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  spreadRadius: -10,
                  blurRadius: 17,
                  offset: Offset(-5, -5),
                  color: Colors.white,
                ),
                BoxShadow(
                  spreadRadius: -2,
                  blurRadius: 10,
                  offset: Offset(7, 7),
                  color: Color.fromRGBO(146, 182, 216, 1),
                )
              ],
            ),
            child: Stack(
              children: [
                Center(
                  child: SizedBox(
                    child: CustomPaint(
                      child: Center(),
                      foregroundPainter: PieChart(
                        width: MediaQuery.of(context).size.width * .08,
                        categories: [
                          Category('Completed',
                              amount: data['completed'].length.toDouble()),
                          Category('Not Completed',
                              amount: data['unCompleted'].length.toDouble()),
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    height: 55,
                    decoration: data['unCompleted'].length > 0
                        ? BoxDecoration(
                            color: Color.fromRGBO(193, 214, 233, 1),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 1,
                                offset: Offset(-1, -1),
                                color: Colors.white,
                              ),
                              BoxShadow(
                                spreadRadius: -2,
                                blurRadius: 10,
                                offset: Offset(5, 5),
                                color: Colors.black.withOpacity(0.5),
                              )
                            ],
                          )
                        : null,
                    child: data['unCompleted'].length > 0
                        ? Center(
                            child: Column(
                              children: [
                                Text(
                                  '${data['completed'].length}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.indigo),
                                ),
                                Container(
                                  width: 20,
                                  child: Divider(
                                    color: Colors.indigo,
                                    height: 2,
                                    thickness: 1,
                                  ),
                                ),
                                Text(
                                  '${data['completed'].length + data['unCompleted'].length}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.indigo),
                                ),
                              ],
                            ),
                          )
                        : Icon(
                            Icons.done,
                            size: 40,
                            color: Color.fromRGBO(123, 201, 82, 1),
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
}

class Category {
  Category(this.name, {required this.amount});

  final String name;
  final double amount;
}
