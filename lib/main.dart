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
  // SampleGame（親クラス）の位置を規定。今後の子クラスの位置指定のゴール基準となる
  Vector2 _position = Vector2(100, 100);
  //
  final List<PositionComponent> _sprites = <PositionComponent>[];

  @override
  // 背景色
  Color backgroundColor() => const Color(0xffCCCCFF);

  @override
  // 初期化
  Future<void> onLoad() async {
    await super.onLoad();
    // sp1を規定。緑の四角。位置をベクトルで指定し横200、縦100に配置される
    var sp1 = GreenRectSprite(Vector2(200, 100));
    // スプライトに追加
    _sprites.add(sp1);
    // ゲーム画面に追加
    add(sp1);
    // sp2を規定。赤の丸。位置をベクトルで指定し縦200、横100に配置される
    var sp2 = RedCircleSprite(Vector2(100, 200));
    // スプライトに追加
    _sprites.add(sp2);
    // ゲーム画面に追加
    add(sp2);
    // ゲーム画面に追加（白いテキスト。縦横25ずつの開始位置）
    add(WhiteTextSprite(Vector2(25, 25)));
  }

  // このコンポーネントがタップされたと教えてくれる関数
  @override
  void onTapDown(TapDownEvent event) {
    // タップされた位置を_positionで指定
    // キャンバスポジションから縦横50を引いた値（四角と●の半径が50のため、それらの図形の中心を意味する）
    _position = event.canvasPosition - Vector2(50, 50);
    super.onTapDown(event);
  }
}

// 円コンポーネント
class RedCircleSprite extends CircleComponent
    // ゲーム画面に用意したポジションを使用
    with HasGameRef<SampleGame> {
  // スプライトの位置を格納する変数
  late Vector2 _position;

  RedCircleSprite(this._position): super();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // 赤い円に
    setColor(Colors.red);
    position = _position;
    // _positionを位置に
    size = Vector2(100, 100);
  }

  @override
  void update(double delta) {
    // スプライト側からゲーム画面側の情報を取り出す
    // 移動方向と距離を定義
    // 1フレームごとの移動距離はゲーム画面側の位置 - 今の位置 ÷　10
    final d = (gameRef._position - position) / 10;
    // 上記を100倍にして自然なスピードにする
    position += d * delta * 100;
    super.update(delta);
  }
}

// 四角形の描画コンポーネント
// PositionComponentを使用
class GreenRectSprite extends PositionComponent
    with HasGameRef<SampleGame>{
  late Vector2 _position;  // スプライトの位置を格納する変数
  late Paint _paint;  // スプライトの描画を格納する変数

  GreenRectSprite(this._position): super();

  @override
  // PositionComponentの設定
  Future<void> onLoad() async {
    await super.onLoad();
    position = _position;  // _positionをpositionとして使えるようにする
    size = Vector2(100, 100);
    _paint = Paint()  // Paintメソッド
      ..style = PaintingStyle.fill
      ..color = Colors.green;
  }

  @override
  void update(double delta) {
    // 1フレームごとの移動距離はゲーム画面側の位置 - 今の位置 ÷　50
    final d = (gameRef._position - position) / 50;
    position += d * delta * 100;
    super.update(delta);
  }

  @override
  // 描画を行うためのクラス
  void render(Canvas canvas) {
    super.render(canvas);
    // 描画領域を定義
    final r = Rect.fromLTWH(0, 0, 100, 100);
    // 描画
    canvas.drawRect(r, _paint);
  }
}

// テキストコンポーネント
class WhiteTextSprite extends TextComponent {
  late Vector2 _position;// スプライトの位置を格納する変数

  WhiteTextSprite(this._position): super();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    position = _position; // 位置はキャンバスのポジション
    // 以下テキストの中身とスタイル
    text = "Hello Flame!";
    textRenderer = TextPaint(
      style: TextStyle(
        fontSize: 48.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}
