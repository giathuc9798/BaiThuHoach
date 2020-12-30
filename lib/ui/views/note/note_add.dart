import 'package:flutter/material.dart';
import 'package:mynote/ui/views/note/note_model.dart';



class Note1 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Thêm ghi chú mới'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              
              TextField(
                decoration: InputDecoration(hintText: 'Tiêu đề'),
              ),
              TextField(
                decoration: InputDecoration(hintText: 'Nội dung'),
              ),
              Container(height: 20.0,),
              Row(
                children: <Widget>[
                  _Notebutton('Lưu',Colors.blue,(){
                    Navigator.pop(context);
                  }), 
                ]
              ),
            ],
          ),
        ));
  }
}

class _Notebutton extends StatelessWidget {

  final String _text;
  final Color _color;
  final Function _onPressed;

  _Notebutton(this._text, this._color, this._onPressed);

  @override

  Widget build(BuildContext context) {
    return  MaterialButton(
                    onPressed: _onPressed,
                    child: Text(_text,
                    style: TextStyle(color: Colors.white),
                    ), 
                    height: 60,
                    minWidth: 100,
                    color: _color,
                  );
  }
}