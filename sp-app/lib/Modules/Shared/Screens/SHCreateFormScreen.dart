import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sp_app/Modules/Shared/Widgets/CustomSnackBar.dart';
import 'package:sp_app/Provider/Data.dart';

import '../../../constant.dart';
import 'SHHomeScreen.dart';

class SHCreateFormScreen extends StatefulWidget {
  final type;
  final name;
  SHCreateFormScreen(this.type, this.name);

  @override
  _SHCreateFormScreenState createState() => _SHCreateFormScreenState();
}

class _SHCreateFormScreenState extends State<SHCreateFormScreen> {
  final dateNow = DateTime.now();
  int _count = 1;
  var dateAPI;
  var date;
  var _result = '';
  List<String> classes = [];
  final TextEditingController _lastDate = TextEditingController();
  final TextEditingController _title = TextEditingController();
  var className = null;
  bool isLoading = false;
  List<bool> isExpanded = [true];
  List<int> _radioSelected = [1];
  List<String> _radioType = ['Text'];
  List<Map<String, dynamic>> _values = [];
  List<bool> required = [true];
  List<dynamic> options = [
    {
      "id": 0,
      "options": ['', '', '', '']
    }
  ];
  List<dynamic> correctOptions = [''];

  void _datePicker() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year, now.month, now.day),
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year, now.month, now.day + 30),
    );
    if (picked != null) {
      setState(() {
        date = (DateFormat('dd-MM-yyyy').format(picked));
        _lastDate.text = date;
      });
    }
  }

  void _submitted() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (className == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar(content: 'Pick a class'),
      );
      return;
    }
    if (_title.text == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar(content: 'Enter a title'),
      );
      return;
    }
    if (widget.type == 'quiz')
      for (var i = 0; i < correctOptions.length; i++) {
        if (correctOptions[i] == '') {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
                content:
                    'Correct option is not selected for ${i + 1} question'),
          );
          return;
        }

        if (!(correctOptions[i] == 'A' ||
            correctOptions[i] == 'B' ||
            correctOptions[i] == 'C' ||
            correctOptions[i] == 'D')) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnackBar(
                content:
                    'Correct option is for ${i + 1} question is not Valid (A,B,C,D)'),
          );
          return;
        }
      }

    if (_lastDate.text != '') {
      setState(() {
        isLoading = true;
      });
      final provider = Provider.of<Data>(context, listen: false);
      final SharedPreferences sharedpref =
          await SharedPreferences.getInstance();
      print(_values.runtimeType);
      print(_values);
      print(options);

      var data = {
        'title': _title.text,
        'lastDate': _lastDate.text,
        'questions': _values,
        'creatorId': sharedpref.getString('id'),
        'creatorName': sharedpref.getString('name'),
        'class': className,
        "type": widget.type,
      };

      if (widget.type == 'quiz') {
        data = {"options": options, "correctOptions": correctOptions, ...data};
      }
      print(data);
      var result = await provider.addWork(data);

      print(result);

      if (result['code'] == '200') {
        await provider.getWorks();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SHHomeScreen(widget.name),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar(
            content: result['message'].toString(),
          ),
        );
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _lastDate.text = (DateFormat('dd-MM-yyyy')
        .format(DateTime(dateNow.year, dateNow.month, dateNow.day + 1)));
    fetchClasses();
  }

  Future<void> fetchClasses() async {
    final SharedPreferences sharedpref = await SharedPreferences.getInstance();
    setState(() {
      classes = sharedpref.getStringList('classes')!;
    });
    print(classes);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _lastDate.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: LoadingOverlay(
        color: Colors.black,
        isLoading: isLoading,
        progressIndicator: Center(
          child: Container(
            color: Color(0xff6E7FFC),
            height: 130,
            width: 130,
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material(
                  color: Colors.transparent,
                  child: Text(
                    'Loading',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.025,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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
        child: Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              _submitted();
            },
            label: Text(
              widget.type == 'form'
                  ? ' Create Form'
                  : widget.type == 'ack'
                      ? 'Create Acknowledge'
                      : ' Create Quiz',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
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
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SHHomeScreen(widget.name),
                      ),
                    );
                  },
                ),
                centerTitle: true,
                title: Text(
                  widget.type == 'form'
                      ? ' Create Form'
                      : widget.type == 'quiz'
                          ? 'Create Quiz'
                          : ' Create Acknowledgement',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
                actions: [
                  widget.type != 'ack'
                      ? IconButton(
                          icon: Icon(Icons.add),
                          color: Colors.black,
                          onPressed: () async {
                            setState(() {
                              _count++;
                              isExpanded.add(true);
                              _radioType.add('Text');
                              _radioSelected.add(1);
                              required.add(true);

                              if (widget.type == 'quiz') {
                                options.add({
                                  "id": options.length,
                                  "options": ['', '', '', '']
                                });
                                correctOptions.add('');
                              }
                            });
                          },
                        )
                      : Material(),
                  IconButton(
                    color: Colors.black,
                    icon: Icon(Icons.refresh),
                    onPressed: () async {
                      setState(() {
                        _count = 0;
                        _result = '';
                        isExpanded = [];
                        _radioType = [];
                        _radioSelected = [];
                        required = [];

                        _values = [];
                      });
                    },
                  )
                ],
              ),
            ),
          ),
          body: Container(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 13.0, right: 13.0, bottom: 30.0),
                    child: TextFormField(
                      controller: _title,
                      decoration: TextFieldDecoration.copyWith(
                        hintText: 'Enter Title',
                      ),
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      children: [
                        Flexible(
                          child: TextFormField(
                            controller: _lastDate,
                            onTap: () {
                              _datePicker();
                            },
                            style: TextStyle(
                              fontSize: 16,
                            ),
                            focusNode: NoKeyboardEditableTextFocusNode(),
                            decoration: kTextFieldDecoration.copyWith(
                              contentPadding: EdgeInsets.only(
                                top: 10.0,
                                bottom: 10.0,
                                left: 15.0,
                              ),
                              suffixIcon: Icon(
                                Icons.calendar_today,
                                color: kPrimary,
                                size: 20,
                              ),
                              labelText: 'Last Date',
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              // color: Colors.white,
                              border: Border.all(
                                  color: kPrimary,
                                  style: BorderStyle.solid,
                                  width: 0.80),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                value: className,
                                items: classes.map((String item) {
                                  return DropdownMenuItem<String>(
                                    child: Text(item),
                                    value: item,
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    className = value.toString();
                                  });
                                },
                                hint: Text("Pick a Class"),
                                disabledHint: Text("Disabled"),
                                elevation: 8,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  size: 25,
                                ),
                                iconEnabledColor: Colors.black,
                                isExpanded: true,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _count,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: (widget.type != 'ack') ? 2 : 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: AnimatedContainer(
                          margin: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height * 0.01,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        decoration:
                                            TextFieldDecoration.copyWith(
                                          hintText: 'Enter Question',
                                        ),
                                        maxLines: null,
                                        keyboardType: TextInputType.multiline,
                                        onChanged: (val) {
                                          _onUpdate(
                                              index,
                                              val,
                                              _radioType[index],
                                              required[index]);
                                        },
                                      ),
                                    ),
                                    if (widget.type != 'ack')
                                      IconButton(
                                        icon: Icon(isExpanded[index]
                                            ? Icons.expand_less
                                            : Icons.expand_more),
                                        onPressed: () {
                                          setState(() {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            isExpanded[index] =
                                                !isExpanded[index];
                                          });
                                        },
                                      ),
                                  ],
                                ),
                                if (widget.type == 'quiz')
                                  AnimatedContainer(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    height: isExpanded[index] ? 350 : 0,
                                    duration: Duration(milliseconds: 400),
                                    child: isExpanded[index]
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      'A',
                                                      style: TextStyle(
                                                        fontSize: 19,
                                                        color:
                                                            Color(0xff2D5C78),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Flexible(
                                                      child: Container(
                                                        height: 45,
                                                        child: TextFormField(
                                                          decoration:
                                                              kTextFieldDecoration
                                                                  .copyWith(
                                                            hintText:
                                                                'Option A',
                                                          ),
                                                          maxLines: null,
                                                          initialValue: options[
                                                                  index]
                                                              ['options'][0],
                                                          keyboardType:
                                                              TextInputType
                                                                  .multiline,
                                                          onChanged: (val) {
                                                            options[index]
                                                                    ['options']
                                                                [0] = val;
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'B',
                                                      style: TextStyle(
                                                        fontSize: 19,
                                                        color:
                                                            Color(0xff2D5C78),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Flexible(
                                                      child: Container(
                                                        height: 45,
                                                        child: TextFormField(
                                                          decoration:
                                                              kTextFieldDecoration
                                                                  .copyWith(
                                                            hintText:
                                                                'Option B',
                                                          ),
                                                          maxLines: null,
                                                          initialValue: options[
                                                                  index]
                                                              ['options'][1],
                                                          keyboardType:
                                                              TextInputType
                                                                  .multiline,
                                                          onChanged: (val) {
                                                            options[index]
                                                                    ['options']
                                                                [1] = val;
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'C',
                                                      style: TextStyle(
                                                        fontSize: 19,
                                                        color:
                                                            Color(0xff2D5C78),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Flexible(
                                                      child: Container(
                                                        height: 45,
                                                        child: TextFormField(
                                                          decoration:
                                                              kTextFieldDecoration
                                                                  .copyWith(
                                                            hintText:
                                                                'Option C',
                                                          ),
                                                          maxLines: null,
                                                          initialValue: options[
                                                                  index]
                                                              ['options'][2],
                                                          keyboardType:
                                                              TextInputType
                                                                  .multiline,
                                                          onChanged: (val) {
                                                            options[index]
                                                                    ['options']
                                                                [2] = val;
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'D',
                                                      style: TextStyle(
                                                        fontSize: 19,
                                                        color:
                                                            Color(0xff2D5C78),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Flexible(
                                                      child: Container(
                                                        height: 45,
                                                        child: TextFormField(
                                                          decoration:
                                                              kTextFieldDecoration
                                                                  .copyWith(
                                                            hintText:
                                                                'Option D',
                                                          ),
                                                          maxLines: null,
                                                          initialValue: options[
                                                                  index]
                                                              ['options'][3],
                                                          keyboardType:
                                                              TextInputType
                                                                  .multiline,
                                                          onChanged: (val) {
                                                            options[index]
                                                                    ['options']
                                                                [3] = val;
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Correct Option',
                                                      style: TextStyle(
                                                        fontSize: 19,
                                                        color:
                                                            Color(0xff2D5C78),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Flexible(
                                                      child: Container(
                                                        height: 45,
                                                        child: TextFormField(
                                                          decoration:
                                                              kTextFieldDecoration
                                                                  .copyWith(
                                                            hintText: 'Option',
                                                          ),
                                                          maxLines: null,
                                                          keyboardType:
                                                              TextInputType
                                                                  .multiline,
                                                          onChanged: (val) {
                                                            correctOptions[
                                                                index] = val;
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        : null,
                                  ),
                                if (widget.type == 'form')
                                  AnimatedContainer(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    height: isExpanded[index] ? 120 : 0,
                                    duration: Duration(milliseconds: 400),
                                    child: isExpanded[index]
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 15),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .4,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        5.0),
                                                            child: Text(
                                                              'Type',
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        5.0),
                                                            child: Row(
                                                              children: [
                                                                Radio(
                                                                  value: 1,
                                                                  groupValue:
                                                                      _radioSelected[
                                                                          index],
                                                                  activeColor:
                                                                      Color(
                                                                          0xff0A662F),
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      _radioSelected[
                                                                              index] =
                                                                          int.parse(
                                                                              value.toString());
                                                                      _radioType[
                                                                              index] =
                                                                          'Text';
                                                                      _onUpdate(
                                                                          index,
                                                                          '',
                                                                          _radioType[
                                                                              index],
                                                                          required[
                                                                              index]);
                                                                    });
                                                                  },
                                                                ),
                                                                Text(
                                                                  'Text',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              isExpanded
                                                                  .removeAt(
                                                                      index);
                                                              _radioType
                                                                  .removeAt(
                                                                      index);
                                                              _radioSelected
                                                                  .removeAt(
                                                                      index);
                                                              required.removeAt(
                                                                  index);
                                                              if (_values
                                                                      .length >
                                                                  0) {
                                                                _values
                                                                    .removeAt(
                                                                        index);
                                                              }
                                                              _count--;
                                                            });
                                                          },
                                                          child: Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                .4,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Text(
                                                                  'Remove',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                Icon(
                                                                  Icons.delete,
                                                                  size: 25,
                                                                  color: Colors
                                                                      .redAccent,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 25,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                              'Required',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 20,
                                                            ),
                                                            FlutterSwitch(
                                                              width: 45.0,
                                                              height: 25.0,
                                                              valueFontSize:
                                                                  9.0,
                                                              toggleSize: 10.0,
                                                              value: required[
                                                                  index],
                                                              activeColor: Color(
                                                                  0xff0A662F),
                                                              borderRadius:
                                                                  30.0,
                                                              padding: 7.0,
                                                              showOnOff: true,
                                                              onToggle: (val) {
                                                                setState(() {
                                                                  required[
                                                                          index] =
                                                                      val;
                                                                  _onUpdate(
                                                                      index,
                                                                      '',
                                                                      _radioType[
                                                                          index],
                                                                      required[
                                                                          index]);
                                                                });
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        : null,
                                  )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _onUpdate(int index, String val, String type, bool required) async {
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
      "question": val,
      "type": type,
      "required": required
    };
    _values.add(json);
    setState(() {
      _result = _values.toString();
    });
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
