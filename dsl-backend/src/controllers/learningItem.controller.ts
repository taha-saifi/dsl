import type { Request, Response } from "express";
import { Types } from "mongoose";

import { ApiError } from "../middleware/error.middleware";
import LearningItem, {
  type ILearningItem,
  type ITranslation,
  type LearningItemType,
} from "../models/LearningItem";
import { ensureMediaHasType } from "../services/mediaReference.service";
import { ensureLearningItemHasNoUnitReferences } from "../services/resourceDependencies.service";
import {
  getBodyObject,
  getOptionalObjectId,
  getOptionalString,
  getRequiredObjectId,
  getRequiredString,
  getRouteObjectId,
} from "../utils/requestValidation";

const learningItemTypes = new Set<LearningItemType>(["word", "phrase", "sentence"]);

const getLearningItemType = (value: unknown): LearningItemType => {
  const type = getRequiredString(value, "Type");
  if (!learningItemTypes.has(type as LearningItemType)) {
    throw new ApiError(400, "Type must be word, phrase, or sentence.", "VALIDATION_ERROR");
  }

  return type as LearningItemType;
};

const getLanguage = (value: unknown): string => {
  const language = getRequiredString(value, "Language").toLowerCase();
  if (!/^[a-z]{2}$/.test(language)) {
    throw new ApiError(400, "Language must be a two-letter code.", "VALIDATION_ERROR");
  }

  return language;
};

const getImageMediaId = async (value: unknown): Promise<Types.ObjectId | null | undefined> => {
  if (value === undefined) {
    return undefined;
  }
  if (value === null) {
    return null;
  }

  const imageMediaId = getRequiredObjectId(value, "Image media ID");
  await ensureMediaHasType(imageMediaId, "image", "imageMediaId");
  return imageMediaId;
};

const getTranslation = async (value: unknown): Promise<ITranslation> => {
  const body = getBodyObject(value);
  const language = getLanguage(body.language);
  const text = getRequiredString(body.text, "Text");
  const pronunciation = getOptionalString(body.pronunciation, "Pronunciation");
  const ipa = getOptionalString(body.ipa, "IPA");
  const audioMediaId = getOptionalObjectId(body.audioMediaId, "Audio media ID");

  if (audioMediaId !== undefined) {
    await ensureMediaHasType(audioMediaId, "audio", "audioMediaId");
  }

  return {
    language,
    text,
    ...(pronunciation !== undefined ? { pronunciation } : {}),
    ...(ipa !== undefined ? { ipa } : {}),
    ...(audioMediaId !== undefined ? { audioMediaId } : {}),
  };
};

const getUpdatedTranslation = async (value: unknown): Promise<Partial<ITranslation>> => {
  const body = getBodyObject(value);
  const update: Partial<ITranslation> = {};
  const text = getOptionalString(body.text, "Text");
  const pronunciation = getOptionalString(body.pronunciation, "Pronunciation");
  const ipa = getOptionalString(body.ipa, "IPA");
  const audioMediaId = getOptionalObjectId(body.audioMediaId, "Audio media ID");

  if (text !== undefined) update.text = text;
  if (pronunciation !== undefined) update.pronunciation = pronunciation;
  if (ipa !== undefined) update.ipa = ipa;
  if (audioMediaId !== undefined) {
    await ensureMediaHasType(audioMediaId, "audio", "audioMediaId");
    update.audioMediaId = audioMediaId;
  }

  if (Object.keys(update).length === 0) {
    throw new ApiError(400, "At least one translation field is required.", "VALIDATION_ERROR");
  }

  return update;
};

const findLearningItem = async (learningItemId: Types.ObjectId) => {
  const learningItem = await LearningItem.findById(learningItemId);
  if (!learningItem) {
    throw new ApiError(404, "Learning item not found.", "LEARNING_ITEM_NOT_FOUND");
  }

  return learningItem;
};

const escapeRegex = (value: string): string => value.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");

export const list = async (request: Request, response: Response): Promise<void> => {
  const typeQuery = request.query.type;
  const searchQuery = request.query.search;
  const filter: { type?: LearningItemType; "translations.text"?: RegExp } = {};

  if (typeQuery !== undefined) {
    filter.type = getLearningItemType(typeQuery);
  }
  if (searchQuery !== undefined) {
    filter["translations.text"] = new RegExp(escapeRegex(getRequiredString(searchQuery, "search")), "i");
  }

  const learningItems = await LearningItem.find(filter).sort({ createdAt: -1 });
  response.status(200).json({ data: learningItems });
};

