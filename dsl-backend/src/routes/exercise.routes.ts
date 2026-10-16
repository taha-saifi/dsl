import { Router } from "express";

import { create, getById, list, remove, reorder, update } from "../controllers/exercise.controller";
import { authenticate } from "../middleware/auth.middleware";
import { requireRole } from "../middleware/role.middleware";
import { asyncHandler } from "../utils/asyncHandler";

const exercisesRouter = Router();

// Authoring routes: teachers and admins only. Students read through /api/learn.
exercisesRouter.use(asyncHandler(authenticate), requireRole("teacher", "admin"));
exercisesRouter.get("/", asyncHandler(list));
exercisesRouter.get("/:id", asyncHandler(getById));
exercisesRouter.post("/", asyncHandler(create));
exercisesRouter.patch("/reorder", asyncHandler(reorder));
exercisesRouter.patch("/:id", asyncHandler(update));
exercisesRouter.delete("/:id", asyncHandler(remove));

export default exercisesRouter;
