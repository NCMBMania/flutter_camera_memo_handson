import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:ncmb/ncmb.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  NCMB(dotenv.env['APPLICATION_KEY'] as String,
      dotenv.env['CLIENT_KEY'] as String);
  var user = await NCMBUser.currentUser();
  if (user == null) {
    NCMBUser.loginAsAnonymous();
  }
  runApp(const CameraMemoApp());
}

class CameraMemoApp extends StatelessWidget {
  const CameraMemoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'カメラメモアプリ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _tab = [
    const Tab(text: 'アップロード', icon: Icon(Icons.photo)),
    const Tab(text: 'メモ', icon: Icon(Icons.list)),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tab.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('メモアプリ'),
          bottom: TabBar(
            tabs: _tab,
          ),
        ),
        body: const TabBarView(children: [
          FormPage(),
          ListPage(),
        ]),
      ),
    );
  }
}

class FormPage extends StatefulWidget {
  const FormPage({
    Key? key,
  }) : super(key: key);
  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  Uint8List? _image;
  final picker = ImagePicker();
  String _text = '';
  String? _extension;
  TextEditingController? _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: _text);
  }

  Future<void> _save() async {
    var fileName = "${const Uuid().v4()}.$_extension";
    var acl = NCMBAcl();
    var user = await NCMBUser.currentUser();
    acl.setUserReadAccess(user!, true);
    acl.setUserWriteAccess(user, true);
    await NCMBFile.upload(fileName, _image, acl: acl);
    var obj = NCMBObject('Memo');
    obj.sets({'text': _text, 'fileName': fileName, 'acl': acl});
    await obj.save();
    done();
  }

  void done() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text('保存完了'),
          content: const Text('メモを保存しました'),
          actions: [
            TextButton(
                onPressed: () {
                  setState(() {
                    _text = '';
                    _image = null;
                    _textEditingController!.text = _text;
                  });
                  Navigator.pop(context);
                },
                child: const Text('OK'))
          ],
        );
      },
    );
  }

  Future<void> _selectPhoto() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    var image = await pickedFile.readAsBytes();
    setState(() {
      _extension = pickedFile.mimeType!.split('/')[1];
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Spacer(),
          const Text(
            '写真を選択して、メモを入力してください',
          ),
          _image != null
              ? GestureDetector(
                  child: Container(
                    child: Image.memory(_image!),
                    height: 200,
                  ),
                  onTap: _selectPhoto,
                )
              : IconButton(
                  iconSize: 200,
                  icon: const Icon(
                    Icons.photo,
                    color: Colors.blue,
                  ),
                  onPressed: _selectPhoto,
                ),
          Container(
            width: 300,
            child: TextFormField(
              controller: _textEditingController,
              enabled: true,
              style: const TextStyle(color: Colors.black),
              maxLines: 5,
              onChanged: (text) {
                setState(() {
                  _text = text;
                });
              },
            ),
          ),
          const Spacer(),
          ElevatedButton(onPressed: _save, child: const Text('保存')),
          const Spacer(),
        ],
      ),
    );
  }
}

class ListPage extends StatefulWidget {
  const ListPage({
    Key? key,
  }) : super(key: key);
  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<NCMBObject> _memos = [];
  @override
  void initState() {
    super.initState();
    getMemos();
  }

  Future<void> getMemos() async {
    var query = NCMBQuery('Memo');
    query.limit(100);
    var ary = await query.fetchAll();
    setState(() {
      _memos = ary as List<NCMBObject>;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center();
  }
}