export const getById = async (request: Request, response: Response): Promise<void> => {
  const learningItem = await findLearningItem(getRouteObjectId(request.params.id, "Learning item"));
  response.status(200).json({ data: learningItem });
};

export const create = async (request: Request, response: Response): Promise<void> => {
  if (!request.user) {
    throw new ApiError(401, "Unauthorized.", "UNAUTHORIZED");
  }

  const body = getBodyObject(request.body as unknown);
  const type = getLearningItemType(body.type);
  const imageMediaId = await getImageMediaId(body.imageMediaId);
  let translations: ITranslation[] = [];
  if (body.translations !== undefined) {
    if (!Array.isArray(body.translations)) {
      throw new ApiError(400, "translations must be an array.", "VALIDATION_ERROR");
    }
    translations = await Promise.all(body.translations.map((translation) => getTranslation(translation)));
  }

  const learningItem = await LearningItem.create({
    createdBy: request.user._id,
    type,
    translations,
    ...(imageMediaId !== undefined ? { imageMediaId } : {}),
  });
  response.status(201).json({ data: learningItem });
};

export const update = async (request: Request, response: Response): Promise<void> => {
  const learningItemId = getRouteObjectId(request.params.id, "Learning item");
  const body = getBodyObject(request.body as unknown);
  const update: Partial<Pick<ILearningItem, "type" | "imageMediaId">> = {};

  if (body.type !== undefined) {
    update.type = getLearningItemType(body.type);
  }
  if (body.imageMediaId !== undefined) {
    const imageMediaId = await getImageMediaId(body.imageMediaId);
    if (imageMediaId !== undefined) {
      update.imageMediaId = imageMediaId;
    }
  }

  if (Object.keys(update).length === 0) {
    throw new ApiError(400, "Type or imageMediaId is required.", "VALIDATION_ERROR");
  }

  const learningItem = await LearningItem.findByIdAndUpdate(learningItemId, update, {
    new: true,
    runValidators: true,
  });
  if (!learningItem) {
    throw new ApiError(404, "Learning item not found.", "LEARNING_ITEM_NOT_FOUND");
  }

  response.status(200).json({ data: learningItem });
};

export const remove = async (request: Request, response: Response): Promise<void> => {
  const learningItemId = getRouteObjectId(request.params.id, "Learning item");
  const learningItem = await findLearningItem(learningItemId);
  await ensureLearningItemHasNoUnitReferences(learningItemId);
  await learningItem.deleteOne();
  response.status(200).json({ data: { id: learningItem.id } });
};

export const addTranslation = async (request: Request, response: Response): Promise<void> => {
  const learningItem = await findLearningItem(getRouteObjectId(request.params.id, "Learning item"));
  const translation = await getTranslation(request.body as unknown);

  if (learningItem.translations.some((item) => item.language === translation.language)) {
    throw new ApiError(
      409,
      "A translation with that language already exists.",
      "TRANSLATION_LANGUAGE_IN_USE",
    );
  }

  learningItem.translations.push(translation);
  await learningItem.save();
  response.status(201).json({ data: learningItem });
};

export const updateTranslation = async (request: Request, response: Response): Promise<void> => {
  const learningItem = await findLearningItem(getRouteObjectId(request.params.id, "Learning item"));
  const language = getLanguage(request.params.language);
  const translation = learningItem.translations.find((item) => item.language === language);
  if (!translation) {
    throw new ApiError(404, "Translation not found.", "TRANSLATION_NOT_FOUND");
  }

  Object.assign(translation, await getUpdatedTranslation(request.body as unknown));
  await learningItem.save();
  response.status(200).json({ data: learningItem });
};

export const removeTranslation = async (request: Request, response: Response): Promise<void> => {
  const learningItem = await findLearningItem(getRouteObjectId(request.params.id, "Learning item"));
  const language = getLanguage(request.params.language);
  const translationIndex = learningItem.translations.findIndex((item) => item.language === language);
  if (translationIndex === -1) {
    throw new ApiError(404, "Translation not found.", "TRANSLATION_NOT_FOUND");
  }

  learningItem.translations.splice(translationIndex, 1);
  await learningItem.save();
  response.status(200).json({ data: learningItem });
};
