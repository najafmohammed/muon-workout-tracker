String formatTime(int totalSeconds) {
  if (totalSeconds < 60) {
    return '1 m'; // Showing as '1 minute' for less than 60 seconds
  } else if (totalSeconds < 3600) {
    int minutes = totalSeconds ~/ 60;
    return '${minutes} m${minutes > 1 ? 's' : ''}';
  } else {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    return '${hours}h ${minutes}m';
  }
}

String formatVolume(double totalVolume) {
  if (totalVolume >= 100) {
    return '${(totalVolume / 1000).toStringAsFixed(1)} t'; // Convert to tons
  } else {
    return '${totalVolume.toStringAsFixed(1)} kg'; // Display in kg
  }
}
