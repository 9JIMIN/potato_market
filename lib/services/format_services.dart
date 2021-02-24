class FormatServices {
  static String date(DateTime dateTime) {
    final Duration diff = DateTime.now().difference(dateTime);
    if (diff.inDays > 0) {
      return diff.inDays.toString() + '일 전';
    }
    if (diff.inHours > 0) {
      return diff.inHours.toString() + '시간 전';
    }
    if (diff.inMinutes > 0) {
      return diff.inMinutes.toString() + '분 전';
    }
    if (diff.inSeconds > 0) {
      return diff.inSeconds.toString() + '초 전';
    }
    return '방금';
  }

  static String price(int price) {
    String p = price.toString();
    String uk;
    String bak;
    String won;

    // 9999억이 한계 => max길이 = 11
    if (p.length >= 9) {
      uk = p.substring(0, p.length - 8) + '억';
      p = int.parse(p.substring(p.length - 8, p.length)).toString();
    }
    if (p.length == 8 && p.substring(0, 2) != '00') {
      bak = p.substring(0, 4) + '만';
      if (p.substring(4, 8) != '0000') {
        won = int.parse(p.substring(4, 8)).toString() + '원';
      } else {
        won = '원';
      }
    }
    if (p.length == 7 && p[0] != '0') {
      bak = p.substring(0, 3) + '만';
      if (p.substring(3, 7) != '0000') {
        won = int.parse(p.substring(3, 7)).toString() + '원';
      } else {
        won = '원';
      }
    }
    if (won == null && p.length == 8) {
      p = int.parse(p).toString();
    }
    if (won == null) {
      if (p.length >= 4) {
        won = p.substring(0, p.length - 3) +
            ',' +
            p.substring(p.length - 3, p.length) +
            '원';
      } else {
        won = p == '0' ? '원' : p + '원';
      }
    }
    String result = '';
    if (uk != null) {
      result += uk;
    }
    if (bak != null) {
      if (result != '') {
        result += ' ';
      }
      result += bak;
    }
    if (won == '원') {
      result += won;
    } else {
      if (result != '') {
        result += ' ';
      }
      result += won;
    }
    return result;
  }
}
