extension StringExtension on String {
  String capitalize() {
    return toLowerCase().split(" ").map((word) => word[0].toUpperCase() + word.substring(1, word.length)).join(" ");
  }
}