import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/input.dart';
import 'package:flame/components.dart';

// アプリのエントリーポイント: runAppでMyAppウィジェットを起動
void main() => runApp(MyApp());

// MyAppクラス: アプリの基本設定と構成を行う
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Generated App',  // アプリケーションのタイトル設定
      theme: ThemeData(
        primarySwatch: Colors.blue,  // アプリケーションのテーマカラー
        primaryColor: const Color(0xff2196f3),  // プライマリカラー（メインカラー）
        canvasColor: const Color(0xfffafafa),  // キャンバス（背景）カラー
      ),
      home: MyHomePage(),  // ホーム画面としてMyHomePageを指定
    );
  }
}

// MyHomePageクラス: ゲーム画面を表示するウィジェット
class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// _MyHomePageStateクラス: MyHomePageの状態を管理する
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My App')),  // アプリバー（上部のタイトル表示）
      body: GameWidget(
          game: SampleGame()),  // ゲーム画面としてSampleGameを埋め込む
    );
  }
}

// SampleGameクラス: FlameGameを継承してゲームのロジックを実装
class SampleGame extends FlameGame with HasKeyboardHandlerComponents {
  @override
  Color backgroundColor() => const Color(0xffccffff); // ゲーム画面の背景色を設定

  @override
  Future<void> onLoad() async {
    await super.onLoad();  // 親クラスFlameGameのonLoadメソッドを呼び出す
    add(MySprite(Vector2(100,100)));  // MySpriteを位置(100, 100)でゲームに追加
  }
}

// MySpriteクラス: SpriteComponentを継承してキャラクターのスプライトを作成
class MySprite extends SpriteComponent with KeyboardHandler{
  late Vector2 _position;  // スプライトの位置を格納する変数
  late Vector2 _delta;  // スプライトの位置を格納する変数

  // コンストラクタ: 位置（_position）を指定してMySpriteを初期化
  MySprite(this._position):super();

  @override
  Future<void> onLoad() async {
    await super.onLoad();  // 親クラスのonLoadメソッドを呼び出す
    sprite = await Sprite.load('chara.png');  // 'chara.png'をスプライト画像としてロード
    position = _position;  // スプライトの位置を設定
    size = Vector2(100, 100);  // スプライトのサイズを100x100に設定
    _delta = Vector2.zero();
  }

  @override
  void update(double delta) {
    position += _delta * delta * 100;
    super.update(delta);  // 毎フレームの更新処理を呼び出す
  }

  @override
  bool onKeyEvent(
      KeyEvent event,
      Set<LogicalKeyboardKey> keysPressed,
      ) {
    if(event is KeyUpEvent) {
      _delta = Vector2.zero();
    }
    if (event.character == 'j') {
      _delta.x = -1;
    }
    if (event.character == 'l') {
      _delta.x = 1;
    }
    if (event.character == 'i') {
      _delta.y = -1;
    }
    if (event.character == 'k') {
      _delta.y = 1;
    }
    return true;
  }
}
