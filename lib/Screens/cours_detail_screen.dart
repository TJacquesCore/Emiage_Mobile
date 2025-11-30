import 'package:flutter/material.dart';

class CoursDetailScreen extends StatelessWidget {
  final String courseTitle;
  final String courseContent;

  const CoursDetailScreen({
    super.key,
    required this.courseTitle,
    required this.courseContent,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(courseTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          courseContent,
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
      ),
    );
  }
}