import { Router } from "express";

import { languages, specializations } from "../controllers/learn.controller";
import { authenticate } from "../middleware/auth.middleware";
import { asyncHandler } from "../utils/asyncHandler";

/** Student-shaped, read-only views of published content. Any signed-in role. */
const learnRouter = Router();

learnRouter.use(asyncHandler(authenticate));
learnRouter.get("/specializations", asyncHandler(specializations));
learnRouter.get("/languages", asyncHandler(languages));

export default learnRouter;
