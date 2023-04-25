import 'dart:html';

import 'package:bloodpressure/addform.dart';
import 'package:bloodpressure/pressureclass.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
      home: const MyHomePage(title: 'Blood Pressure History'),
    );
  }



}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final List<PressureClass> _listItems = List.empty(growable: true);

  Future<void> _callAddForm() async {
    
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddForm()));

    setState(() {
      if(result != null)
      {
        _listItems.add(result);
      }
    });
  }


  List<Widget> getList()
  {

    List<Widget> items = List.empty(growable: true);
    PressureClass? resultItem = null;

    if(_listItems.isNotEmpty)
    {
          var width = MediaQuery.of(context).size.width / 100.0;
         _listItems.forEach((item) {
            items.add(
                        Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                const Icon(Icons.timelapse),
                                SizedBox(width: width * 0.5,),
                                Text("일시 : ${item.time}"),
                                SizedBox(width: width * 4,),
                                Text("수축기(높은값) : ${item.high}"),
                                SizedBox(width: width * 4,),
                                Text("이완기(낮은값) : ${item.low}"),
                                IconButton(onPressed: () async => 
                                {  
                                   resultItem = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddForm(historyItem:item))), 
                                   if(resultItem != null)
                                   {
                                    setState(() {
                                         item.high = resultItem!.high;
                                          item.low = resultItem!.low;
                                    })
                                   }
                                  }, 
                                icon: const Icon(Icons.edit),),
                                IconButton(onPressed: () => 
                                {                                 
                                  setState(() {
                                      _listItems.remove(item);
                                    })
                                }, 
                                icon: const Icon(Icons.delete),),
                                ],
                                )

                                    
                        );
                
          });
    }
    else
    {
         items.add(
          Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: (MediaQuery.of(context).size.height / 100) * 10,),
              const Text("Empty"),
          ],)
          );
    }      

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
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: SafeArea(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: 
        ListView(
          children: 
          getList(),)
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _callAddForm,
        tooltip: 'Add History',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}