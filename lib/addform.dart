

import 'package:bloodpressure/pressureclass.dart';
import 'package:flutter/material.dart';

class AddForm extends StatelessWidget
{

  PressureClass? historyItem;

  AddForm({super.key,this.historyItem});

  @override
  Widget build(BuildContext context) {

    DateTime now = DateTime.now();
    String time = "${now.year.toString()}년${now.month.toString()}월${now.day}일 ${now.hour.toString()}:${now.minute.toString()}분";
    String high = "";
    String low = "";


    if(historyItem != null)
    {
      time = historyItem!.time;
      high = historyItem!.high;
      low = historyItem!.low;      
    }

    var heightValue = MediaQuery.of(context).size.height / 100.0;
    var widthValue = MediaQuery.of(context).size.width / 100.0;

    var inputMax = high;
    var inputMin = low;

    return Material(
      child:  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("시간 : $time"),
        Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [
           
            SizedBox(width: widthValue * 30,
                    child:  TextField(decoration: const InputDecoration(hintText: "정상 : 120 미만", labelText: "수축기(높은수치) : "),
                            onChanged: (text) => { inputMax = text},
                            keyboardType: TextInputType.number,
                            controller: TextEditingController(text:high),
                            ),),
            SizedBox(width: widthValue * 10,),

            SizedBox(width: widthValue * 30,
                    child: TextField(decoration: const InputDecoration(hintText: "정상 : 80 미만", labelText: "이완기(낮은수치) : "),
                            onChanged: (text) => { inputMin = text},
                            keyboardType: TextInputType.number,
                            controller: TextEditingController(text:low),
                            ),),
              
           
            
        ],
        ),  
        SizedBox(height: heightValue * 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 100,height: 100, child: IconButton(onPressed: () 
            {
              if(inputMax.isEmpty || inputMin.isEmpty)
              {
                Navigator.pop(context);
              }
              else
              {
                Navigator.pop(context,PressureClass(time,inputMax,inputMin)); 
              }
            }, icon: const Icon(Icons.check_circle,size: 50,)),),
            SizedBox(width: 100,height: 100, child: IconButton(onPressed: () {Navigator.pop(context);}, icon: const Icon(Icons.cancel,size: 50,)),),
          ],
        )
       
        ],
      ),
    );  
  }

}