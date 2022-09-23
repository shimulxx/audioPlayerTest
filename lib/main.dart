import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:io';

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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyPlayer(),
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


