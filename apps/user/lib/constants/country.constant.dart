class CountryModel {
  final String name;
  final String flag;
  final String dialCode;
  final int maxLength;

  const CountryModel({
    required this.name,
    required this.flag,
    required this.dialCode,
    required this.maxLength,
  });
}

class CountryConstant {
  static const String SEARCH_COUNTRY = 'Search country';

  static const List<CountryModel> COUNTRIES = [
    CountryModel(name: 'United States', flag: '🇺🇸', dialCode: '+1', maxLength: 10),
    CountryModel(name: 'United Kingdom', flag: '🇬🇧', dialCode: '+44', maxLength: 10),
    CountryModel(name: 'India', flag: '🇮🇳', dialCode: '+91', maxLength: 10),
    CountryModel(name: 'Australia', flag: '🇦🇺', dialCode: '+61', maxLength: 9),
    CountryModel(name: 'Canada', flag: '🇨🇦', dialCode: '+1', maxLength: 10),
    CountryModel(name: 'Singapore', flag: '🇸🇬', dialCode: '+65', maxLength: 8),
    CountryModel(name: 'United Arab Emirates', flag: '🇦🇪', dialCode: '+971', maxLength: 9),
  ];
}
