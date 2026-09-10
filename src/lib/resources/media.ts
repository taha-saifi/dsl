import { apiRequest, apiUpload } from "@/lib/api";
import type { Media } from "@/types";

export function listMedia(filter?: { type: Media["type"] }) {
  const query = filter?.type ? `?type=${encodeURIComponent(filter.type)}` : "";
  return apiRequest<Media[]>(`/media${query}`);
}

export function getMedia(id: string) {
  return apiRequest<Media>(`/media/${id}`);
}

export function uploadMedia(file: File) {
  const formData = new FormData();
  formData.append("file", file);
  return apiUpload<Media>("/media/upload", formData);
}
