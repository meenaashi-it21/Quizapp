import 'package:flutter/material.dart';
import '../models/question_model.dart';
import '../widgets/question_widget.dart';
import '../widgets/result_box.dart';
import '../constants.dart';
import '../widgets/next_button.dart';
import '../widgets/option_card.dart';
import '../models/db_connection.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var db = DBConnect();

  late Future _questions;

  Future<List<Question>> getData() async {
    return db.fetchQuestions();
  }

  @override
  void initState() {
    _questions = getData();
    super.initState();
  }

  var index = 0;
  bool isPressed = false;
  int score = 0;
  bool isAlreadySelected = false;

  void nextQuestion(int questionLength) {
    if (index == questionLength - 1) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => ResultBox(
          result: score,
          questionLength: questionLength,
          onPressed: startOver,
        ),
      );
    } else {
      if (isPressed) {
        setState(() {
          index++;
          isPressed = false;
          isAlreadySelected = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please Select any Option'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(vertical: 20.0),
        ));
      }
    }
  }

  void checkAnswerAndUpdate(bool value) {
    if (isAlreadySelected) {
      return;
    } else {
      if (value == true) {
        score++;
      }
      setState(() {
        isPressed = true;
        isAlreadySelected = true;
      });
    }
  }

  void startOver() {
    setState(() {
      index = 0;
      score = 0;
      isPressed = false;
      isAlreadySelected = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _questions as Future<List<Question>>,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            var extractedData = snapshot.data as List<Question>;
            return Scaffold(
              backgroundColor:
                  Colors.transparent, // Make the background transparent
              appBar: AppBar(
                title: const Text('Quiz App'),
                backgroundColor: Colors.black,
                shadowColor: Colors.transparent,
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      'Score:$score',
                      style: const TextStyle(fontSize: 18.0),
                    ),
                  ),
                  IconButton(
                    icon: Image.asset('assets/image/cup.png'),
                    onPressed: () {},
                  )
                ],
              ),
              body: Stack(
                children: [
                  Image.asset(
                    'image/back.jpg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      children: [
                        QuestionWidget(
                          question: extractedData[index].title,
                          totalQuestions: extractedData.length,
                          indexAction: index,
                        ),
                        const Divider(color: neutral),
                        const SizedBox(height: 25.0),
                        for (int i = 0;
                            i < extractedData[index].options.length;
                            i++)
                          GestureDetector(
                            onTap: () => checkAnswerAndUpdate(
                                extractedData[index]
                                    .options
                                    .values
                                    .toList()[i]),
                            child: OptionCard(
                              option:
                                  extractedData[index].options.keys.toList()[i],
                              color: isPressed
                                  ? extractedData[index]
                                              .options
                                              .values
                                              .toList()[i] ==
                                          true
                                      ? correct
                                      : incorrect
                                  : neutral,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              floatingActionButton: GestureDetector(
                onTap: () => nextQuestion(extractedData.length),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: NextButton(),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            );
          }
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                const CircularProgressIndicator(),
                const SizedBox(height: 20.0),
                Text(
                  'Please wait till the questions are loading',
                  style: TextStyle(
                    color: Colors.yellow,
                    decoration: TextDecoration.none,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          );
        }
        return const Center(
          child: Text('No Data'),
        );
      },
    );
  }
}
