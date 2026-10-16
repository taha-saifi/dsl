/**
 * Splits a sentence into word tokens: split on whitespace, strip leading and
 * trailing punctuation from each token, drop anything left empty. Doesn't
 * need to exactly replicate the backend's own tokenization — the backend
 * remains the final authority on whether a given word is valid either way.
 */
export function tokenize(text: string): string[] {
  return text
    .split(/\s+/)
    .map((token) => token.replace(/^[^\p{L}\p{N}]+|[^\p{L}\p{N}]+$/gu, ""))
    .filter((token) => token.length > 0);
}
