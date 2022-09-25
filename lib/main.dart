import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:io';

import 'package:sliding_up_panel/sliding_up_panel.dart';

//due to lack of computer i can not perform the following task!
//1. UI design
//2. Coding structure
//3. Best state management practice like cubit or bloc
//4. Best coding structure

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: const MyPlayer(),
      home: MyTest(),
    );
  }
}

class MyTest extends StatelessWidget {
  const MyTest({Key? key}) : super(key: key);

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

class MyPlayer extends StatefulWidget {
  const MyPlayer({Key? key}) : super(key: key);

  @override
  State<MyPlayer> createState() => _MyPlayerState();
}

class _MyPlayerState extends State<MyPlayer> {
  final player = AudioPlayer();
  final List<File> files = [];
  var selectedIndex = -1;
  var totalDuration = 1.0;
  var seconds = 1.0;

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // player.bufferedPositionStream.listen((event) {
    //   print('testing: ${event.inSeconds}');
    // });
    // player.androidAudioSessionIdStream.listen((event) {
    //   print('testing: ${event}');
    // });
    player.positionStream.listen((event) {
      setState(() {
        seconds = event.inSeconds.toDouble();
      });
    });

    player.durationStream.listen((event) {
      setState(() {
        totalDuration = event!.inSeconds.toDouble();
      });
    });

    //player.setUrl('https://file-examples.com/storage/fe651bd80a632c9aa9a0f1d/2017/11/file_example_MP3_5MG.mp3');
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    print(seconds);
    print('totalDuration: $totalDuration');
    return Scaffold(
      appBar: AppBar(title: Text('Player'),),
      body: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  MaterialButton(
                    color: Colors.pink,
                    child: Text('Play', style: TextStyle(color: Colors.white)),
                    onPressed: (){
                      player.play();
                    },
                  ),
                  const SizedBox(width: 10,),
                  MaterialButton(
                    color: Colors.green,
                    child: const Text('Stop', style: TextStyle(color: Colors.white),),
                    onPressed: (){
                      player.stop();
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  MaterialButton(
                    color: Colors.black,
                    child: const Text('Prev', style: TextStyle(color: Colors.white)),
                    onPressed: (){
                      setState(() {
                        --selectedIndex;
                        if(selectedIndex < 0){
                          selectedIndex = files.length - 1;
                        }
                        final curFile = files[selectedIndex];
                        player.setFilePath(curFile.path);
                      });
                    },
                  ),
                  const SizedBox(width: 10,),
                  MaterialButton(
                    color: Colors.blueGrey,
                    child: const Text('Next', style: TextStyle(color: Colors.white),),
                    onPressed: (){
                      ++selectedIndex;
                      selectedIndex %= files.length;
                      final curFile = files[selectedIndex];
                      player.setFilePath(curFile.path);
                    },
                  ),
                ],
              ),
              MaterialButton(
                color: Colors.blue,
                child: const Text('Pick Mutltifiles', style: TextStyle(color: Colors.white)),
                onPressed: () async{
                  FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
                  if (result != null){
                    setState(() {
                      for(var i = 0; i < result.paths.length; ++i){
                        files.add(File(result.paths[i]!));
                      }
                    });
                    await player.setFilePath(files[0].path);
                    player.play();
                    // setState(() {
                    //
                    // });
                  } else {
                    // User canceled the picker
                  }
                },
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Text(seconds.floor().toString()),
                    SizedBox(width: 10,),
                    Slider(
                      onChanged: (double value) {
                        player.seek(Duration(seconds: value.toInt()));
                      },
                      value: seconds,
                      min: 0,
                      max: totalDuration,
                    ),
                    SizedBox(width: 10,),
                    Text(totalDuration.floor().toString()),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text('File List:', style: TextStyle(fontWeight: FontWeight.bold),),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index){
                    return SizedBox(height: 10,);
                  },
                  shrinkWrap: true,
                  itemCount: files.length,
                  itemBuilder: (context, index){
                    final curFile = files[index];
                    return FileWidget(
                      filePath: curFile.path,
                      isSelected: index == selectedIndex,
                      onChecked: (){
                        setState(() {
                          selectedIndex = index;
                          player.setFilePath(curFile.path);
                        });
                      },
                      onRemove: (){
                        setState(() {
                          curFile.delete();
                          files.removeAt(index);
                          player.setFilePath('');
                        });
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FileWidget extends StatelessWidget {
  const FileWidget({
    Key? key,
    required this.filePath,
    required this.isSelected,
    required this.onChecked,
    required this.onRemove,
  }) : super(key: key);

  final String filePath;
  final bool isSelected;
  final Function() onChecked;
  final Function() onRemove;

  @override
  Widget build(BuildContext context) {
    final fileName = filePath.split('/').last;
    return Container(
      child: Row(
        children: [
          GestureDetector(
            onTap: onChecked,
            child: AbsorbPointer(
              child: Text(fileName),
            ),
          ),
          const SizedBox(width: 10,),
          GestureDetector(
            onTap: onRemove,
            child: const AbsorbPointer(
              child: Icon(Icons.close, color: Colors.red),
            ),
          )

        ],
      ),
    );
  }
}


