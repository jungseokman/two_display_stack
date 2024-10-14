import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(const MyWidget());
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  double _bottomPosition = -600; //? 드래그 가능한 초기 위치

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    Color backgroundColor = Color.lerp(
      Colors.amber, //? -600일 때 색상
      Colors.black, //? 0일 때 색상
      (_bottomPosition + 600) / 600, //? _bottomPosition을 0과 1 사이의 값으로 변환
    )!;
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text("테스트"),
        ),
        body: SizedBox(
          width: double.maxFinite,
          height: double.maxFinite,
          child: Stack(
            children: [
              AnimatedContainer(
                width: double.maxFinite,
                height: double.maxFinite,
                duration: const Duration(milliseconds: 500),
                color: backgroundColor,
                child: Image.network(
                  "https://search.pstatic.net/common/?src=http%3A%2F%2Fcafefiles.naver.net%2Fdata9%2F2005%2F7%2F4%2F99%2F527.jpg&type=a340",
                  fit: BoxFit.cover,
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOut,
                left: 0,
                right: 0,
                bottom: _bottomPosition,
                child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    setState(() {
                      //>> _bottomPosition이 -600보다 작지 않게 하고 0보다 크지 않게 함
                      _bottomPosition -= details.delta.dy;
                      if (_bottomPosition < -600) {
                        _bottomPosition = -600;
                      } else if (_bottomPosition > 0) {
                        _bottomPosition = 0;
                      }
                    });
                  },
                  onVerticalDragEnd: (details) {
                    if (details.velocity.pixelsPerSecond.dy > 0) {
                      setState(() {
                        _bottomPosition = -600;
                      });
                    } else if (details.velocity.pixelsPerSecond.dy < 0) {
                      setState(() {
                        _bottomPosition = 0;
                      });
                    }
                  },
                  child: Container(
                    height: screenHeight -
                        kToolbarHeight -
                        kBottomNavigationBarHeight,
                    color: Colors.blue,
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: List.generate(
                                40,
                                (index) {
                                  return const Text("asdasd");
                                },
                              ),
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOut,
                          height: _bottomPosition.abs() + 70,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                    color: Colors.pink, height: 50, child: const TextField()),
              )
            ],
          ),
        ),
      ),
    );
  }
}
