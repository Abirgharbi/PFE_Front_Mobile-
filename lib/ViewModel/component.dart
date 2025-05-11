import 'package:flutter/material.dart';

abstract class DataComposite {
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  Future<void> fetchData(String endpoint);
}
