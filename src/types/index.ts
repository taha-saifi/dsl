export interface User {
  _id: string;
  email: string;
  role: "admin" | "teacher" | "student";
  firstName: string;
  lastName: string;
}

export interface Specialization {
  _id: string;
  name: string;
  slug: string;
  iconUrl?: string;
}

export interface Course {
  _id: string;
  specializationId: string;
  thumbnailMediaId?: string;
  name: string;
  sourceLanguage: string;
  targetLanguage: string;
  description?: string;
  isPublished: boolean;
}

export interface Unit {
  _id: string;
  courseId: string;
  name: string;
  orderIndex: number;
  isPublished: boolean;
  learningItems: { learningItemId: string; order: number }[];
}

export interface Media {
  _id: string;
  type: "image" | "audio" | "video";
  url: string;
  filename: string;
  mimeType: string;
  sizeBytes: number;
  createdAt: string;
}

export interface Translation {
  language: string;
  text: string;
  pronunciation?: string;
  ipa?: string;
  audioMediaId?: string;
}

export interface LearningItem {
  _id: string;
  imageMediaId?: string;
  type: "word" | "phrase" | "sentence";
  translations: Translation[];
}
