import { Router } from "express";

import {
  course,
  courses,
  enroll,
  languages,
  myCourses,
  specializations,
  unenroll,
  unit,
} from "../controllers/learn.controller";
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

// Enrollment is a student concept.
const studentOnly = requireRole("student");
learnRouter.post("/courses/:id/enroll", studentOnly, asyncHandler(enroll));
learnRouter.delete("/courses/:id/enroll", studentOnly, asyncHandler(unenroll));
learnRouter.get("/me/courses", studentOnly, asyncHandler(myCourses));

export default learnRouter;
