import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../models/quiz_question.dart';

class QuizController {
  static const apiKey = "AIzaSyDzVQPzYcErrnubyy9UmPcDzfmC8hkeQZM";

  Future<List<QuizQuestion>?> getQuestion(
      String topic, String? difficulty) async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
    );

    final prompt =
        """Create 5 questions at an ${difficulty ?? "easy"} level on $topic with 4 options in JSON format indicating the correct answer.
    Here is sample response format:
    [{
      "question": "Simple question",
      "options": ["Option1", "Option2", "Option3", "Option4"],
      "correct_answer": "Option2"
      }]
    """;
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);

    print(response.text.toString());

    if (response.text!.isNotEmpty) {
      return parseResponse(response.text.toString());
    }

    return null;
  }

  List<QuizQuestion> parseResponse(String text) {
    List<Map<String, dynamic>> parsedQuestions = [];
    List<String> lines = text.split("\n");

    for (String line in lines) {
      if (line.trim().startsWith('{') && line.trim().endsWith('}')) {
        try {
          Map<String, dynamic> questionMap = jsonDecode(line.trim());
          parsedQuestions.add(questionMap);
        } catch (e) {
          print('Error parsing line: $line');
        }
      }
    }

    List<QuizQuestion> questions = [];
    parsedQuestions.forEach((questionMap) {
      String question = questionMap['question'];
      List options = questionMap['options'];
      String correctAnswer = questionMap['correct_answer'];

      questions.add(QuizQuestion(
        id: UniqueKey()
            .toString(), // Assuming you generate unique IDs for each question
        question: question,
        options: options,
        correctAnswer: correctAnswer,
      ));
    });
    print(questions);
    return questions;
  }

  Future<void> getFeedback() async {}
}
