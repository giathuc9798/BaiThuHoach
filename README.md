# Bài Thu Hoạch

Bài thu hoạch môn lập trình ứng dụng di động

Link bài làm : [Bài thu hoạch](https://github.com/giathuc9798/BaiThuHoach)

## Bắt đầu

### 1.Thiết lập from đăng nhập

Ứng dụng firebase để đăng nhập với google

- Đầu tiên chúng ta cần phải sử dụng tài khoản google để đăng nhập vào tạo project trên firebase
- Sau đó chúng ta kích hoạt phương thức đăng nhập với google như hình dưới
![kích hoạt đăng nhập google](\lib\pic\1.jpg)

- Tiếp theo chúng ta tạo phương thức đăng nhập cho android
- ![tạo app đăng nhập](\lib\pic\2.jpg)

- sau đó chúng ta tải file google-services.json về và thêm vào bài làm của chúng ta

#### Giao diện from login

![Giao diện from login](\lib\pic\Login_UI.jpg)

### login.dart

```dart
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mynote/ui/views/note/note_view.dart';


class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
  
}


class _MyAppState extends State<Login> {
  bool _isLoggedIn = false;

  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  _login() async{
    try{
      await _googleSignIn.signIn();
      setState(() {
        _isLoggedIn = true;
      });
    } catch (err){
      print(err);
    }
  }

  _logout(){
    _googleSignIn.signOut();
    setState(() {
      _isLoggedIn = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading:
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NoteView()),
                )
              },
            )
          ,
        ),
        body: Center(
            child: _isLoggedIn
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Welcome'),
                      Text(_googleSignIn.currentUser.displayName),
                      OutlineButton( child: Text("logout"), onPressed: (){
                        _logout();
                      
                      },
                      )
                    ],
                  )
                : Center(
                    child: OutlineButton(
                      child: Text("Login with Google"),
                      onPressed: () {
                        _login();
                      },
                    ),
                  )),
      ),
    );
  }
}
```

### Để sử dụng dịch vụ đăng nhập với google chúng ta cần thêm vào file pubspec.yaml như sau

```dart
google_sign_in: ^4.5.6
```

### flie pubspec.yaml sau khi thêm

```dart
name: mynote
description: A new Flutter project.


publish_to: 'none' # Remove this line if you wish to publish to pub.dev


version: 1.0.0+1

environment:
  sdk: ">=2.7.0 <3.0.0"

dependencies:
  flutter:
    sdk: flutter
  google_sign_in: ^4.5.6


  
  cupertino_icons: ^1.0.0

  stacked:
  sqflite:

dev_dependencies:
  flutter_test:
    sdk: flutter
flutter:

  uses-material-design: true
```

### thêm vào đó chúng ta cần phải điều chỉnh trong file build.gradle

### Hình ảnh sau khi đăng nhập

![Nhập tài khoản mật khẩu ](\lib\pic\4.jpg)

![Nhập mã xác nhận bước 2](\lib\pic\5.jpg)

![Đăng nhập thành công](\lib\pic\6.jpg)

### Thêm ghi chú mới

![thêm ghi chú](\lib\pic\add.jpg)

### Danh sách ghi chú vừa thêm

![Danh sách](\lib\pic\list.jpg)

### Chỉnh sửa ghi chú

![chỉnh sửa ghi chú](\lib\pic\edit.jpg)

### giao diện thêm ghi chú

```dart
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
```

### note_view.dart

```dart
import 'package:flutter/material.dart';
import 'package:mynote/ui/views/note/note_add.dart';
import 'login.dart';
import 'package:mynote/ui/views/note/widgets/note_view_item.dart';
import 'package:mynote/ui/views/note/widgets/note_view_item_edit.dart';
import 'package:stacked/stacked.dart';

import 'note_viewmodel.dart';
import 'note_model.dart';

class NoteView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NoteViewModel>.reactive(
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text(model.title),
          actions: [
            IconButton(
              icon: Icon(Icons.login),
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                )
              },
            )
          ],
        ),
        body: Stack(
          children: [
            model.state == NoteViewState.listView
                ? ListView.builder(
                    itemCount: model.items.length,
                    itemBuilder: (BuildContext context, int index) {
                      Note item = model.items[index];
                      return ListTile(
                        title: Text(item.title),
                        subtitle: Text(item.desc),
                        onTap: () {
                          model.editingItem = item;
                          model.state = NoteViewState.itemView;
                        },
                      );
                    },
                  )
                : model.state == NoteViewState.itemView
                    ? NoteViewItem()
                    : model.state == NoteViewState.updateView
                        ? NoteViewItemEdit()
                        : SizedBox(),
          ],
        ),
        floatingActionButton:FloatingActionButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Note1()));
        },
        child: Icon(Icons.add),)
      ),
      viewModelBuilder: () => NoteViewModel(),
    );
  }
}

```

### note_viewmodel.dart

```dart
import 'package:flutter/material.dart';
import 'package:mynote/ui/views/note/note_repository.dart';
import 'package:stacked/stacked.dart';

import 'note_model.dart';

/// Trạng thái của view
enum NoteViewState { listView, itemView, insertView, updateView }

class NoteViewModel extends BaseViewModel {
  final title = 'Note View Model';

  /// Danh sách các bản ghi được load bất đồng bộ bên trong view model,
  /// khi load thành công thì thông báo đến view để cập nhật trạng thái
  var _items = <Note>[];

  /// ### Danh sách các bản ghi dùng để hiển thị trên ListView
  /// Vì quá trình load items là bất đồng bộ nên phải tạo một getter
  /// `get items => _items` để tránh xung đột
  List<Note> get items => _items;

  /// Trạng thái mặc định của view là listView, nó có thể thay đổi
  /// bên trong view model
  var _state = NoteViewState.listView;

  /// Khi thay đổi trạng thái thì sẽ báo cho view biết để cập nhật
  /// nên cần tạo một setter để vừa nhận giá trị vừa thông báo đến view
  set state(value) {
    // Cập nhật giá trị cho biến _state
    _state = value;

    // Thông báo cho view biết để cập nhật trạng thái của widget
    notifyListeners();
  }

  /// Cần có một getter để lấy ra trạng thái view cục bộ cho view
  NoteViewState get state => _state;

  Note editingItem;

  var editingControllerTitle = TextEditingController();
  var editingControllerDesc = TextEditingController();

  ///
  var repo = NoteRepository();

  Future init() async {
    return reloadItems();
  }

  Future reloadItems() async {
    return repo.items().then((value) {
      _items = value;
      notifyListeners();
    });
  }

  void addItem() {
    var title = editingControllerTitle.text;
    var desc = editingControllerDesc.text;
    var item = Note(title, desc);
    repo.insert(item).then((value) {
      reloadItems();
    });
  }

  void updateItem() {
    editingControllerTitle.text = editingItem.title;
    editingControllerDesc.text = editingItem.desc;
    state = NoteViewState.updateView;
  }

  void saveItem() {
    // TODO lưu editingItem

    // TODO editingItem = null
    editingItem = null;
    notifyListeners();
  }
}

```
