class Fmt {
  Fmt._();

  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  /// Indian digit grouping: 125000 -> ₹1,25,000
  static String rupees(num value) {
    final negative = value < 0;
    final n = value.abs().round().toString();
    String grouped;
    if (n.length <= 3) {
      grouped = n;
    } else {
      final last3 = n.substring(n.length - 3);
      var rest = n.substring(0, n.length - 3);
      final parts = <String>[];
      while (rest.length > 2) {
        parts.insert(0, rest.substring(rest.length - 2));
        rest = rest.substring(0, rest.length - 2);
      }
      if (rest.isNotEmpty) parts.insert(0, rest);
      grouped = '${parts.join(',')},$last3';
    }
    return '${negative ? '-' : ''}₹$grouped';
  }

  /// 27 Oct 2026
  static String date(DateTime d) =>
      '${d.day} ${_months[d.month - 1]} ${d.year}';

  /// 02:30 PM
  static String time(DateTime d) {
    final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final m = d.minute.toString().padLeft(2, '0');
    final ap = d.hour >= 12 ? 'PM' : 'AM';
    return '${h.toString().padLeft(2, '0')}:$m $ap';
  }

  /// 27 Oct 2026, 02:30 PM IST
  static String dateTime(DateTime d) => '${date(d)}, ${time(d)} IST';

  static String km(num v) => '${v.round()} km';
}
