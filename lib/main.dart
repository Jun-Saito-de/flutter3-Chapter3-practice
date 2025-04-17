import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/input.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart'; // タップイベント関係

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
class SampleGame extends FlameGame with TapCallbacks {
  late final MySprite _sprite;

  @override
  Color backgroundColor() => const Color(0xffccffff); // ゲーム画面の背景色を設定

  @override
  Future<void> onLoad() async {
    await super.onLoad();  // 親クラスFlameGameのonLoadメソッドを呼び出す
    _sprite = MySprite(Vector2(100, 100));
    add(_sprite);  // MySpriteを位置(100, 100)でゲームに追加
  }

  @override
  void onTapDown(TapDownEvent event) {
    _sprite._position = event.canvasPosition;
    super.onTapDown(event);
  }
}

// MySpriteクラス: SpriteComponentを継承してキャラクターのスプライトを作成
class MySprite extends SpriteComponent with TapCallbacks{
  late Vector2 _position;  // スプライトの位置を格納する変数


  // コンストラクタ: 位置（_position）を指定してMySpriteを初期化
  MySprite(this._position):super();

  @override
  Future<void> onLoad() async {
    await super.onLoad();  // 親クラスのonLoadメソッドを呼び出す
    sprite = await Sprite.load('chara.png');  // 'chara.png'をスプライト画像としてロード
    position = _position;  // スプライトの位置を設定
    size = Vector2(100, 100);  // スプライトのサイズを100x100に設定
    anchor= Anchor.center;
  }

  @override
  void update(double delta) {
    // d	移動方向と距離（毎回変化）
    // 今の位置と目標の差（方向と距離）」を計算。20で割って超ゆっくりに
    final d = (_position - position) / 20;
    // d は「20分の1の差」なので、これをそのまま足すと超ゆっくりになります。
    // だから調整用に delta * 100 をかけて速度をチューニングしています！
    position += d * delta * 100;
    super.update(delta);  // 毎フレームの更新処理を呼び出す
  }

  void onTapDown(TapDownEvent event) {
    _position = Vector2.zero();
    position = Vector2.zero();
  }
}
