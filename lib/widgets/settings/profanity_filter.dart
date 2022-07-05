import 'profanity.dart';

bool containsProfanity(String input) {
  return profanity.any((element) => input.contains(element));
}

bool isSafe(String input) {
  return !containsProfanity(input);
}
