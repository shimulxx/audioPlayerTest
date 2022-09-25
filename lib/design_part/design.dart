import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class DesignWidget extends StatelessWidget {
  const DesignWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: SlideWidget()),
    );
  }
}

class CustomBoxShadow extends BoxShadow {
  final BlurStyle blurStyle;

  const CustomBoxShadow({
    Color color = const Color(0xFF000000),
    Offset offset = Offset.zero,
    double blurRadius = 0.0,
    this.blurStyle = BlurStyle.normal,
  }) : super(color: color, offset: offset, blurRadius: blurRadius);

  @override
  Paint toPaint() {
    final Paint result = Paint()
      ..color = color
      ..maskFilter = MaskFilter.blur(this.blurStyle, blurSigma);
    assert(() {
      if (debugDisableShadows)
        result.maskFilter = null;
      return true;
    }());
    return result;
  }
}

class SlideWidget extends StatefulWidget {
  const SlideWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<SlideWidget> createState() => _SlideWidgetState();
}

class _SlideWidgetState extends State<SlideWidget> {
  double bottom = 0;
  bool closed = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xff4c0066),
            Color(0xff190559),
          ],
        ),
      ),
      child: SlidingUpPanel(
        boxShadow: const [
          CustomBoxShadow(
              color: Colors.black,
              offset: Offset(10.0, 10.0),
              blurRadius: 0.0,
              blurStyle: BlurStyle.outer
          )
        ],
        minHeight: 60,
        maxHeight: 560,
        onPanelSlide: (value){
          closed = false;
          setState(() {
            bottom = value * 500;
            //print(bottom);
          });
        },
        collapsed: Container(
          alignment: Alignment.topCenter,
          child: const Icon(Icons.keyboard_arrow_up, color: Colors.white, size: 30,),
        ),
        // panel: Container(
        //   alignment: Alignment.center,
        //   decoration: const BoxDecoration(
        //     gradient: LinearGradient(
        //       begin: Alignment.bottomLeft,
        //       end: Alignment.bottomRight,
        //       colors: [
        //         Color(0xff4c0066),
        //         Color(0xff190559),
        //       ],
        //     ),
        //   ),
        //   child: Padding(
        //     padding: const EdgeInsets.all(16),
        //     child: ListView.separated(
        //       itemCount: 10,
        //       separatorBuilder: (context,index){
        //         return const SizedBox(height: 10,);
        //       },
        //       itemBuilder: (context, index){
        //         return MusicListItem(
        //           index: index,
        //         );
        //       },
        //     ),
        //   )
        // ),
        onPanelClosed: (){
          setState(() {
            closed = true;
          });
        },
        onPanelOpened: (){
          setState(() {
            closed = false;
          });
        },
        panelBuilder: (sc){
          //print('panel builder is called');
          return Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xff4c0066),
                    Color(0xff190559),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 23),
                child: closed ? Container() : ListView.separated(
                  controller: sc,
                  itemCount: 10,
                  separatorBuilder: (context,index){
                    return const SizedBox(height: 15,);
                  },
                  itemBuilder: (context, index){
                    return MusicListItem(
                      index: index,
                    );
                  },
                ),
              )
          );
        },
        body: closed ? PlayerBodyWidget(bottom: bottom,) : ImageBodyWidget(bottom: bottom),
      ),
    );
  }
}

class PlayerBodyWidget extends StatefulWidget {
  const PlayerBodyWidget({
    Key? key,
    required this.bottom,
  }) : super(key: key);

  final double bottom;

  @override
  State<PlayerBodyWidget> createState() => _PlayerBodyWidgetState();
}

class _PlayerBodyWidgetState extends State<PlayerBodyWidget> with TickerProviderStateMixin {
  late final AnimationController _controller;
  var opacity = 0.0;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(() {
      setState(() {
        opacity = _controller.value;
      });
    });
    _controller.forward(from: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        padding: const EdgeInsets.only(left: 35, right: 35, bottom: 55),
        margin: EdgeInsets.only(bottom: widget.bottom * 1.2),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/img.png', height: 300,),
            const SizedBox(height: 18,),
            Text('Peaceful Piano Music', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),
            const SizedBox(height: 5,),
            Text('Relaxing Piano Music', style: TextStyle(color: Colors.white.withOpacity(0.4)),),
            const SizedBox(height: 25),
            SliderTheme(
              data: SliderThemeData(
                trackHeight: 1,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                overlayShape: SliderComponentShape.noOverlay,
              ),
              child: Slider(
                activeColor: Colors.white,
                inactiveColor: Colors.white.withOpacity(0.1),
                onChanged: print,
                value: 50,
                min: 0,
                max: 160,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('1:06', style: TextStyle(color: Colors.white.withOpacity(0.4)),),
                  Text('3:10', style: TextStyle(color: Colors.white.withOpacity(0.4)),),
                ],
              ),
            ),
            const SizedBox(height: 70),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.skip_previous, color: Colors.white, size: 55,),
                const SizedBox(width: 10,),
                Container(
                  height: 85,
                  width: 85,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.play_arrow, color: Colors.black, size: 45,),
                ),
                const SizedBox(width: 10,),
                Icon(Icons.skip_next, color: Colors.white, size: 55,)
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ImageBodyWidget extends StatelessWidget {
  const ImageBodyWidget({
    Key? key,
    required this.bottom,
  }) : super(key: key);

  final double bottom;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(45), bottomRight: Radius.circular(45)),
            image: DecorationImage(
              image: AssetImage('assets/img2.png',),
              fit: BoxFit.cover,
            )
        ),
        alignment: Alignment.bottomLeft,
        margin: EdgeInsets.only(bottom: bottom * 1.2),
        padding: const EdgeInsets.only(left: 25, bottom: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Peaceful Piano...", style: TextStyle(fontSize: 35, fontWeight: FontWeight.w700, color: Colors.white.withOpacity(0.8)),),
            Text('Instrumental ● 240 songs ● 32hr', style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.7)))
          ],
        )
    );
  }
}

class MusicListItem extends StatelessWidget {
  const MusicListItem({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset('assets/${index % 5}.png', height: 70, width: 70,),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Peaceful Piano Music', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),
                const SizedBox(height: 5,),
                Text('Relaxing Piano Music', style: TextStyle(color: Colors.white.withOpacity(0.4)),)
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Icon(Icons.close, color: Colors.white,),
        )
      ],
    );
  }
}