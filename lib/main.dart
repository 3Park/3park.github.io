import 'package:bloodpressure/addform.dart';
import 'package:bloodpressure/chartform.dart';
import 'package:bloodpressure/pressureclass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final Future<FirebaseApp> _initialization =
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Blood Pressure',
            theme: ThemeData(
              // This is the theme of your application.
              //
              // Try running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the primarySwatch below to Colors.green and then invoke
              // "hot reload" (press "r" in the console where you ran "flutter run",
              // or simply save your changes to "hot reload" in a Flutter IDE).
              // Notice that the counter didn't reset back to zero; the application
              // is not restarted.
              primarySwatch: Colors.blue,
            ),
            home: MyHomePage(title: 'Blood Pressure History'),
          );
        }
        return MaterialApp(
          title: 'Blood Pressure',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blue,
          ),
          home: const Text('Loading...'),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  bool isHighChecked = false;
  bool isLowChecked = false;
  int correction = 0;
  TextEditingController controller1 = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<PressureClass> _listItems = List.empty(growable: true);

  String totalText = "";
  String highText = "";
  String lowText = "";
  String overNormalText = "";

  Future<void> _callAddForm() async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddForm()));

    setState(() {
      if (result != null) {
        _addDataToFireStore(result);
        _listItems.add(result);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getDataFromCloudFireStore();
  }

  Future<void> _getDataFromCloudFireStore() async {
    CollectionReference collections =
        FirebaseFirestore.instance.collection('history');

    var histories = await collections
        .where("member", isEqualTo: "park")
        .where("createtime", isNull: false)
        .orderBy("createtime")
        .get();

    if (histories == null ||
        histories.docs == null ||
        histories.docs.length <= 0)
      print("data null");
    else {
      histories.docs.forEach((item) {
        PressureClass temp = PressureClass(
            item["date"], item["high"], item["low"], item["createtime"]);
        setState(() {
          _listItems.add(temp);
        });
      });
    }

    _calcDataInformation();
    // var a = await temp.doc('4umFcKeIvP6ZvQvyT6Y0').get();
    // var b = a.data() as Map<String,dynamic>;
    // print(b["member"].toString());
  }

  Future<void> _getDataFromCloudFireStoreWithFind(
      bool isHighChecked, bool isLowChecked, int correction) async {
    _listItems.clear();

    CollectionReference collections =
        FirebaseFirestore.instance.collection('history');

    var histories = await collections
        .where("member", isEqualTo: "park")
        .where("createtime", isNull: false)
        .orderBy("createtime")
        .get();

    if (histories == null ||
        histories.docs == null ||
        histories.docs.length <= 0)
      print("data null");
    else {
      for (var item in histories.docs) {
        if (isHighChecked &&
            isLowChecked &&
            (item["high"] < 135 - correction &&
                item["low"] < 85 - correction)) {
          continue;
        } else if (isHighChecked == false &&
            isLowChecked &&
            item["low"] < 85 - correction) {
          continue;
        } else if (isHighChecked &&
            isLowChecked == false &&
            item["high"] < 135 - correction) {
          continue;
        }

        PressureClass temp = PressureClass(
            item["date"], item["high"], item["low"], item["createtime"]);
        setState(() {
          _listItems.insert(0, temp);
        });
      }
    }

    _calcDataInformation();
  }

  void _calcDataInformation() {
    if (_listItems == null || _listItems.isEmpty) {
      setState(() {
        totalText = "";
        highText = "";
        lowText = "";
      });
    } else {
      int totalcnt = _listItems.length;
      int sumhigh = 0;
      int sumlow = 0;

      int overNormalHigh = 0;
      int overNormalLow = 0;

      String avrHigh = "";
      String avrLow = "";

      int lowestHigh = _listItems.first.high;
      int highestHigh = _listItems.first.high;
      int lowestLow = _listItems.first.low;
      int highestLow = _listItems.first.low;

      for (var item in _listItems) {
        sumhigh = sumhigh + item.high;
        sumlow = sumlow + item.low;

        if (lowestHigh > item.high) {
          lowestHigh = item.high;
        }

        if (highestHigh < item.high) {
          highestHigh = item.high;
        }

        if (lowestLow > item.low) {
          lowestLow = item.low;
        }

        if (highestLow < item.low) {
          highestLow = item.low;
        }

        if(item.high >= 120)
        {
          overNormalHigh++;
        }

        if(item.low >= 80)
        {
          overNormalLow++;
        }
      }

      avrHigh = (sumhigh / totalcnt).toStringAsFixed(1);
      avrLow = (sumlow / totalcnt).toStringAsFixed(1);

      setState(() {
        totalText = "전체 총 개수 : $totalcnt";
        highText = "수축기 최고 : $highestHigh,  최저 : $lowestHigh  , 평균 : $avrHigh";
        lowText = "이완기 최고 : $highestLow,  최저 : $lowestLow  , 평균 : $avrLow";
        overNormalText = "수축기 120 이상 : $overNormalHigh 건, 이완기 80이상 : $overNormalLow 건";
      });
    }
  }

  void _addDataToFireStore(PressureClass item) {
    if (item == null) {
      return;
    }

    FirebaseFirestore.instance.collection('history').add({
      "createtime": item.createtime,
      "date": item.time,
      "high": item.high,
      "low": item.low,
      "member": "park"
    });

    _calcDataInformation();
  }

  Future<void> _updateDeleteFireStoreData(
      PressureClass item, bool isModify) async {
    if (item == null) {
      return;
    }

    CollectionReference collections =
        FirebaseFirestore.instance.collection('history');

    var histories = await collections
        .where("member", isEqualTo: "park")
        .where("createtime", isEqualTo: item.createtime)
        .get();
    if (histories == null ||
        histories.docs == null ||
        histories.docs.length <= 0) {
      return;
    }

    if (isModify) {
      collections
          .doc(histories.docs.first.id)
          .update({"high": item.high, "low": item.low});
    } else {
      collections.doc(histories.docs.first.id).delete();
    }

    _calcDataInformation();
  }

  List<Widget> getList() {
    List<Widget> items = List.empty(growable: true);
    PressureClass? resultItem = null;

    if (_listItems.isNotEmpty) {
      var width = MediaQuery.of(context).size.width / 100.0;
      _listItems.forEach((item) {
        items.insert(
          0,
          Container(
            decoration: BoxDecoration(
              border:
                  Border.all(color: Colors.black12, style: BorderStyle.solid),
            ),
            margin: const EdgeInsets.only(bottom: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.timelapse),
                    SizedBox(
                      width: width * 0.5,
                    ),
                    Text("일시 : ${item.time}"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: width * 4,
                    ),
                    FittedBox(
                      child: Text("수축기(높은값) : ${item.high}"),
                    ),
                    SizedBox(
                      width: width * 4,
                    ),
                    FittedBox(
                      child: Text("이완기(낮은값) : ${item.low}"),
                    ),
                    IconButton(
                      onPressed: () async => {
                        resultItem = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AddForm(historyItem: item))),
                        if (resultItem != null)
                          {
                            setState(() {
                              item.high = resultItem!.high;
                              item.low = resultItem!.low;

                              _updateDeleteFireStoreData(item, true);
                            })
                          }
                      },
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () => {
                        setState(() {
                          _listItems.remove(item);

                          _updateDeleteFireStoreData(item, false);
                        })
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      });
    } else {
      items.add(Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: (MediaQuery.of(context).size.height / 100) * 10,
          ),
          const Text("Empty"),
        ],
      ));
    }

    _calcDataInformation();

    return items;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    widget.controller1.text = widget.correction.toString();

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: SafeArea(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text("검색 조건 설정"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.only(bottom: 10.0, top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('135 이상 '),
                    Checkbox(
                      value: widget.isHighChecked,
                      onChanged: (selected) {
                        setState(() {
                          if (selected == null) {
                            widget.isHighChecked = false;
                          } else {
                            widget.isHighChecked = selected;
                          }
                        });
                      },
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    const Text('85 이상 '),
                    Checkbox(
                        value: widget.isLowChecked,
                        onChanged: (selected) {
                          setState(() {
                            if (selected == null) {
                              widget.isLowChecked = false;
                            } else {
                              widget.isLowChecked = selected;
                            }
                          });
                        }),
                    const SizedBox(
                      width: 30,
                    ),
                    SizedBox(
                      width: 60,
                      child: GestureDetector(
                        onTap: () => FocusScope.of(context).unfocus(),
                        child: TextField(
                          decoration: const InputDecoration(
                              hintText: "", labelText: "오차값 : "),
                          onChanged: (text) =>
                              {widget.correction = int.parse(text)},
                          keyboardType: TextInputType.number,
                          controller: widget.controller1,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => {
                        setState(() {
                          _getDataFromCloudFireStoreWithFind(
                              widget.isHighChecked,
                              widget.isLowChecked,
                              widget.correction);
                        })
                      },
                      icon: const Icon(Icons.search),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Text(totalText),
          Text(highText),
          Text(lowText),
          Text(overNormalText),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () => {
                    if (_listItems != null && _listItems.isEmpty == false)
                      {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChartForm(originList: _listItems),
                            ))
                      }
                  },
              child: const Text("차트 확인")),
          // SizedBox(width: 150,
          // child: Container(alignment: Alignment.center,
          //             decoration: BoxDecoration(
          //               border:
          //                   Border.all(color: Colors.black12, style: BorderStyle.solid),
          //             ),
          //             child: Row(children: [
          //                 const Text("분석 정보 확인"),
          //                    IconButton(icon: const Icon(Icons.edit_document),
          //               onPressed: () => {

          //               },
          //               ),
          //               ],
          //                ),
          //             ),),

          SizedBox(
            height: (MediaQuery.of(context).size.width / 100) * 2,
          ),
          SizedBox(
            width: (MediaQuery.of(context).size.width / 100) * 90,
            height: (MediaQuery.of(context).size.height / 100) * 50,
            child: ListView(
              reverse: true,
              controller: widget.scrollController,
              children: getList(),
            ),
          ),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: _callAddForm,
        tooltip: 'Add History',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
