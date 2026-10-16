import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { LANGUAGES, type LanguageOption } from "@/lib/languages";

interface LanguageSelectProps {
  id?: string;
  value: string;
  onChange: (value: string) => void;
  /** Defaults to the full curated language list; pass a narrower set (e.g.
   * a course's own source/target languages) to restrict the choices. */
  options?: LanguageOption[];
  placeholder?: string;
  disabled?: boolean;
}

export default function LanguageSelect({
  id,
  value,
  onChange,
  options = LANGUAGES,
  placeholder = "Select language",
  disabled,
}: LanguageSelectProps) {
  return (
    <Select
      value={value || undefined}
      onValueChange={(next) => onChange(next ?? "")}
      disabled={disabled}
    >
      <SelectTrigger id={id} className="w-full">
        <SelectValue placeholder={placeholder} />
      </SelectTrigger>
      <SelectContent>
        {options.map((lang) => (
          <SelectItem key={lang.code} value={lang.code}>
            {lang.label} ({lang.code})
          </SelectItem>
        ))}
      </SelectContent>
    </Select>
  );
}
