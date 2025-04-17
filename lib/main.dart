import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/input.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart'; // タップイベント関係
import 'package:flame/collisions.dart';

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
// SampleGameクラス: FlameGameを継承してゲームのロジックを実装
class SampleGame extends FlameGame with TapCallbacks {
  // 🌟 タップされた位置（目標地点）を記録するベクトル
  Vector2 _position = Vector2(100, 100);

  // 🌟 画面上に追加したスプライトのリスト（動かす対象）
  final List<PositionComponent> _sprites = <PositionComponent>[];

  @override
  Color backgroundColor() => const Color(0xffCCCCFF); // 背景色の設定

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 🌟 緑の四角スプライトを作成し、画面に追加
    var sp1 = GreenRectSprite(Vector2(200, 100));
    _sprites.add(sp1);
    add(sp1);

    // 🌟 赤い円スプライトを作成し、画面に追加
    var sp2 = RedCircleSprite(Vector2(100, 200));
    _sprites.add(sp2);
    add(sp2);

    // 🌟 白いテキストを左上に追加（"Hello Flame!" と表示）
    add(WhiteTextSprite(Vector2(25, 25)));
  }

  @override
  void onTapDown(TapDownEvent event) {
    // 🌟 タップされた位置 - (50, 50) → スプライトの中心に合わせるために補正
    _position = event.canvasPosition - Vector2(50, 50);
    super.onTapDown(event);
  }
}


// 赤い円コンポーネント（CircleComponentを使った円描画）
class RedCircleSprite extends CircleComponent
    with HasGameRef<SampleGame> {
  // 初期位置
  late Vector2 _position;

  RedCircleSprite(this._position): super();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    setColor(Colors.red); // 🌟 赤い塗りつぶしの円に設定
    position = _position; // 初期位置を設定
    size = Vector2(100, 100); // 円のサイズ（幅・高さ）
  }

  @override
  void update(double delta) {
    // 🌟 ゲーム側で設定された目標位置に向かって移動
    final d = (gameRef._position - position) / 10; // 徐々に近づく（やや速め）
    position += d * delta * 100; // deltaで速度調整（ハード依存回避）
    super.update(delta);
  }
}
// 緑の四角形コンポーネント（カスタム描画を使用）
class GreenRectSprite extends PositionComponent
    with HasGameRef<SampleGame> {
  late Vector2 _position; // 初期位置
  late Paint _paint; // 四角の描画スタイル

  GreenRectSprite(this._position): super();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    position = _position;
    size = Vector2(100, 100); // 四角のサイズ
    _paint = Paint()
      ..style = PaintingStyle.fill // 🌟 塗りつぶしスタイル
      ..color = Colors.green; // 🌟 緑色に設定
  }

  @override
  void update(double delta) {
    // 🌟 ゲームの目標位置に向かってゆっくり近づく
    final d = (gameRef._position - position) / 50; // ややゆっくり
    position += d * delta * 100;
    super.update(delta);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final r = Rect.fromLTWH(0, 0, 100, 100); // 描画範囲
    canvas.drawRect(r, _paint); // 四角形を描画
  }
}


// 白いテキストのコンポーネント
class WhiteTextSprite extends TextComponent {
  late Vector2 _position;

  WhiteTextSprite(this._position): super();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    position = _position; // テキストの表示位置
    text = "Hello Flame!"; // 表示する文字列
    textRenderer = TextPaint(
      style: TextStyle(
        fontSize: 48.0,
        fontWeight: FontWeight.bold,
        color: Colors.white, // 白文字に設定
      ),
    );
  }
}
