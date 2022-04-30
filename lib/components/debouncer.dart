import 'dart:async';
import 'dart:ui';

class Debouncer {
  int milliseconds = 500;
  VoidCallback action = (){

  };
  Timer _timer = Timer(Duration(milliseconds: 500), (){
    
  });

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}