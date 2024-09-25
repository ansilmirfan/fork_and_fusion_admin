
import 'dart:developer';

import 'package:flutter/material.dart';

class StackTrackingObserver extends NavigatorObserver {
  int pageCount = 0;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pageCount++;
    log('Page pushed. Total pages in stack: $pageCount');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pageCount--;
    log('Page popped. Total pages in stack: $pageCount');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pageCount--;
    log('Page removed. Total pages in stack: $pageCount');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    log('Page replaced. Total pages in stack: $pageCount');
  }
}
