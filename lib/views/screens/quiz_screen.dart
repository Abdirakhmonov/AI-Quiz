import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:lottie/lottie.dart';
import 'package:musobaqa/controllers/quiz_controller.dart';
import 'package:musobaqa/views/widgets/my_text_field.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final topicController = TextEditingController();
  String? selectDifficulty;
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>>? questions;
  bool isLoading = false;

  String? validateTextField(value) {
    if (value == null || value.isEmpty) {
      return "Please enter topic";
    }
    return null;
  }

  void saveForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();
    }
  }

  Future loadingWidget(String title) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Lottie.asset("assets/loading.json"),
            title: Text(title),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: null,
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 5, right: 35),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButton(
                items: const [
                  DropdownMenuItem(
                    value: "Easy",
                    child: Text("Easy"),
                  ),
                  DropdownMenuItem(
                    value: "Medium",
                    child: Text("Medium"),
                  ),
                  DropdownMenuItem(
                    value: "Hard",
                    child: Text("Hard"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectDifficulty = value;
                  });
                },
                hint: const Text("Choose Difficulty"),
                value: selectDifficulty,
              ),
              MyTextField(
                controller: topicController,
                validator: validateTextField,
                sendOnPressed: () {
                  saveForm();
                  QuizController()
                      .getQuestion(topicController.text, selectDifficulty);
                  loadingWidget("Generating Quiz");
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
