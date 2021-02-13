import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_tts/flutter_tts.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{

  double _speechRate = .3;
  bool _isAnimating = false;
  Random _rng = Random();

  String _response = "Tap to ask";
  String _voice;

  int _textColorIndex;
  int _backGroundColorIndex;
  int _circleColorIndex;

  List<Color> _textColors = [
    Colors.yellow,
    Colors.blue,
    Colors.orange,
    Colors.green,
    Colors.red,
    Colors.purple,
    Colors.pink,
    Colors.indigo,
  ];

  List<String> _imagePaths = [
    "assets/bg1.jpg",
    "assets/bg2.jpg",
    "assets/bg3.png",
    "assets/bg4.jpg",
    "assets/bg5.png",
    "assets/bg6.jfif",
    "assets/bg7.jfif",
    "assets/bg8.jpg",
    "assets/bg9.png",
    "assets/bg10.png",
    "assets/bg11.png",
    "assets/bg12.jpg",
    "assets/bg13.jpg",
    "assets/bg14.jpg",
    "assets/bg15.png",
  ];

  List<String> _responses = [
    "Maybe someday",
    "Nothing",
    "Neither",
    "I don't think so",
    "No",
    "Yes",
    "Try asking again",
    "No~~",
  ];

  List<String> _voices = [
    "Maybe someday",
    "Nothing",
    "Neither",
    "I don't think so",
    "No",
    "Yes",
    "Try asking again",
    "Nooo",
  ];

  FlutterTts _flutterTts;
  bool _isTalking = false;

  AnimationController _controller;
  Animation<double> _sizeAnimation;
  Animation _curve;


  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    _textColorIndex = _rng.nextInt(_textColors.length);
    _backGroundColorIndex = _rng.nextInt(_imagePaths.length);
    _circleColorIndex = _rng.nextInt(_textColors.length);
    _flutterTts = FlutterTts();
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    _curve = CurvedAnimation(curve: Curves.bounceIn, parent: _controller);
    _sizeAnimation = TweenSequence(
        <TweenSequenceItem<double>>[
          TweenSequenceItem<double>(
            tween: Tween<double>(begin: 0, end: 25),
            weight: 50,
          ),
          TweenSequenceItem<double>(
            tween: Tween<double>(begin: 25, end: 0),
            weight: 50,
          ),
        ]
    ).animate(_curve);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed)
      {
        _isAnimating = true;
      }
      if (status == AnimationStatus.dismissed){
        _isAnimating = false;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
              decoration:BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(_imagePaths[_backGroundColorIndex]),
                    fit: BoxFit.fitHeight,
                    alignment: Alignment.topCenter
                ),
              ),
              child: Center(
                child: GestureDetector(
                  onTap: () async {
                    if (!_isTalking){
                      _isTalking = true;
                      int res = _rng.nextInt(_responses.length);
                      _backGroundColorIndex = _rng.nextInt(_imagePaths.length);
                      _textColorIndex = _rng.nextInt(_textColors.length);
                      _circleColorIndex = _rng.nextInt(_textColors.length);
                      setState(() {
                        _isAnimating ?  _controller.reverse() : _controller.forward();
                        _response = _responses[res];
                        _voice = _voices[res];
                      });
                      await _flutterTts.setSpeechRate(_speechRate);
                      await _flutterTts.awaitSpeakCompletion(true);
                      await _flutterTts.speak(_voice);
                      _isTalking = false;
                    }

                  },
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (BuildContext context, _) {
                      return CircleAvatar(
                        backgroundColor: _textColors[_circleColorIndex],
                        minRadius: 85 + _sizeAnimation.value,
                        maxRadius: 155 +_sizeAnimation.value,
                        child: CircleAvatar(
                          minRadius: 80.0,
                          maxRadius: 150.0,
                          backgroundImage: AssetImage("assets/conch.jpg"),
                          child: Stack(
                              children:[
                                Text(_response,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Krabby",
                                    fontSize: 70,
                                    foreground: Paint()..style = PaintingStyle.stroke
                                      ..strokeWidth = 6
                                      ..color = Colors.black,
                                  ),
                                ),
                                Text(_response,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Krabby",
                                    fontSize: 70,
                                    color: _textColors[_textColorIndex],
                                  ),
                                ),
                              ]
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
  }
}
