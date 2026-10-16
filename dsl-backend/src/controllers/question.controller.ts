import type { Request, Response } from "express";
import { Types } from "mongoose";

import { ApiError } from "../middleware/error.middleware";
import LearningItem, { type ILearningItem } from "../models/LearningItem";
import Question, {
  type IQuestionItem,
  type QuestionItemRole,
  type QuestionType,
  questionItemRoles,
  questionTypes,
} from "../models/Question";
import { validateQuestionForType } from "../services/questionValidation.service";
import { ensureExerciseExists, ensureLearningItemExists } from "../services/resourceDependencies.service";
import {
  getBodyObject,
  getOptionalNumber,
  getOptionalObjectId,
  getRequiredNumber,
  getRequiredObjectId,
  getRequiredString,
  getRouteObjectId,
} from "../utils/requestValidation";

interface ReorderEntry {
  id: Types.ObjectId;
  orderIndex: number;
}

const questionTypeSet = new Set<QuestionType>(questionTypes);
const questionItemRoleSet = new Set<QuestionItemRole>(questionItemRoles);

const getQuestionType = (value: unknown): QuestionType => {
  const type = getRequiredString(value, "Type");
  if (!questionTypeSet.has(type as QuestionType)) {
    throw new ApiError(
      400,
      `Type must be one of: ${questionTypes.join(", ")}.`,
      "VALIDATION_ERROR",
    );
  }

  return type as QuestionType;
};

const getQuestionItem = async (value: unknown): Promise<IQuestionItem> => {
  const body = getBodyObject(value);
  const learningItemId = getRequiredObjectId(body.learningItemId, "Learning item ID");
  await ensureLearningItemExists(learningItemId);

  const role = getRequiredString(body.role, "Role");
  if (!questionItemRoleSet.has(role as QuestionItemRole)) {
    throw new ApiError(
      400,
      `Role must be one of: ${questionItemRoles.join(", ")}.`,
      "VALIDATION_ERROR",
    );
  }

  const displayOrder = getRequiredNumber(body.displayOrder, "displayOrder");

  return { learningItemId, role: role as QuestionItemRole, displayOrder };
};

const getQuestionItems = async (value: unknown): Promise<IQuestionItem[]> => {
  if (!Array.isArray(value)) {
    throw new ApiError(400, "items must be an array.", "VALIDATION_ERROR");
  }

  return Promise.all(value.map((item) => getQuestionItem(item)));
};

const fetchLearningItemDocs = async (items: IQuestionItem[]): Promise<Map<string, ILearningItem>> => {
  const learningItemIds = items.map((item) => item.learningItemId);
  const learningItems = await LearningItem.find({ _id: { $in: learningItemIds } });
  return new Map(learningItems.map((learningItem) => [learningItem.id, learningItem]));
};

const getQuestionUpdate = async (body: Record<string, unknown>): Promise<Record<string, unknown>> => {
  const update: Record<string, unknown> = {};
  const exerciseId = getOptionalObjectId(body.exerciseId, "Exercise ID");
  const orderIndex = getOptionalNumber(body.orderIndex, "orderIndex");
  const points = getOptionalNumber(body.points, "points");

  if (exerciseId !== undefined) {
    await ensureExerciseExists(exerciseId);
    update.exerciseId = exerciseId;
  }
  if (body.type !== undefined) {
    update.type = getQuestionType(body.type);
  }
  if (orderIndex !== undefined) update.orderIndex = orderIndex;
  if (points !== undefined) update.points = points;
  if (body.items !== undefined) {
    update.items = await getQuestionItems(body.items);
  }
  if (body.config !== undefined) {
    update.config = body.config;
  }

  return update;
};

export const list = async (request: Request, response: Response): Promise<void> => {
  const exerciseIdQuery = request.query.exerciseId;
  const filter: { exerciseId?: Types.ObjectId } = {};
  if (exerciseIdQuery !== undefined) {
    filter.exerciseId = getRequiredObjectId(exerciseIdQuery, "exerciseId");
  }

  const questions = await Question.find(filter).sort({ orderIndex: 1 });
  response.status(200).json({ data: questions });
};

