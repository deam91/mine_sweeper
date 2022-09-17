import 'package:flutter/material.dart';

class LateralMenu extends StatefulWidget {
  const LateralMenu({Key? key}) : super(key: key);

  @override
  State<LateralMenu> createState() => _LateralMenuState();
}

class _LateralMenuState extends State<LateralMenu>
    with SingleTickerProviderStateMixin {
  bool _listMode = false;
  late Animation<double> _myAnimation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _myAnimation =
        CurvedAnimation(curve: Curves.decelerate, parent: _controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (_listMode) {
                  _controller.reverse();
                } else {
                  _controller.forward();
                }
                _listMode = !_listMode;
              });
            },
            icon: AnimatedIcon(
              icon: AnimatedIcons.view_list,
              progress: _myAnimation,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          PageRouteBuilder(
            barrierColor: Colors.black.withOpacity(.5),
            pageBuilder: (_, a1, a2) {
              return FadeTransition(
                opacity: a1,
                child: const MyMenu(value: 3),
              );
            },
            opaque: false,
          ),
        ),
        child: const Icon(Icons.add),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: _listMode
            ? ListView.builder(
                itemCount: 10,
                itemExtent: 280,
                itemBuilder: (_, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/images/green.jpeg',
                    ),
                  );
                },
              )
            : GridView.builder(
                itemCount: 10,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (_, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/images/green.jpeg',
                      width: 140,
                      fit: BoxFit.fill,
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class MyMenu extends StatefulWidget {
  const MyMenu({super.key, required this.value});

  final int value;

  @override
  State<MyMenu> createState() => _MyMenuState();
}

class _MyMenuState extends State<MyMenu> {
  double _fontSize = 10;
  Color _color = Colors.white;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Material(
        color: Colors.black.withOpacity(.3),
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 400),
          builder: (_, value, child) {
            return Transform.translate(
              offset: Offset(200 * value, 0.0),
              child: child!,
            );
          },
          tween: Tween(begin: 1.0, end: 0.0),
          child: Center(
            child: AnimatedContainer(
              padding: EdgeInsets.all(_fontSize % 2 == 0 ? 10.0 : 20.0),
              duration: const Duration(milliseconds: 300),
              color: Colors.red,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        _fontSize += 5.0;
                        if (_fontSize % 2 == 0) {
                          _color = Colors.grey;
                        } else {
                          _color = Colors.white;
                        }
                      });
                    },
                    color: Colors.orange,
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(fontSize: _fontSize, color: _color),
                      child: const Text(
                        'Text Up!',
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {},
                    color: Colors.orange,
                    child: Text('aksjdaksdb'),
                  ),
                  MaterialButton(
                    onPressed: () {},
                    color: Colors.orange,
                    child: Text('aksjdaksdb'),
                  ),
                  const SizedBox(
                    height: kToolbarHeight * 2,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
