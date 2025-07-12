import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sp_app/Modules/Shared/Widgets/CustomSnackBar.dart';
import 'package:sp_app/Provider/Data.dart';

import '../../../constant.dart';

class STSubmitFormScreen extends StatefulWidget {
  final data;

  STSubmitFormScreen(this.data);

  @override
  _STSubmitFormScreenState createState() => _STSubmitFormScreenState();
}

class _STSubmitFormScreenState extends State<STSubmitFormScreen> {
  final dateNow = DateTime.now();
  var dateAPI;
  var date;
  var _result = '';
  var className = 'IIICSEA';
  bool _trySubmitted = false;
  bool isLoading = false;

  List<Map<String, dynamic>> _values = [];
  List<bool> required = [true];

  final _formKey = GlobalKey<FormState>();

  Future<void> _submitted() async {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _trySubmitted = true;
    });
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      setState(() {
        isLoading = true;
      });
      final provider = Provider.of<Data>(context, listen: false);
      final SharedPreferences sharedpref =
          await SharedPreferences.getInstance();
      print(_values.runtimeType);
      var result = await provider.completeWork({
        "workID": widget.data["_id"],
        "studentID": sharedpref.getString('id'),
        "studentName": sharedpref.getString('name'),
        "answers": _values
      });

      print(result['code']);
      if (result['code'] == '200') {
        await provider.getWorks();
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar(
            content: result['message'].toString(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data['questions'] as List;
    final isCompleted = widget.data['isCompleted'];
    print(data.length);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: LoadingOverlay(
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
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              if (!isCompleted)
                _submitted();
              else
                ScaffoldMessenger.of(context).showSnackBar(
                  customSnackBar(
                    content: 'Already submitted'.toString(),
                  ),
                );
            },
            label: Text(
              widget.data['type'] == 'ack'
                  ? isCompleted == false
                      ? 'Acknowledge'
                      : 'Already Acknowledged'
                  : isCompleted == false
                      ? 'Submit Form'
                      : 'Already Submitted',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            icon: isCompleted == false
                ? Icon(
                    Icons.add,
                    color: Colors.white,
                  )
                : null,
            backgroundColor: Color(0xff6E7FFC),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(
              MediaQuery.of(context).size.height * .11,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * .02,
              ),
              child: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  widget.data['title'],
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions: [
                  if (!isCompleted && widget.data['type'] != 'ack')
                    Padding(
                      padding: const EdgeInsets.only(right: 25.0),
                      child: IconButton(
                        color: Colors.black,
                        icon: Icon(Icons.refresh),
                        onPressed: () async {
                          setState(() {
                            _result = '';
                            required = [];
                            _values = [];
                          });
                        },
                      ),
                    )
                ],
              ),
            ),
          ),
          body: Container(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (widget.data['type'] != 'ack')
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            if (data[index]['type'] == 'Text')
                              return Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: AnimatedContainer(
                                  margin: EdgeInsets.symmetric(
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            0.01,
                                    horizontal:
                                        MediaQuery.of(context).size.height *
                                            0.01,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  duration: Duration(milliseconds: 500),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 8.0,
                                                    bottom: 10.0,
                                                  ),
                                                  child: Text(
                                                    '${data[index]['question']} :',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                if (data[index]['required'])
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 8.0,
                                                      bottom: 10.0,
                                                    ),
                                                    child: Text(
                                                      '* Required',
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.redAccent),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: TextFormField(
                                                    enableInteractiveSelection:
                                                        isCompleted
                                                            ? false
                                                            : true,
                                                    decoration:
                                                        TextFieldDecoration
                                                            .copyWith(
                                                      hintText: ' ',
                                                    ),
                                                    initialValue: isCompleted
                                                        ? widget
                                                                        .data[
                                                                            'completedData']
                                                                            [
                                                                            'answers']
                                                                        .length -
                                                                    1 >
                                                                index
                                                            ? widget.data[
                                                                        'completedData']
                                                                    ['answers'][
                                                                index]['answer']
                                                            : ""
                                                        : null,
                                                    validator: (val) {
                                                      if (data[index]
                                                              ['required'] ==
                                                          true) if (val!.isEmpty) {
                                                        return 'Field Required';
                                                      }
                                                      return null;
                                                    },
                                                    maxLines: null,
                                                    focusNode: isCompleted
                                                        ? NoKeyboardEditableTextFocusNode()
                                                        : null,
                                                    keyboardType:
                                                        TextInputType.multiline,
                                                    onChanged: (val) {
                                                      if (_trySubmitted)
                                                        _formKey.currentState!
                                                            .validate();
                                                      _onUpdate(
                                                        index,
                                                        val,
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            return Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
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
                                duration: Duration(milliseconds: 500),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 8.0,
                                                  bottom: 10.0,
                                                ),
                                                child: Text(
                                                  '${data[index]['question']} :',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              if (data[index]['required'])
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 8.0,
                                                    bottom: 10.0,
                                                  ),
                                                  child: Text(
                                                    '* Required',
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Colors.redAccent),
                                                  ),
                                                ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      _onUpdate(
                                                        index,
                                                        data[index]['options']
                                                            [0],
                                                      );
                                                    },
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .4,
                                                      padding:
                                                          EdgeInsets.all(20),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(40),
                                                        color:
                                                            Color(0xff6E7FFC),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          data[index]['options']
                                                              [0],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      _onUpdate(
                                                        index,
                                                        data[index]['options']
                                                            [1],
                                                      );
                                                    },
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .4,
                                                      padding:
                                                          EdgeInsets.all(20),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(40),
                                                        color:
                                                            Color(0xff6E7FFC),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          data[index]['options']
                                                              [1],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      _onUpdate(
                                                        index,
                                                        data[index]['options']
                                                            [1],
                                                      );
                                                    },
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .4,
                                                      padding:
                                                          EdgeInsets.all(20),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(40),
                                                        color:
                                                            Color(0xff6E7FFC),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          data[index]['options']
                                                              [2],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      _onUpdate(
                                                        index,
                                                        data[index]['options']
                                                            [3],
                                                      );
                                                    },
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .4,
                                                      padding:
                                                          EdgeInsets.all(20),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(40),
                                                        color:
                                                            Color(0xff6E7FFC),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          data[index]['options']
                                                              [3],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    if (widget.data['type'] == 'ack')
                      Container(
                        margin: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.01,
                          horizontal: MediaQuery.of(context).size.height * 0.01,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          widget.data['questions'][0]['question'],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _onUpdate(int index, String val) async {
    if (val != '') {
      int foundKey = -1;
      for (var map in _values) {
        if (map.containsKey("id")) {
          if (map["id"] == index) {
            foundKey = index;
            break;
          }
        }
      }
      if (-1 != foundKey) {
        _values.removeWhere((map) {
          if (val == '') {
            val = map['question'];
          }
          return map["id"] == foundKey;
        });
      }
      Map<String, dynamic> json = {
        "id": index,
        "answer": val,
      };
      _values.add(json);
      setState(() {
        _result = _values.toString();
      });
    }
  }
}

class NoKeyboardEditableTextFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
  @override
  bool consumeKeyboardToken() {
    return false;
  }
}
