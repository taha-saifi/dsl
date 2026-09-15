export interface LanguageOption {
  code: string;
  label: string;
}

/**
 * A curated set of common languages for the dropdown pickers throughout the
 * app. The backend only validates a 2-letter code pattern (no fixed enum),
 * so this list is a UX convenience, not an enforced constraint — any code
 * already stored (e.g. from before this list existed) still round-trips
 * fine, it just won't have a friendly label if it's not in this set.
 */
export const LANGUAGES: LanguageOption[] = [
  { code: "en", label: "English" },
  { code: "fr", label: "French" },
  { code: "es", label: "Spanish" },
  { code: "de", label: "German" },
  { code: "it", label: "Italian" },
  { code: "pt", label: "Portuguese" },
  { code: "nl", label: "Dutch" },
  { code: "ru", label: "Russian" },
  { code: "pl", label: "Polish" },
  { code: "tr", label: "Turkish" },
  { code: "ar", label: "Arabic" },
  { code: "he", label: "Hebrew" },
  { code: "hi", label: "Hindi" },
  { code: "ur", label: "Urdu" },
  { code: "fa", label: "Persian" },
  { code: "zh", label: "Chinese" },
  { code: "ja", label: "Japanese" },
  { code: "ko", label: "Korean" },
  { code: "vi", label: "Vietnamese" },
  { code: "th", label: "Thai" },
  { code: "id", label: "Indonesian" },
  { code: "ms", label: "Malay" },
  { code: "sv", label: "Swedish" },
  { code: "no", label: "Norwegian" },
  { code: "da", label: "Danish" },
  { code: "fi", label: "Finnish" },
  { code: "el", label: "Greek" },
  { code: "cs", label: "Czech" },
  { code: "sk", label: "Slovak" },
  { code: "hu", label: "Hungarian" },
  { code: "ro", label: "Romanian" },
  { code: "bg", label: "Bulgarian" },
  { code: "uk", label: "Ukrainian" },
];

/** Friendly label for a language code, falling back to the code itself
 * (uppercased) for anything outside the curated list above. */
export function languageLabel(code: string): string {
  const normalized = code.toLowerCase();
  const found = LANGUAGES.find((lang) => lang.code === normalized);
  return found ? found.label : code.toUpperCase();
}

/** Builds a de-duplicated language option list from a set of raw codes,
 * used to restrict a question form's language pickers to a course's own
 * source/target languages instead of the full curated list. */
export function languageOptionsFromCodes(codes: string[]): LanguageOption[] {
  const seen = new Set<string>();
  const options: LanguageOption[] = [];
  for (const code of codes) {
    const normalized = code.toLowerCase();
    if (!normalized || seen.has(normalized)) continue;
    seen.add(normalized);
    options.push({ code: normalized, label: languageLabel(normalized) });
  }
  return options;
}
