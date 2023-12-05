import 'package:flutter/foundation.dart';

class JsonUtils<T> {
  static List<String> stringList(dynamic json) {
    if (json.runtimeType != List<String>) {
      return json != null
          ? (json as List).map((item) => item.toString()).toList()
          : [];
    }
    return [];
  }

  static List<int> intList(dynamic json) {
    if (json.runtimeType != List<int>) {
      return json != null
          ? (json as List).map((item) => item as int).toList()
          : [];
    }
    return [];
  }

  static DateTime? date(dynamic dateString) {
    if (dateString != null) {
      try {
        return DateTime.parse(dateString);
      } catch (e) {
        if (kDebugMode) print(e);
        return null;
      }
    }
    return null;
  }

  static T model<T>(
    T Function(Map<String, dynamic> function) function,
    dynamic json,
  ) {
    return function(json);
  }

  static T? modelOrNull<T>(
    T Function(Map<String, dynamic> function) function,
    dynamic json,
  ) {
    if (json == null) {
      return null;
    } else {
      return function(json);
    }
  }

  static List<T> list<T>(
    T Function(Map<String, dynamic>) function,
    dynamic json,
  ) {
    if (json == null) {
      return [];
    } else {
      try {
        return (json as List).map((j) => function(j)).toList();
      } catch (e, stackTrace) {
        if (kDebugMode) {
          print(stackTrace);
          rethrow;
        }
        return [];
      }
    }
  }
}
