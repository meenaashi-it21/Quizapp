import 'package:flutter/material.dart';
import '../constants.dart';

class NextButton extends StatelessWidget {
  const NextButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/image/bu.png', // Replace with the actual path to your image
            width: 30, // Adjust the width as needed
            height: 30, // Adjust the height as needed
          ),
          const SizedBox(width: 10), // Add spacing between the image and text
          const Text(
            'Next Question',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
