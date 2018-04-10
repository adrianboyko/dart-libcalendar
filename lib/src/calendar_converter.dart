import 'package:logging/logging.dart';

///
/// Sources: http://aa.quae.nl/en/reken/juliaansedag.html
///

///
/// Converts Gregorian calendar, given by parameter [year], [month] and [day]
/// to Chronological Julian Day Number (CJDN).
///
int fromGregorianToCJDN(int year, int month, int day) {
  final Logger log = new Logger('libcalendar-fromGregorianToCJDN()');

  // Check year range.
  if (year < 1900 || year > 2100) {
    const String msg = 'Parameter [year] should be between 1900 to 2100.';
    log.severe(msg);
    throw new _CalendarConversionError(msg);
  }

  // Check month range.
  if (month < 1 || month > 12) {
    const String msg = 'Parameter [month] should be between 1 to 12.';
    log.severe(msg);
    throw new _CalendarConversionError(msg);
  }

  // Check day range.
  if (day < 1 || day > 31) {
    const String msg = 'Parameter [day] should be between 1 to 31.';
    log.severe(msg);
    throw new _CalendarConversionError(msg);
  }

  final int c0 = ((month - 3) / 12).floor();
  final int x4 = year + c0;
  final int x3 = (x4 / 100).floor();
  final int x2 = x4 % 100;
  final int x1 = month - (12 * c0) - 3;
  final int cjdn = ((146097 * x3) / 4).floor() + ((36525 * x2) / 100).floor() + (((153 * x1) + 2) / 5).floor() + day + 1721119;

  log
    ..info('c0 = $c0')
    ..info('x4 = $x4')
    ..info('x3 = $x3')
    ..info('x2 = $x2')
    ..info('x1 = $x1')
    ..info('cjdn = $cjdn');

  return cjdn;
}

///
/// Converts Chronological Julian Day Number (CJDN) given by parameter [cjdn]
/// to Gregorian calendar as [DateTime] object. The [DateTime] object returned
/// will be always in UTC.
///
DateTime fromCJDNtoGregorian(int cjdn) {
  final Logger log = new Logger('libcalendar-fromCJDNtoGregorian()');

  // Check range (1/1/1900 to 31/12/2100).
  if (cjdn < 2415021 || cjdn > 2488434) {
    const String msg = 'Parameter [cjdn] should be between 2415021 to 2488434.';
    log.severe(msg);
    throw new _CalendarConversionError(msg);
  }

  final int k3 = (4 * cjdn) - 6884477;
  final int x3 = (k3 / 146097).floor();
  final int r3 = k3 % 146097;

  final int k2 = (100 * (r3 / 4).floor()) + 99;
  final int x2 = (k2 / 36525).floor();
  final int r2 = k2 % 36525;

  final int k1 = (5 * (r2 / 100).floor()) + 2;
  final int x1 = (k1 / 153).floor();
  final int r1 = k1 % 153;

  final int c0 = ((x1 + 2) / 12).floor();
  final int day = (r1 / 5).floor() + 1;
  final int month = x1 - (12 * c0) + 3;
  final int year = (100 * x3) + x2 + c0;

  log
    ..info('x3 = $x3')
    ..info('x2 = $x2')
    ..info('x1 = $x1')
    ..info('c0 = $c0')
    ..info('day = $day')
    ..info('month = $month')
    ..info('year = $year');

  return new DateTime.utc(year, month, day);
}

///
/// Contains error information thrown by calendar converter methods.
///
class _CalendarConversionError extends Error {
  /* BEGIN FIELD SECTION */

  /// Brief message which tells why the error occured.
  final String reason;

  /* END FIELD SECTION */
  /* BEGIN CONSTRUCTOR SECTION */

  ///
  /// Create new [_CalendarConversionError].
  ///
  _CalendarConversionError(this.reason);

  /* END CONSTRUCTOR SECTION */
}
