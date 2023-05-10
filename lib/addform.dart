

import 'package:bloodpressure/pressureclass.dart';
import 'package:flutter/material.dart';

class AddForm extends StatefulWidget
{

  PressureClass? historyItem;
  var inputMax = "";
  var inputMin = "";

  AddForm(
    {super.key,this.historyItem});

  TextEditingController controller1  = TextEditingController();
  TextEditingController controller2 = TextEditingController();

  @override
  State<AddForm> createState() => _AddFromState();
}

class _AddFromState extends State<AddForm>
{

@override
  Widget build(BuildContext context) {

    DateTime now = DateTime.now();
    String time = "${now.year.toString()}년${now.month.toString()}월${now.day}일 ${now.hour.toString()}:${now.minute.toString()}분";
    String createTime = "${now.year.toString()}${now.month.toString()}${now.day}${now.hour.toString()}${now.minute.toString()}";
    String high = "";
    String low = "";

    if(widget.historyItem != null)
    {
      time = widget.historyItem!.time;
      high = widget.historyItem!.high;
      low = widget.historyItem!.low;  
      createTime = widget.historyItem!.createtime;
    }

    var heightValue = MediaQuery.of(context).size.height / 100.0;
    var widthValue = MediaQuery.of(context).size.width / 100.0;

    if(widget.inputMax.isEmpty)
    {
        widget.inputMax = high;     
    }
      
    if(widget.inputMin.isEmpty)
    {
        widget.inputMin = low;     
    }

    widget.controller1.text =  widget.inputMax;
    widget.controller2.text = widget.inputMin;


    return Material(
      child:  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("시간 : $time"),
        Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [
           
            SizedBox(width: widthValue * 30,
                    child:  GestureDetector(onTap: () => FocusScope.of(context).unfocus(),
                            child:TextField(decoration: const InputDecoration(hintText: "정상 : 120 미만", labelText: "수축기(높은수치) : "),
                            onChanged: (text) => { widget.inputMax = text},
                            keyboardType: TextInputType.number,
                            controller: widget.controller1,
                            ),
                            ),
                            ),
           
            SizedBox(width: widthValue * 10,),

            SizedBox(width: widthValue * 30,
                    child: GestureDetector(onTap: () => FocusScope.of(context).unfocus(),
                            child:TextField(decoration: const InputDecoration(hintText: "정상 : 80 미만", labelText: "이완기(낮은수치) : "),
                            onChanged: (text) => { widget.inputMin = text},
                            keyboardType: TextInputType.number,
                            controller: widget.controller2,
                            ),
                            ),
                            ),
              
           
            
        ],
        ),  
        SizedBox(height: heightValue * 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 100,height: 100, child: IconButton(onPressed: () 
            {
              if(widget.inputMax.isEmpty || widget.inputMin.isEmpty)
              {
                Navigator.pop(context);
              }
              else
              {
                Navigator.pop(context,PressureClass(time,widget.inputMax,widget.inputMin,createTime)); 
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