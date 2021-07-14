import 'dart:ui';

import 'package:country_codes/country_codes.dart';

class DGCCountryParser {
  static CountryDetails? fromCountryCode(String alpha2Code) {
    try {
      Locale l = Locale.fromSubtags(countryCode: alpha2Code);
      return CountryCodes.detailsForLocale(l);
    } catch (_) {
      return null;
    }
  }
}