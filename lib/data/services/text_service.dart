/// Text formatting and manipulation service
class TextService {
  /// Converts a string to title case (first letter of each word capitalized)
  /// Except for small words like 'and', 'of', 'the', 'a', 'in', 'on', 'at', 'to', 'or', 'is'
  /// The first word is always capitalized
  /// Adds space after periods, then splits by spaces
  /// Example: "hello world and foo of bar.another sentence" -> "Hello World and Foo of Bar. Another Sentence"
  static String toCapitalized(String input) {
    if (input.isEmpty) return input;

    // List of words that should not be capitalized (unless they're first)
    const smallWords = {
      'and',
      'of',
      'the',
      'a',
      'in',
      'on',
      'at',
      'to',
      'or',
      'is',
      'by',
      'with',
      'as'
    };

    // Add space after periods if not already there
    String processed = input.replaceAll(RegExp(r'\.(?!\s)'), '. ');

    return processed
        .split(' ')
        .asMap()
        .entries
        .map((entry) {
          int index = entry.key;
          String word = entry.value;

          if (word.isEmpty) return word;

          // Capitalize first word always, others based on smallWords list
          if (index == 0 || !smallWords.contains(word.toLowerCase())) {
            return word[0].toUpperCase() + word.substring(1).toLowerCase();
          }

          return word.toLowerCase();
        })
        .join(' ');
  }
}
