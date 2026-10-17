import { Types } from "mongoose";

import ExerciseSession from "../models/ExerciseSession";

/*
 * Learning progress, computed on read from completed exercise sessions
 * (docs/mobile/features/feat-learning-progress.md). Nothing is stored, so
 * unpublishing an exercise changes the totals immediately. An exercise is
 * done once any session completes it, at any score (Q13); its best score is
 * the session with the highest score/maxScore.
 */

export interface ExerciseBest {
  bestScore: number;
  bestMaxScore: number;
  bestPercent: number;
}

export interface Progress {
  completedExercises: number;
  totalExercises: number;
  /** completed ÷ total × 100, rounded (Q15). */
  percent: number;
}

/** Best completed session per exercise, for one student. */
export const loadExerciseBests = async (
  studentId: Types.ObjectId,
  exerciseIds: Types.ObjectId[],
): Promise<Map<string, ExerciseBest>> => {
  if (exerciseIds.length === 0) {
    return new Map();
  }
  const rows = await ExerciseSession.aggregate<{ _id: Types.ObjectId } & ExerciseBest>([
    { $match: { studentId, status: "completed", exerciseId: { $in: exerciseIds } } },
    {
      $project: {
        exerciseId: 1,
        score: 1,
        maxScore: 1,
        percent: {
          $cond: [{ $gt: ["$maxScore", 0] }, { $multiply: [{ $divide: ["$score", "$maxScore"] }, 100] }, 0],
        },
      },
    },
    { $sort: { percent: -1, score: -1 } },
    {
      $group: {
        _id: "$exerciseId",
        bestScore: { $first: "$score" },
        bestMaxScore: { $first: "$maxScore" },
        bestPercent: { $first: { $round: ["$percent", 0] } },
      },
    },
  ]);
  return new Map(rows.map((row) => [row._id.toString(), row]));
};

/** When the student last started any exercise in each course. */
export const loadLastActivity = async (
  studentId: Types.ObjectId,
  courseIds: Types.ObjectId[],
): Promise<Map<string, Date>> => {
  if (courseIds.length === 0) {
    return new Map();
  }
  const rows = await ExerciseSession.aggregate<{ _id: Types.ObjectId; last: Date }>([
    { $match: { studentId, courseId: { $in: courseIds } } },
    { $group: { _id: "$courseId", last: { $max: "$startedAt" } } },
  ]);
  return new Map(rows.map((row) => [row._id.toString(), row.last]));
};

export const progressOf = (exerciseIds: Types.ObjectId[], bests: Map<string, ExerciseBest>): Progress => {
  const completedExercises = exerciseIds.filter((id) => bests.has(id.toString())).length;
  const totalExercises = exerciseIds.length;
  return {
    completedExercises,
    totalExercises,
    percent: totalExercises === 0 ? 0 : Math.round((completedExercises / totalExercises) * 100),
  };
};
