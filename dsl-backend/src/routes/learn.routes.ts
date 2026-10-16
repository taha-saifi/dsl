import { Router } from "express";

import { course, courses, languages, specializations, unit } from "../controllers/learn.controller";
import { authenticate } from "../middleware/auth.middleware";
import { asyncHandler } from "../utils/asyncHandler";

/** Student-shaped, read-only views of published content. Any signed-in role. */
const learnRouter = Router();

learnRouter.use(asyncHandler(authenticate));
learnRouter.get("/specializations", asyncHandler(specializations));
learnRouter.get("/languages", asyncHandler(languages));
learnRouter.get("/courses", asyncHandler(courses));
learnRouter.get("/courses/:id", asyncHandler(course));
learnRouter.get("/units/:id", asyncHandler(unit));

export default learnRouter;
