import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/input.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/collisions.dart';
import 'dart:math';

void main()=> runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // ホームページを設定
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flame Test')),
      body: GameWidget(game: SampleGame()),
    );
  }
}

class SampleGame extends FlameGame with HasCollisionDetection{
  @override
  Color backgroundColor() => const Color(0xffcfcfcf);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 画面の端（上下左右）すべてに「見えない壁」を設置！
    add(ScreenHitbox());
    // 円を1つ表示
    //await add(MySprite());

    // ゲームに丸を10個追加
    for (var i = 0; i < 10; i++) {
      await add(MySprite());
    }
  }
}

class MySprite extends CircleComponent with CollisionCallbacks, HasGameRef<SampleGame>{
  final double _size = 50.0;
  // late = 後で初期化
  late Color _color;
  late Vector2 _delta; // あとで必ず初期化する予定の、2次元ベクトル型の _delta（移動速度）という変数を定義する

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // ランダムな色に設定(変数rnd）
    final rnd = Random();
    _color = Color.fromARGB(200, rnd.nextInt(256), rnd.nextInt(256), rnd.nextInt(256));
    
    //サイズ位置を規定
    size = Vector2(_size, _size);
    position = Vector2(100, 100);
    setColor(_color);
    // ランダムな方向・速さ
    _delta = Vector2.random() * 3.0;

    add(CircleHitbox());
  }

  // update() を追加
  @override
  void update(double delta) {
    super.update(delta);
    position += _delta * delta * 100; // 時間と速度をかけて移動
  }

  // 衝突した時にdeltaを反転させる処理　＆　接触したときに色を変える
  @override
  void onCollision (Set<Vector2> points, PositionComponent other) {
    super.onCollision(points, other);

    // 壁にあたったら方向を変える
    if (other is ScreenHitbox) {
      if (position.x <= 0) {
        _delta.x = _delta.x.abs();
      }
      if (position.x >= gameRef.size.x - size.x) {
        _delta.x = -_delta.x.abs();
      }
      if (position.y <= 0) {
        _delta.y = _delta.y.abs();
      }
      if (position.y >= gameRef.size.y - size.y) {
        _delta.y = -_delta.y.abs();
      }
    } else {
      // 相手が壁でない → 他のスプライトとぶつかったとき！
      setColor(Colors.yellow);
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);

    // 接触が終わったら元の色に戻す
    setColor(_color);
  }
}