String dateFormatter(String dateArg) {
  DateTime date = DateTime.parse(dateArg);
  DateTime now = DateTime.now();
  int difference;
  if (date.year == now.year) {
    if (date.month == now.month) {
      if (date.day == now.day) {
        if (date.hour == now.hour) {
          if (date.minute == now.minute) {
            return 'just now';
          } else {
            difference = now.minute - date.minute;
            return '$difference minute${difference > 1 ? 's' : ''} ago';
          }
        } else {
          difference = now.hour - date.hour;
          int minuteDifference = 60 - (date.minute - now.minute).abs();
          if (difference == 1 && minuteDifference < 60) {
            return '$minuteDifference minute${minuteDifference > 1 ? 's' : ''} ago';
          }
          return '$difference hour${difference > 1 ? 's' : ''} ago';
        }
      } else {
        difference = now.day - date.day;
        int hourDifference = 24 - (now.hour - date.hour).abs();
        if (difference == 1 && hourDifference < 24) {
          return '$hourDifference hour${hourDifference > 1 ? 's' : ''} ago';
        }
        return difference > 1 ? '$difference days ago' : 'yesterday';
      }
    } else {
      difference = now.month - date.month;
      return '$difference month${difference > 1 ? 's' : ''} ago';
    }
  } else {
    difference = now.year - date.year;
    return '$difference year${difference > 1 ? 's' : ''} ago';
  }
}
