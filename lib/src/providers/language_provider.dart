import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  String _currentLanguage = 'en';
  late SharedPreferences _prefs;
  bool _isInitialized = false;

  String get currentLanguage => _currentLanguage;
  bool get isInitialized => _isInitialized;

  // Initialize the provider by loading saved language preference
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    _prefs = await SharedPreferences.getInstance();
    _currentLanguage = _prefs.getString('app_language') ?? 'en';
    _isInitialized = true;
    notifyListeners();
  }

  // Change language and persist to SharedPreferences
  Future<void> setLanguage(String languageCode) async {
    if (_currentLanguage == languageCode) return;
    
    _currentLanguage = languageCode;
    await _prefs.setString('app_language', languageCode);
    notifyListeners();
  }

  // Get language name in English
  String getLanguageName(String code) {
    const Map<String, String> languageNames = {
      'en': 'English',
      'hi': 'Hindi',
      'pa': 'Punjabi',
      'mr': 'Marathi',
      'gu': 'Gujarati',
      'ta': 'Tamil',
      'te': 'Telugu',
      'kn': 'Kannada',
      'ml': 'Malayalam',
      'bn': 'Bengali',
      'or': 'Odia',
      'as': 'Assamese',
      'ur': 'Urdu',
      'sa': 'Sanskrit',
      'raj': 'Rajasthani',
      'bho': 'Bhojpuri',
    };
    return languageNames[code] ?? 'Unknown';
  }

  // Get language name in native script
  String getNativeLanguageName(String code) {
    const Map<String, String> nativeNames = {
      'en': 'English',
      'hi': 'हिन्दी',
      'pa': 'ਪੰਜਾਬੀ',
      'mr': 'मराठी',
      'gu': 'ગુજરાતી',
      'ta': 'தமிழ்',
      'te': 'తెలుగు',
      'kn': 'ಕನ್ನಡ',
      'ml': 'മലയാളം',
      'bn': 'বাংলা',
      'or': 'ଓଡ଼ିଆ',
      'as': 'অসমীয়া',
      'ur': 'اردو',
      'sa': 'संस्कृतम्',
      'raj': 'राजस्थानी',
      'bho': 'भोजपुरी',
    };
    return nativeNames[code] ?? 'Unknown';
  }
}
