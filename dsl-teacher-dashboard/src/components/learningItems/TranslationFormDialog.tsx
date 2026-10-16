import { useEffect, useState, type FormEvent } from "react";
import { Button } from "@/components/ui/button";
import {
  Dialog,
  DialogContent,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import LanguageSelect from "@/components/LanguageSelect";
import MediaAttachField from "@/components/media/MediaAttachField";
import {
  addTranslation,
  updateTranslation,
} from "@/lib/resources/learningItems";
import type { LearningItem, Translation } from "@/types";

interface TranslationFormDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  itemId: string;
  translation?: Translation;
  onSaved: (learningItem: LearningItem) => void;
}

export default function TranslationFormDialog({
  open,
  onOpenChange,
  itemId,
  translation,
  onSaved,
}: TranslationFormDialogProps) {
  const isEdit = Boolean(translation);
  const [language, setLanguage] = useState("");
  const [text, setText] = useState("");
  const [pronunciation, setPronunciation] = useState("");
  const [ipa, setIpa] = useState("");
  const [audioMediaId, setAudioMediaId] = useState<string | undefined>(
    undefined,
  );
  const [error, setError] = useState<string | null>(null);
  const [submitting, setSubmitting] = useState(false);

  useEffect(() => {
    if (open) {
      setLanguage(translation?.language ?? "");
      setText(translation?.text ?? "");
      setPronunciation(translation?.pronunciation ?? "");
      setIpa(translation?.ipa ?? "");
      setAudioMediaId(translation?.audioMediaId);
      setError(null);
      setSubmitting(false);
    }
  }, [open, translation]);

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    setError(null);

    if (!isEdit && !language) {
      setError("Select a language.");
      return;
    }

    setSubmitting(true);
    try {
      const saved =
        isEdit && translation
          ? await updateTranslation(itemId, translation.language, {
              text: text.trim(),
              pronunciation: pronunciation.trim() || undefined,
              ipa: ipa.trim() || undefined,
              audioMediaId,
            })
          : await addTranslation(itemId, {
              language: language.toLowerCase(),
              text: text.trim(),
              pronunciation: pronunciation.trim() || undefined,
              ipa: ipa.trim() || undefined,
              audioMediaId,
            });
      onSaved(saved);
      onOpenChange(false);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Something went wrong");
    } finally {
      setSubmitting(false);
    }
  }

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent>
        <form onSubmit={handleSubmit}>
          <DialogHeader>
            <DialogTitle>
              {isEdit ? "Edit Translation" : "Add Translation"}
            </DialogTitle>
          </DialogHeader>

          {error && (
            <div className="rounded-md bg-red-50 px-3 py-2 text-sm text-red-600">
              {error}
            </div>
          )}

          <div className="flex flex-col gap-4 py-2">
            <div className="flex flex-col gap-1.5">
              <Label htmlFor="translation-language">Language</Label>
              <LanguageSelect
                id="translation-language"
                disabled={isEdit}
                value={language}
                onChange={setLanguage}
              />
            </div>
            <div className="flex flex-col gap-1.5">
              <Label htmlFor="translation-text">Text</Label>
              <Input
                id="translation-text"
                required
                value={text}
                onChange={(e) => setText(e.target.value)}
              />
            </div>
            <div className="flex flex-col gap-1.5">
              <Label htmlFor="translation-pronunciation">Pronunciation</Label>
              <Input
                id="translation-pronunciation"
                value={pronunciation}
                onChange={(e) => setPronunciation(e.target.value)}
              />
            </div>
            <div className="flex flex-col gap-1.5">
              <Label htmlFor="translation-ipa">IPA</Label>
              <Input
                id="translation-ipa"
                value={ipa}
                onChange={(e) => setIpa(e.target.value)}
              />
            </div>
            <div className="flex flex-col gap-1.5">
              <Label>Audio</Label>
              <MediaAttachField
                mediaId={audioMediaId}
                mediaType="audio"
                label="Audio"
                onChange={setAudioMediaId}
              />
            </div>
          </div>

          <DialogFooter>
            <Button type="submit" disabled={submitting}>
              {submitting ? "Saving..." : "Save"}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}
