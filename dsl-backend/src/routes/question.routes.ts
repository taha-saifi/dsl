import { Router } from "express";

import { create, getById, list, remove, reorder, update } from "../controllers/question.controller";
import { authenticate } from "../middleware/auth.middleware";
import { requireRole } from "../middleware/role.middleware";
import { asyncHandler } from "../utils/asyncHandler";

const questionsRouter = Router();

questionsRouter.use(asyncHandler(authenticate));
questionsRouter.get("/", asyncHandler(list));
questionsRouter.get("/:id", asyncHandler(getById));
questionsRouter.post("/", requireRole("teacher", "admin"), asyncHandler(create));
questionsRouter.patch("/reorder", requireRole("teacher", "admin"), asyncHandler(reorder));
questionsRouter.patch("/:id", requireRole("teacher", "admin"), asyncHandler(update));
questionsRouter.delete("/:id", requireRole("teacher", "admin"), asyncHandler(remove));

export default questionsRouter;
