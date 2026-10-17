import { Router } from "express";

import {
  course,
  courses,
  enroll,
  languages,
  myCourses,
  play,
  specializations,
  unenroll,
  unit,
} from "../controllers/learn.controller";
import {
  abandon,
  answer,
  complete,
  start,
} from "../controllers/sessions.controller";
import { authenticate } from "../middleware/auth.middleware";
import { requireRole } from "../middleware/role.middleware";
import { asyncHandler } from "../utils/asyncHandler";

/** Student-shaped, read-only views of published content. Any signed-in role. */
const learnRouter = Router();

learnRouter.use(asyncHandler(authenticate));
learnRouter.get("/specializations", asyncHandler(specializations));
learnRouter.get("/languages", asyncHandler(languages));
learnRouter.get("/courses", asyncHandler(courses));
learnRouter.get("/courses/:id", asyncHandler(course));
learnRouter.get("/units/:id", asyncHandler(unit));
learnRouter.get("/exercises/:id/play", asyncHandler(play));

// Enrollment is a student concept.
const studentOnly = requireRole("student");
learnRouter.post("/courses/:id/enroll", studentOnly, asyncHandler(enroll));
learnRouter.delete("/courses/:id/enroll", studentOnly, asyncHandler(unenroll));
learnRouter.get("/me/courses", studentOnly, asyncHandler(myCourses));

// Exercise sessions: answers are checked here, never in the app.
learnRouter.post("/exercises/:id/sessions", studentOnly, asyncHandler(start));
learnRouter.post("/sessions/:id/answers", studentOnly, asyncHandler(answer));
learnRouter.post("/sessions/:id/complete", studentOnly, asyncHandler(complete));
learnRouter.post("/sessions/:id/abandon", studentOnly, asyncHandler(abandon));

export default learnRouter;
