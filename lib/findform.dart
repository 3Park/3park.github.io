import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FindForm extends StatefulWidget
{
  FindForm({super.key});

  bool isHighChecked = false;
  bool isLowChecked = false;

  @override
  State<StatefulWidget> createState() {
    return FindFormState();
  }

}

class FindFormState extends State<FindForm>
{
  @override
  Widget build(BuildContext context) {
     return Scaffold(body: 
        Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("검색 조건 설정"),
          Container(alignment: Alignment.topCenter,
          padding: const EdgeInsets.only(bottom: 10.0, top: 20.0),
          child: 
             Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('135 이상 '),
                Checkbox(value: widget.isHighChecked, onChanged: (selected) { setState(() {
                  if(selected == null)
                  {
                      widget.isHighChecked = false;
                  }
                  else
                  {
                     widget.isHighChecked = selected;
                  }                    
                });  }, ),
                const SizedBox(width: 20.0,),
                const Text('85 이상 '),
                Checkbox(value: widget.isLowChecked, onChanged: (selected) { 
                  
                  setState(() {
                    if(selected == null)
                    {
                        widget.isLowChecked = false;
                    }
                    else
                    {
                      widget.isLowChecked = selected;
                    }     
                  });
                 }),
          ],),
          ),  
          IconButton(onPressed: () {
              Navigator.pop(context);
          }, icon: const Icon(Icons.search),)       
        ],)
     
     );
  }

}