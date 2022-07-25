import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_tutor/constants.dart';
import 'package:intl/intl.dart';
import '../models/tutors.dart';

class tutorScreen extends StatefulWidget {
  const tutorScreen({Key? key}) : super(key: key);

  @override
  State<tutorScreen> createState() => _tutorsScreenState();
}

class _tutorsScreenState extends State<tutorScreen> {

  List<Tutor> tutorlist = <Tutor>[];
  String titlecenter = " ";
  String search = "";
  final df = DateFormat.yMd();
  var color;
  var numofpage, curpage = 1;
  TextEditingController searchctrl = TextEditingController();
  late double screenHeight, screenWidth, resWidth;

  @override
  void initState(){
    super.initState();
    _loadtutors(1, search);
  }

  @override
  Widget build(BuildContext context) {

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
      //rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      //rowcount = 3;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Subjects',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _loadSearchDialog();
            },
          ),
        ],
        backgroundColor: Colors.cyan
      ),

      body: tutorlist.isEmpty 
      ? Center(
          child: Text(titlecenter, 
            style: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold))) 
        : Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text("Tutor Available",
              style: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
                children: List.generate(tutorlist.length, (index) {
                  return InkWell(
                          splashColor: Colors.blue,
                          onTap: () => {_loadTutorDetails(index)},
                          child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                children: [
                                  Flexible(
                                    flex: 5,
                                    child: CachedNetworkImage(
                                      imageUrl: CONSTANTS.server +
                                          "/my_tutor/mobile/assets/tutors/" +
                                          tutorlist[index].tutorId.toString() +
                                          '.jpg',
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                            border: const Border(
                                              bottom: BorderSide(
                                                  color: Colors.black),
                                            ),
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.fitHeight,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                      Colors.white,
                                                      BlendMode.colorBurn),
                                            )),
                                      ),
                                      placeholder: (context, url) =>
                                          const LinearProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                  Text(
                                    tutorlist[index].tutorName.toString(),
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    softWrap: true,
                                  ),
                                  Text(
                                    tutorlist[index].tutorEmail.toString(),
                                    style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    softWrap: true,
                                  ),
                                  Text(
                                    tutorlist[index].tutorPhone.toString(),
                                    style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    softWrap: true,
                                  ),
                                ],
                              )),
                        );
                }
              )
            )
          ),
          SizedBox(
                height: 30,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: numofpage,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    if ((curpage - 1) == index) {
                      color = Colors.red;
                    } else {
                      color = Colors.black;
                    }
                    return SizedBox(
                      width: 40,
                      child: TextButton(
                          onPressed: () => {_loadtutors(index + 1, "")},
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(color: color),
                          )),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }

  void _loadtutors(int pageno, String _search) {
    curpage = pageno;
    numofpage ?? 1;
    print(_search);
    http.post(Uri.parse(CONSTANTS.server + "/my_tutor/mobile/php/load_tutor.php"),
      body: {
        'pageno' : pageno.toString(),
        'search': _search,
        }).timeout(
          const Duration(seconds: 5),
          onTimeout: (){
            titlecenter = "Timeout Please retry again later";
            return http.Response(
              'Error', 404
            );
      }
      ).then((response) {
        var jsondata = jsonDecode(response.body);
        print(jsondata);
        if(response.statusCode == 200 && jsondata['status'] == 'success') {
          var extractdata = jsondata['data'];
          if(extractdata['tutors'] != null){
            tutorlist = <Tutor>[];
            extractdata['tutors'].forEach((v) {
              tutorlist.add(Tutor.fromJson(v));
            });
          }
          setState(() {});
        }
      });
  }

  void _loadSearchDialog() {
    showDialog(
      context: context, 
      builder: (BuildContext context){
        return AlertDialog(
          title: const Text(
            "Search Subject",
            style: TextStyle(),
          ),
          content: SizedBox(
            child: Column(
              children: [
                TextField(
                  controller: searchctrl,
                  decoration: InputDecoration(
                    labelText: "Search",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)))
                ),
                ElevatedButton(
                  onPressed: () {
                    search = searchctrl.text;
                    Navigator.of(context).pop();
                    _loadtutors(1, search);
                    print(search);
                  },
                  child: const Text("Search")
                )
              ],
            ),
          ),
          actions: <Widget> [
            TextButton(
              child: const Text(
                "Close",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

          ],
        );
      }
    );
  }
  
  _loadTutorDetails(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: const Text(
                "Tutor Details",
                style: TextStyle(),
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    CachedNetworkImage(
                      imageUrl: CONSTANTS.server +
                          "/my_tutor/mobile/assets/tutors/" +
                          tutorlist[index].tutorId.toString() +
                          '.jpg',
                      fit: BoxFit.cover,
                      width: resWidth,
                      placeholder: (context, url) =>
                          const LinearProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    Text(
                                    tutorlist[index].tutorName.toString(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    softWrap: true,
                                  ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "\No Telephone: ",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          Text(tutorlist[index].tutorPhone.toString(),
                              style: const TextStyle(fontSize: 12)),
                          const Text(
                            "\nEmail: ",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          Text(tutorlist[index].tutorEmail.toString(),
                              style: const TextStyle(fontSize: 12)),
                          const Text(
                            "\nDescription: ",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          Text(tutorlist[index].tutorDescription.toString(),
                              style: const TextStyle(fontSize: 12)),
                          const Text(
                            "\nDate Registered: ",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          Text(
                              df.format(DateTime.parse(
                                  tutorlist[index].tutorDatereg.toString())),
                              style: const TextStyle(fontSize: 12)),
                        ]),
                  ],
                ),
                
              ),
              actions: <Widget> [
            TextButton(
              child: const Text(
                "Close",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

          ],);
        });
  }
}