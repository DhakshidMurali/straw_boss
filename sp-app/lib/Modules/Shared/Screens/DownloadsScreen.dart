import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'dart:io' show Platform;

import 'package:share/share.dart';
import 'package:sp_app/Modules/Shared/Screens/DisplayPDF.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:io';
import 'package:native_pdf_renderer/native_pdf_renderer.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({Key? key}) : super(key: key);

  @override
  _DownloadsScreenState createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  @override
  void initState() {
    loadfiles();
    super.initState();
  }

  void loadfiles() async {
    await listfiles();
    await pdfrender();
  }

  // List<String> file = [
  //   '/storage/emulated/0/Android/data/com.example.project/files/COA.pdf',
  //   '/storage/emulated/0/Android/data/com.example.project/files/COA.pdf',
  //   '/storage/emulated/0/Android/data/com.example.project/files/COA.pdf',
  //   '/storage/emulated/0/Android/data/com.example.project/files/COA.pdf',
  //   '/storage/emulated/0/Android/data/com.example.project/files/COA.pdf'
  // ];
  List<FileSystemEntity> file_fetch = [];
  List<String> file_name = [];
  List<String> file_path = [];
  bool isloaded_pdf = false;
  Future listfiles() async {
    setState(() {
      file_fetch = Directory('/storage/emulated/0/Straw_Boss').listSync();
    });
    file_fetch.forEach((fileedit) {
      String extract = fileedit.toString().substring(
          fileedit.toString().indexOf('\u0027') + 1,
          fileedit.toString().lastIndexOf('\u0027'));
      file_path.add(extract);
    });
    file_fetch.forEach((fileedit) {
      String extract = fileedit.toString().substring(
          fileedit.toString().lastIndexOf('/') + 1,
          fileedit.toString().length - 1);
      file_name.add(extract);
    });
    print(file_path);
    print(pageimage.length);
    setState(() {});
  }

  List<PdfPageImage?> pageimage = [];
  PdfPageImage? pageImage;
  Future pdfrender() async {
    for (int i = 0; i < (file_path.length); i++) {
      final document = await PdfDocument.openFile((file_path[i]));
      print('page');
      final page = await document.getPage(1);
      pageImage = await page.render(
          backgroundColor: '#ffffff',
          width: (page.width * 0.5).toInt(),
          height: (page.height * 0.5).toInt());
      await page.close();
      pageimage.add(pageImage);
      if (pageimage.length == file_path.length) {
        futurebuilder();
        setState(() {});
      }
      print(pageimage.length);
    }
  }

  Widget futurebuilder() {
    return FutureBuilder(builder: (context, snapshot) {
      return ListView.builder(
          itemCount: file_path.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                setState(
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DisplayPDF(
                        url: 'asasas',
                        path: file_path[index],
                        name: file_name[index],
                        from: 'downloads',
                      ),
                    ),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Card(
                  elevation: 1,
                  margin: EdgeInsets.all(1),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      border: Border.all(
                        width: 0.5,
                        color: Colors.black,
                      ),
                    ),
                    margin: EdgeInsets.all(10),
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.24,
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: (pageimage.length != 0)
                                  ? Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          right: BorderSide(
                                            style: BorderStyle.solid,
                                            width: 0.5,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      height: 100,
                                      child: Image(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.1,
                                        image: MemoryImage(
                                            pageimage[index]!.bytes),
                                      ),
                                    )
                                  : Container(),
                            ),
                            Container(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.width *
                                        0.01,
                                    bottom: MediaQuery.of(context).size.width *
                                        0.001,
                                    left: MediaQuery.of(context).size.width *
                                        0.01),
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            file_name[index],
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.12,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              List<String> file_share = [];
                                              file_share.add(file_path[index]);
                                              await Share.shareFiles(
                                                file_share,
                                                text: 'file',
                                              );
                                              // selectFile();
                                            },
                                            child: Icon(
                                              Icons.share,
                                              size: 19,
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              elevation: 0,
                                              padding: EdgeInsets.all(0),
                                              primary: Color(0xff6E7FFC),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.12,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              showDialog<String>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        AlertDialog(
                                                  title: const Text(
                                                      'Are you sure to delete the material?'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child:
                                                          const Text('Cancel'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {
                                                        final file = File(
                                                            file_path[index]);
                                                        await file.delete();
                                                        file_fetch.clear();
                                                        file_name.clear();
                                                        file_path.clear();
                                                        pageimage.clear();
                                                        setState(() {
                                                          futurebuilder();
                                                          pdfrender();
                                                          listfiles();
                                                        });
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text('OK'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            child: Icon(
                                              Icons.delete,
                                              size: 19,
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              elevation: 0,
                                              padding: EdgeInsets.all(0),
                                              primary: Color(0xff6E7FFC),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (file_path.isNotEmpty)
          // body: (1 == 2)
          ? futurebuilder()
          : Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                          child: Center(
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/Download-cuate.svg',
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: MediaQuery.of(context).size.width * 0.5,
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              'NO downloads'.toUpperCase(),
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.02,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      )),
                    )
                  ],
                )
              ],
            ),
    );
  }
}
