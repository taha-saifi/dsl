import { Router } from "express";

import { create, getById, list, remove, reorder, update } from "../controllers/exercise.controller";
import { authenticate } from "../middleware/auth.middleware";
import { requireRole } from "../middleware/role.middleware";
import { asyncHandler } from "../utils/asyncHandler";

const exercisesRouter = Router();

exercisesRouter.use(asyncHandler(authenticate));
exercisesRouter.get("/", asyncHandler(list));
exercisesRouter.get("/:id", asyncHandler(getById));
exercisesRouter.post("/", requireRole("teacher", "admin"), asyncHandler(create));
exercisesRouter.patch("/reorder", requireRole("teacher", "admin"), asyncHandler(reorder));
exercisesRouter.patch("/:id", requireRole("teacher", "admin"), asyncHandler(update));
exercisesRouter.delete("/:id", requireRole("teacher", "admin"), asyncHandler(remove));

export default exercisesRouter;
