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
