import 'package:flutter/material.dart';

class Task {
  final String id;
  final String title;
  final String image;
  final int amount;
  final bool isFavorite;

  Task(
      {@required this.id,
      @required this.title,
      @required this.image,
      @required this.amount,
      this.isFavorite = false});
}
