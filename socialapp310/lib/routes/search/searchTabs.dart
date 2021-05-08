import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Choice{
  final String title;
  final IconData icon;
  final int index;
  const Choice({this.title, this.icon, this.index});
}

const List<Choice> choices = <Choice>[
  Choice(title: 'users', icon: Icons.person, index: 0),
  Choice(title: 'location', icon: Icons.location_city, index: 1),
  Choice(title: 'posts', icon: Icons.picture_in_picture, index: 2),
];