export const getById = async (request: Request, response: Response): Promise<void> => {
  const questionId = getRouteObjectId(request.params.id, "Question");
  const question = await Question.findById(questionId);
  if (!question) {
    throw new ApiError(404, "Question not found.", "QUESTION_NOT_FOUND");
  }

  response.status(200).json({ data: question });
};

export const create = async (request: Request, response: Response): Promise<void> => {
  const body = getBodyObject(request.body as unknown);
  const exerciseId = getRequiredObjectId(body.exerciseId, "Exercise ID");
  await ensureExerciseExists(exerciseId);

  const type = getQuestionType(body.type);
  const orderIndex = getRequiredNumber(body.orderIndex, "orderIndex");
  const points = getOptionalNumber(body.points, "points");
  const items = body.items !== undefined ? await getQuestionItems(body.items) : [];

  const learningItemDocsById = await fetchLearningItemDocs(items);
  validateQuestionForType(type, body.config, items, learningItemDocsById);

  const question = await Question.create({
    exerciseId,
    type,
    orderIndex,
    items,
    ...(points !== undefined ? { points } : {}),
    ...(body.config !== undefined ? { config: body.config } : {}),
  });
  response.status(201).json({ data: question });
};

export const update = async (request: Request, response: Response): Promise<void> => {
  const questionId = getRouteObjectId(request.params.id, "Question");
  const existing = await Question.findById(questionId);
  if (!existing) {
    throw new ApiError(404, "Question not found.", "QUESTION_NOT_FOUND");
  }

  const update = await getQuestionUpdate(getBodyObject(request.body as unknown));

  const finalType = (update.type as QuestionType | undefined) ?? existing.type;
  const finalItems = (update.items as IQuestionItem[] | undefined) ?? existing.items;
  const finalConfig = update.config !== undefined ? update.config : existing.config;

  const learningItemDocsById = await fetchLearningItemDocs(finalItems);
  validateQuestionForType(finalType, finalConfig, finalItems, learningItemDocsById);

  const question = await Question.findByIdAndUpdate(questionId, update, {
    new: true,
    runValidators: true,
  });
  if (!question) {
    throw new ApiError(404, "Question not found.", "QUESTION_NOT_FOUND");
  }

  response.status(200).json({ data: question });
};

export const remove = async (request: Request, response: Response): Promise<void> => {
  const questionId = getRouteObjectId(request.params.id, "Question");
  const question = await Question.findByIdAndDelete(questionId);
  if (!question) {
    throw new ApiError(404, "Question not found.", "QUESTION_NOT_FOUND");
  }

  response.status(200).json({ data: { id: question.id } });
};

export const reorder = async (request: Request, response: Response): Promise<void> => {
  if (!Array.isArray(request.body) || request.body.length === 0) {
    throw new ApiError(400, "Request body must be a non-empty array.", "VALIDATION_ERROR");
  }

  const entries: ReorderEntry[] = request.body.map((entry) => {
    const item = getBodyObject(entry);
    return {
      id: getRequiredObjectId(item.id, "Question ID"),
      orderIndex: getRequiredNumber(item.orderIndex, "orderIndex"),
    };
  });
  const questionIds = entries.map((entry) => entry.id);
  if (new Set(questionIds.map((id) => id.toString())).size !== questionIds.length) {
    throw new ApiError(400, "Each question may appear only once.", "VALIDATION_ERROR");
  }

  const questions = await Question.find({ _id: { $in: questionIds } }).select("exerciseId");
  const firstQuestion = questions[0];
  if (questions.length !== entries.length || !firstQuestion) {
    throw new ApiError(404, "One or more questions do not exist.", "QUESTION_NOT_FOUND");
  }

  const exerciseIds = new Set(questions.map((question) => question.exerciseId.toString()));
  if (exerciseIds.size !== 1) {
    throw new ApiError(
      400,
      "All questions in a reorder request must belong to the same exercise.",
      "VALIDATION_ERROR",
    );
  }

  await Question.bulkWrite(
    entries.map((entry) => ({
      updateOne: { filter: { _id: entry.id }, update: { orderIndex: entry.orderIndex } },
    })),
  );

  const updatedQuestions = await Question.find({ exerciseId: firstQuestion.exerciseId }).sort({
    orderIndex: 1,
  });
  response.status(200).json({ data: updatedQuestions });
};
