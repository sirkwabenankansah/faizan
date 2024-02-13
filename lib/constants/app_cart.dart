
import 'package:flutter/foundation.dart';

class AppBadge{
  static final AppBadge _singleton = AppBadge._internal();

  factory AppBadge() {
    return _singleton;
  }

  AppBadge._internal();
   int cartTotalitems = 0;

   ValueNotifier<int> cartTotalitemsListener = ValueNotifier<int>(0);
  void BadgeUpdate(int value){
    if(value==null) value=0;
    cartTotalitemsListener.value+=value;
    cartTotalitems=value;
  }
assignListner(ValueNotifier<int> updateBg){
  cartTotalitemsListener= updateBg;
  print("-------------------------------- assignListner ----------------------- ");
}
   int getBadgeUpdate(){
     cartTotalitemsListener.value;
      return cartTotalitems;
  }
}