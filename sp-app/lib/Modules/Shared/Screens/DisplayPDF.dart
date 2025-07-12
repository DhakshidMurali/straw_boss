import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:sp_app/Modules/Shared/Widgets/CustomSnackBar.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'dart:math' as math;
import 'package:share/share.dart';
import 'package:dio/dio.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';

class DisplayPDF extends StatefulWidget {
  final String url;
  final String name;
  final String path;
  final String from;
  DisplayPDF(
      {Key? key,
      required this.url,
      required this.name,
      required this.path,
      required this.from})
      : super(key: key);

  @override
  _DisplayPDFState createState() => _DisplayPDFState();
}

class _DisplayPDFState extends State<DisplayPDF>
    with SingleTickerProviderStateMixin {
  bool fileLoaded = false;
  PdfViewerController _controller = PdfViewerController();
  late PdfTextSearchResult _searchResult = PdfTextSearchResult();
  late TextEditingController _textEditingController = TextEditingController();
  bool isShare = true;
  bool isSearch = true;
  int searchIndex = 0;
  int searchCount = 0;
  bool search = false;
  int pageCount = 1;
  int start = 1;
  String progress = '';
  bool downloading = false;
  late SfRangeValues _pageNum = SfRangeValues(1, pageCount);
  late Permission permission;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LoadingOverlay(
          color: Colors.black,
          progressIndicator: Stack(
            children: [
              Center(
                child: Container(
                  height: 160,
                  width: 150,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                color: Colors.lightBlue,
                                height: 50,
                                width: 50,
                                child: Lottie.asset(
                                  'assets/animation/5679-download-ui-animation.json',
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 0.0),
                                child: Text(
                                  'Downloading\nfile'.toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
          isLoading: downloading,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 100.0, right: 30.0),
                child: (widget.from != 'downloads')
                    ? SfPdfViewer.network(
                        widget.url,
                        pageSpacing: 8,
                        onDocumentLoaded:
                            (PdfDocumentLoadedDetails details) async {
                          pageCount = details.document.pages.count;
                          setState(() => fileLoaded = true);
                        },
                        onPageChanged: (PdfPageChangedDetails details) async {
                          setState(() {
                            _pageNum =
                                SfRangeValues(details.newPageNumber, pageCount);
                            start = details.newPageNumber;
                          });
                        },
                        controller: _controller,
                        canShowScrollHead: false,
                        canShowScrollStatus: true,
                        canShowPaginationDialog: true,
                        enableDoubleTapZooming: true,
                        searchTextHighlightColor: Colors.lightBlue,
                      )
                    : SfPdfViewer.file(
                        File(widget.path),
                        pageSpacing: 8,
                        onDocumentLoaded:
                            (PdfDocumentLoadedDetails details) async {
                          pageCount = details.document.pages.count;
                          setState(() => fileLoaded = true);
                        },
                        onPageChanged: (PdfPageChangedDetails details) async {
                          setState(() {
                            _pageNum =
                                SfRangeValues(details.newPageNumber, pageCount);
                            start = details.newPageNumber;
                          });
                        },
                        controller: _controller,
                        canShowScrollHead: false,
                        canShowScrollStatus: true,
                        canShowPaginationDialog: true,
                        enableDoubleTapZooming: true,
                        searchTextHighlightColor: Colors.lightBlue,
                      ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * .13,
                right: MediaQuery.of(context).size.width * 0.1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: (pageCount != 1)
                        ? Text(
                            '$start/$pageCount',
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.035,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          )
                        : Text(
                            '1/1',
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.035,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey.withOpacity(.1),
                      elevation: 0,
                      padding: EdgeInsets.all(15.0),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.1,
                right: 10,
                bottom: 10,
                child: Container(
                    padding: EdgeInsets.only(bottom: 10.0, top: 40.0),
                    // height: MediaQuery.of(context).size.height * 0.1,
                    height: 100,
                    color: Colors.transparent,
                    width: 10,
                    child: Transform.rotate(
                      angle: -math.pi,
                      child: SfRangeSlider.vertical(
                          startThumbIcon: Icon(Icons.navigate_next),
                          activeColor: Colors.transparent,
                          inactiveColor: Colors.transparent,

                          //minorTicksPerInterval: 1,
                          min: pageCount == 1 ? 0 : 1,
                          max: pageCount,
                          interval: 1,
                          values: _pageNum,
                          onChanged: (dynamic values) {
                            setState(() {
                              _pageNum = values;
                              print(values);
                              String page = values.toString();
                              String start_Page =
                                  page.substring(26, 29).replaceAll('.', '');
                              start = int.parse(start_Page);
                              _controller.jumpToPage(start);
                            });
                          }),
                    )),
              ),
              fileLoaded
                  ? Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width * 1,
                      child: (isSearch == true && isShare == true)
                          ? SlideInLeft(
                              duration: Duration(milliseconds: 250),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        //color: Colors.indigo,
                                        child: Text(
                                          widget.name.toUpperCase(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.04,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            isSearch = false;
                                            setState(() {});
                                          },
                                          child: Icon(
                                            Icons.search,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        (widget.from != 'downloads')
                                            ? InkWell(
                                                onTap: () {
                                                  isShare = false;
                                                  setState(() {});
                                                },
                                                child: Icon(
                                                  Icons.share,
                                                  color: Colors.black,
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          : (isSearch == false && isShare == true)
                              ? SlideInRight(
                                  duration: Duration(milliseconds: 250),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            _searchResult.previousInstance();
                                            if (searchIndex == 1) {
                                              return setState(() {
                                                searchIndex = searchCount;
                                              });
                                            } else {
                                              searchIndex--;
                                              setState(() {});
                                            }
                                          },
                                          child: Icon(
                                            Icons.navigate_before,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Container(
                                          height: 40,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: TextField(
                                            showCursor: false,
                                            onSubmitted: (string) async {
                                              _searchResult =
                                                  (await _controller.searchText(
                                                      _textEditingController
                                                          .text));
                                              setState(() => isSearch = false);
                                              searchIndex = _searchResult
                                                  .currentInstanceIndex;
                                              searchCount = _searchResult
                                                  .totalInstanceCount;
                                              if (searchCount > 0) {
                                                search = true;
                                              }
                                            },
                                            onChanged: (string) async {
                                              if (string.length > 3) {
                                                _searchResult =
                                                    (await _controller.searchText(
                                                        _textEditingController
                                                            .text));
                                                setState(
                                                    () => isSearch = false);
                                                searchIndex = _searchResult
                                                    .currentInstanceIndex;
                                                searchCount = _searchResult
                                                    .totalInstanceCount;
                                                if (searchCount > 0) {
                                                  search = true;
                                                }
                                              }
                                            },
                                            controller: _textEditingController,
                                            decoration: InputDecoration(
                                              hintText: 'Search',
                                            ),
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            _searchResult.nextInstance();
                                            if (searchIndex == searchCount) {
                                              return setState(() {
                                                searchIndex = 1;
                                              });
                                            } else {
                                              searchIndex++;
                                              setState(() {});
                                            }
                                          },
                                          child: Icon(
                                            Icons.navigate_next,
                                            color: Colors.black,
                                          ),
                                        ),
                                        search
                                            ? Container(
                                                padding:
                                                    EdgeInsets.only(top: 12.0),
                                                height: 40,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.1,
                                                child: Text(
                                                  '$searchIndex / $searchCount',
                                                  style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.035,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black),
                                                ),
                                              )
                                            : SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.1,
                                              ),
                                        InkWell(
                                          onTap: () async {
                                            _searchResult =
                                                (await _controller.searchText(
                                                    'qwertyuiopasdfghjklzxcvbnm'));
                                            setState(() {
                                              search = false;
                                              isSearch = true;
                                              _textEditingController.text = '';
                                            });
                                            searchIndex = searchCount = 0;
                                          },
                                          child: Icon(
                                            Icons.cancel_sharp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : SlideInRight(
                                  duration: Duration(milliseconds: 250),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            setState(() => isShare = true);
                                          },
                                          child: Icon(
                                            Icons.navigate_before,
                                            color: Colors.black,
                                            size: 30,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                downloading = true;
                                                setState(() {});
                                                await downloadFile();
                                                downloading = false;
                                                setState(() {});
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  customSnackBar(
                                                      content:
                                                          'File has been downloaded successfully'),
                                                );
                                              },
                                              child: Icon(
                                                Icons.cloud_download_sharp,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 40,
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                await Share.share(widget.url);
                                              },
                                              child: Icon(
                                                Icons.share_sharp,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(.2),
                      ),
                    )
                  : Container(
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
                              Text(
                                'Loading',
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.025,
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
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> downloadFile() async {
    Dio dio = Dio();
    Directory? directory;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          print(widget.name);
          print(widget.url);
          directory = await getExternalStorageDirectory();
          String newPath = "";
          print(directory);
          List<String> paths = directory!.path.split("/");
          print(paths);
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          newPath = newPath + "/Straw_Boss";
          directory = Directory(newPath);
        } else {
          return false;
        }
      } else {
        if (await _requestPermission(Permission.photos)) {
          directory = await getTemporaryDirectory();
        } else {
          return false;
        }
      }
      print(directory);
      try {
        if (!await directory.exists()) {
          await directory.create(recursive: false);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar(content: 'Storage access has been denied!'),
        );
      }

      if (await directory.exists()) {
        File saveFile = File(directory.path + '/' + widget.name);
        print(saveFile.path);
        await dio.download(widget.url, saveFile.path,
            onReceiveProgress: (value1, value2) {
          setState(() {
            progress = (value1 / value2).toString();
            print(progress);
          });
        });
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }
}
