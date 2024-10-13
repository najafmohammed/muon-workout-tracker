// Function to calculate the longest streak of workout days
int calculateLongestStreak(Set<DateTime> workoutDays) {
  if (workoutDays.isEmpty) return 0;

  // Sort the workout days
  List<DateTime> sortedDays = workoutDays.toList()..sort();
  int longestStreak = 1;
  int currentStreak = 1;

  for (int i = 1; i < sortedDays.length; i++) {
    if (sortedDays[i].difference(sortedDays[i - 1]).inDays == 1) {
      // If the current day is consecutive to the previous day
      currentStreak++;
    } else {
      // Reset the current streak
      longestStreak =
          currentStreak > longestStreak ? currentStreak : longestStreak;
      currentStreak = 1; // Reset for a new streak
    }
  }
  // Check at the end in case the longest streak ends on the last day
  longestStreak = currentStreak > longestStreak ? currentStreak : longestStreak;

  return longestStreak;
}
