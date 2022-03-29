import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
// 1. NCMB SDKを読み込みます

Future<void> main() async {
  // キーは assets/.env にあります
  await dotenv.load(fileName: "assets/.env");
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({
    Key? key,
  }) : super(key: key);
  @override
  State<MainPage> createState() => _MainPageState();
}

// タブ画面を表示します
class _MainPageState extends State<MainPage> {
  final _tabs = [
    const Tab(text: 'アップロード', icon: Icon(Icons.photo)),
    const Tab(text: 'メモ', icon: Icon(Icons.list)),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('メモアプリ'),
          bottom: TabBar(
            tabs: _tabs,
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

// 入力フォーム用
class FormPage extends StatefulWidget {
  const FormPage({
    Key? key,
  }) : super(key: key);
  @override
  State<FormPage> createState() => _FormPageState();
}

// 入力フォーム
class _FormPageState extends State<FormPage> {
  // 選択した画像
  Uint8List? _image;
  // 選択したファイルの拡張子
  String? _extension;
  // 画像ピッカー
  final picker = ImagePicker();
  // 入力したメモ
  String _text = '';
  // 入力したメモの操作用
  TextEditingController? _textEditingController;

  // 初期化
  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: _text);
  }

  // 画面描画用
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
          // 画像が指定された場合は画像を表示
          // なければアイコンを表示（初期表示）
          _image != null
              ? GestureDetector(
                  child: SizedBox(
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
          // メモ欄
          SizedBox(
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

  // 保存ボタンを押した時の処理
  Future<void> _save() async {
    // ファイル名はランダムに生成
    var fileName = "${const Uuid().v4()}.$_extension";
    // 5. ACL（アクセス権限）作成
    // 6. ファイルアップロード
    // 7. メモデータを作成して保存
    done();
  }

  // 保存完了時の処理（アラートを表示するだけ）
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
                  // 入力値を初期化
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

  // 写真選択時の処理
  Future<void> _selectPhoto() async {
    try {
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedFile == null) return;
      var image = await pickedFile.readAsBytes();
      setState(() {
        _extension = p.extension(pickedFile.name);
        _image = image;
      });
    } catch (err) {}
  }
}

// 一覧画面用
class ListPage extends StatefulWidget {
  const ListPage({
    Key? key,
  }) : super(key: key);
  @override
  State<ListPage> createState() => _ListPageState();
}

// 一覧画面
class _ListPageState extends State<ListPage> {
  // メモ一覧が入る配列
  var _memos = [];

  @override
  void initState() {
    super.initState();
    getMemos();
  }

  // 画面描画用
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        var memo = _memos[index];
        return Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.black38),
              ),
            ),
            child: ListItem(memo));
      },
      itemCount: _memos.length,
    );
  }

  // 登録されているメモを取得する
  Future<void> getMemos() async {
    // 9. メモデータを検索
    setState(() {
      // 10. 取得したら _memos に入れる
    });
  }
}

// 一覧時の行データ用
class ListItem extends StatefulWidget {
  // 11. メモを渡す
  final Object memo;
  const ListItem(this.memo, {Key? key}) : super(key: key);

  @override
  State<ListItem> createState() => _ListItemState();
}

// 一覧時の行データ
class _ListItemState extends State<ListItem> {
  // 画像データが入るバイト列
  Uint8List? _image;

  @override
  void initState() {
    super.initState();
    getPhoto();
  }

  // 画面描画
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _image != null
          ? Image.memory(
              _image!,
              width: 50,
            )
          : const Icon(
              Icons.photo,
              color: Colors.blue,
              size: 50,
            ),
      title: Text(''), // 12．メモの作成日時
      subtitle: Text(
        '', // 13. メモのタイトル
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return ImagePage(_image!);
        }));
      },
    );
  }

  // 写真をNCMBから取得する
  Future<void> getPhoto() async {
    // 13. 写真のダウンロード
    // セット（dataにデータが入っている）
    setState(() {
      // 14. 写真データのセット
    });
  }

  // 日付はフォーマットして表示
  String viewDate(DateTime date) {
    var format = DateFormat('MM月dd日 HH:mm');
    return format.format(date);
  }
}

// 一覧をタップ時に画像を拡大表示する
class ImagePage extends StatelessWidget {
  // 画像データ
  final Uint8List _image;
  const ImagePage(this._image, {Key? key}) : super(key: key);

  // 描画用
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: Image.memory(_image),
          ),
        ),
        onPanUpdate: (details) {
          // Swiping in right direction.
          if (details.delta.dx > 0) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
