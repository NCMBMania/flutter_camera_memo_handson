import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:fluttertoast/fluttertoast.dart';
// 1. NCMB SDKを読み込みます

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  // 2. NCMBの初期化

  // 3. ログインユーザーの取得
  var user = null;
  if (user == null) {
    // 4. 未ログインだっら匿名認証実行
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
    // ランダムなファイル名
    var fileName = "${const Uuid().v4()}.$_extension";
    // 5. ACL（アクセス権限）作成
    // 6. ファイルアップロード
    // 7. メモデータを作成して保存
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
  // 8. メモデータを入れる変数
  List<Object> _memos = [];
  
  @override
  void initState() {
    super.initState();
    getMemos();
  }

  Future<void> getMemos() async {
    // 9. メモデータを検索
    setState(() {
      // 10. 取得したら _memos に入れる
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        var memo = _memos[index];
        return Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.black38),
              ),
            ),
            child: ListItem(memo: memo)
        ),
      },
      itemCount: _memos.length,
    );
  }
}

class ListItem extends StatefulWidget {
  const ListItem({
    // 11. メモを渡す
    Key? key}) : super(key: key);
  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Image(),
        title: "", // 12．メモの作成日時
        subtitle: Text(""), // 13. メモのタイトル
          overflow: TextOverflow.ellipsis, maxLines: 2
        ),
        onTap: () {
          // 記事をタップした時の処理
        },
    ))
  }
}