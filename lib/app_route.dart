import 'package:flutter/material.dart';
import 'package:untitled/design_part/design.dart';
import 'package:untitled/player_part/player.dart';

import 'main.dart';

const kPlayerScreen = 'playerScreen';
const kDesignScreen = 'designScreen';

Route? onGenerateRoute(RouteSettings settings) {
  switch(settings.name){
    case '/':
      return MaterialPageRoute(builder: (context) => const SwitchingWidget());
    case kPlayerScreen:
      return MaterialPageRoute(builder: (context) => const PlayerWidget());
    case kDesignScreen:
      return MaterialPageRoute(builder: (context) => const DesignWidget());
    default:
      return null;
  }
}