import 'package:flutter/material.dart';
import 'package:untitled/app_route.dart';
import 'package:untitled/player_part/player.dart';

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
      onGenerateRoute: onGenerateRoute,
      //home: const PlayerWidget(),
      //home: MyTest(),
      //home: SwitchingWidget(),
    );
  }
}

class SwitchingWidget extends StatelessWidget {
  const SwitchingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Please select'),),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MaterialButton(
              minWidth: 150,
              color: Colors.green,
              child: const Text('UI screen', style: TextStyle(color: Colors.white),),
              onPressed: (){
                Navigator.of(context).pushNamed(kDesignScreen);
              },
            ),
            MaterialButton(
              minWidth: 150,
              color: Colors.red,
              child: const Text('Player screen', style: TextStyle(color: Colors.white),),
              onPressed: (){
                Navigator.of(context).pushNamed(kPlayerScreen);
              },
            ),
          ],
        ),
      ),
    );
  }
}








