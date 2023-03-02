import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inquiry/inquiry.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String question = 'What is the capital city of Canada?';

  final options = {
    'Toronto': false,
    'Montreal': false,
    'Ottawa': true,
    'Vancouver': false,
    'Quebec': false,
  };

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Random random = Random();
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Inquiry Example'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Inquiry(
            inquiryId: 'inquiry',
            options: List.generate(
              options.length,
              (index) {
                final opt = options.entries.elementAt(index);
                return InquiryOption(
                  id: index,
                  title: Text(
                    opt.key,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  votes: random.nextInt(20),
                  rightAnswer: opt.value,
                );
              },
            ),
            style: InquiryStyle(
              optionsBorderRadius: BorderRadius.circular(8),
              votedInquiryPercentRadius: const Radius.circular(8),
              optionsBorder: Border.all(color: Colors.black),
              rightAnswerBorder: Border.all(color: Colors.green),
              optionsBackgroundColor: Colors.grey.shade300,
              wrongBackgroundColor: Colors.red.shade100,
              rightBackgroundColor: Colors.green.shade100,
              optionsSplashColor: Colors.blue,
              votedWrongProgressColor: Colors.red.shade300,
              votedRightProgressColor: Colors.green.shade300,
              voteInProgressColor: Colors.blue,
              voteButtonStyle: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              ),
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
            titleWidget: Text(
              question,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            metadataWidget: const Text('Created by Ch4rl3B'),
            onVoted: (option, amount) {
              if (kDebugMode) {
                print("Voted option: ${option.title}. "
                    "The option is ${option.rightAnswer ? 'correct' : 'incorrect'}");
              }
              return Future.value(true);
            },
          ),
        ),
      ),
    );
  }
}
