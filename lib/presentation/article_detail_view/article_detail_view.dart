import 'package:flutter/material.dart';



class ArticleDetailView extends StatelessWidget {
  final String question;
  final String answer;

  const ArticleDetailView(
      {super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(question),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(answer),
      ),
    );
  }
}