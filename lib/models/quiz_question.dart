enum QuizType { chooseLetter, listenChoose, match }

class MatchPair {
  final String letter; // huruf Arab berharakat
  final String sound; // bunyi latin
  const MatchPair(this.letter, this.sound);
}

class QuizQuestion {
  final QuizType type;
  final String prompt;
  final List<String> options; // untuk chooseLetter & listenChoose
  final int correctIndex;
  final String correctLabel; // ditampilkan saat salah, mis. "kaf"
  final String? speakText; // untuk listenChoose
  final List<MatchPair> pairs; // untuk match

  const QuizQuestion({
    required this.type,
    required this.prompt,
    this.options = const [],
    this.correctIndex = 0,
    required this.correctLabel,
    this.speakText,
    this.pairs = const [],
  });
}
