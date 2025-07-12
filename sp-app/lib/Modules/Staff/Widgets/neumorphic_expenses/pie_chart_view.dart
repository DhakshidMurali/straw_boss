import 'package:flutter/material.dart';
import './pie_chart.dart';

class PieChartView extends StatelessWidget {
  PieChartView(this.data);

  final data;
  @override
  Widget build(BuildContext context) {
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
                          Category('Completed', amount: 40),
                          Category('Not Completed', amount: 12),
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    height: 10,
                    decoration: BoxDecoration(
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
                    ),
                    child: Center(
                      child: Text(
                        '\$1280.20',
                        style: TextStyle(
                          fontSize: 10,
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
}

class Category {
  Category(this.name, {required this.amount});

  final String name;
  final double amount;
}
