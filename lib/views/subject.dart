import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_tutor/constants.dart';
import '../models/subjects.dart';
import 'addsubject.dart';

class subjectScreen extends StatefulWidget {
  const subjectScreen({Key? key}) : super(key: key);

  @override
  State<subjectScreen> createState() => _subjectScreenState();
}

class _subjectScreenState extends State<subjectScreen> {

  List<Subject> subjectlist = <Subject>[];
  String titlecenter = " ";
  String search = "";
  var color;
  var numofpage, curpage = 1; 
  TextEditingController searchctrl = TextEditingController();
  late double screenHeight, screenWidth, resWidth;

  @override
  void initState(){
    super.initState();
    _loadsubjects(1, search);
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

      body: subjectlist.isEmpty 
      ? Center(
          child: Text(titlecenter, 
            style: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold))) 
        : Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text("Subjects",
              style: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
                children: List.generate(subjectlist.length, (index) {
                  return Card(
                    child: Column(
                      children: [
                        Flexible(flex: 6,
                        child: CachedNetworkImage(
                          imageUrl: CONSTANTS.server + "/my_tutor/mobile/assets/courses/" + 
                          subjectlist[index]
                          .subjectId
                          .toString() + '.jpg',
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
                          const Icon(Icons.error),),
                        ),
                        Flexible(flex:4, child: Column(
                          children: [
                            Text(
                                    subjectlist[index].subjectName.toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    softWrap: true,
                                  ),
                            
                          ],
                        ))
                      ],
                    )
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
                          onPressed: () => {_loadsubjects(index + 1, "")},
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (content) => addsubject()));
        },
        label: const Text('Add Subject'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.cyan,
      ),
    );
  }

  void _loadsubjects(int pageno, String _search) {
    curpage = pageno;
    numofpage ?? 1;
    print(_search);
    http.post(Uri.parse(CONSTANTS.server + "/my_tutor/mobile/php/load_subjects.php"),
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
          },
        ).then((response) {
        var jsondata = jsonDecode(response.body);

        print(jsondata);
        if(response.statusCode == 200 && jsondata['status'] == 'success') {
          var extractdata = jsondata['data'];
          if(extractdata['subjects'] != null){
            subjectlist = <Subject>[];
            extractdata['subjects'].forEach((v) {
              subjectlist.add(Subject.fromJson(v));
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
                    _loadsubjects(1, search);
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
}