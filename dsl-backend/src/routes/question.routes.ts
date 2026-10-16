import { Router } from "express";

import { create, getById, list, remove, reorder, textDefaults, update } from "../controllers/question.controller";
import { authenticate } from "../middleware/auth.middleware";
import { requireRole } from "../middleware/role.middleware";
import { asyncHandler } from "../utils/asyncHandler";

const questionsRouter = Router();

// Authoring routes: teachers and admins only. Students read through /api/learn.
questionsRouter.use(asyncHandler(authenticate), requireRole("teacher", "admin"));
questionsRouter.get("/", asyncHandler(list));
questionsRouter.get("/text-defaults", asyncHandler(textDefaults));
questionsRouter.get("/:id", asyncHandler(getById));
questionsRouter.post("/", asyncHandler(create));
questionsRouter.patch("/reorder", asyncHandler(reorder));
questionsRouter.patch("/:id", asyncHandler(update));
questionsRouter.delete("/:id", asyncHandler(remove));

export default questionsRouter;
