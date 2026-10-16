/// Display names for target-language codes. The API stores only 2-letter
/// codes with no fixed list (docs/contracts/api-contract.md), like the
/// dashboard's `src/lib/languages.ts`; unknown codes show as the code.
class LanguageName {
  const LanguageName(this.english, this.native);

  final String english;
  final String native;

  static const _names = {
    'ar': LanguageName('Arabic', 'العربية'),
    'de': LanguageName('German', 'Deutsch'),
    'en': LanguageName('English', 'English'),
    'es': LanguageName('Spanish', 'Español'),
    'fr': LanguageName('French', 'Français'),
    'it': LanguageName('Italian', 'Italiano'),
    'ja': LanguageName('Japanese', '日本語'),
    'ko': LanguageName('Korean', '한국어'),
    'nl': LanguageName('Dutch', 'Nederlands'),
    'pl': LanguageName('Polish', 'Polski'),
    'pt': LanguageName('Portuguese', 'Português'),
    'ru': LanguageName('Russian', 'Русский'),
    'tr': LanguageName('Turkish', 'Türkçe'),
    'zh': LanguageName('Chinese', '中文'),
  };

  static LanguageName of(String code) =>
      _names[code] ?? LanguageName(code.toUpperCase(), code.toUpperCase());
}
