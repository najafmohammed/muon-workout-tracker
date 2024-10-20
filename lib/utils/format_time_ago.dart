import 'package:intl/intl.dart';

String formatTimeAgo(DateTime? dateTime) {
  if (dateTime == null) {
    return 'Never';
  }

  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inMinutes < 1) {
    return 'Just now';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hours ago';
  } else if (difference.inDays < 31) {
    return '${difference.inDays} days ago';
  } else {
    return DateFormat("dd-MM-yyyy").format(dateTime);
  }
}
