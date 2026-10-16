import { Router } from "express";

import { create, getById, list, remove, update } from "../controllers/courses.controller";
import { authenticate } from "../middleware/auth.middleware";
import { requireRole } from "../middleware/role.middleware";
import { asyncHandler } from "../utils/asyncHandler";

const coursesRouter = Router();

coursesRouter.use(asyncHandler(authenticate));
coursesRouter.get("/", asyncHandler(list));
coursesRouter.get("/:id", asyncHandler(getById));
coursesRouter.post("/", requireRole("teacher", "admin"), asyncHandler(create));
coursesRouter.patch("/:id", requireRole("teacher", "admin"), asyncHandler(update));
coursesRouter.delete("/:id", requireRole("teacher", "admin"), asyncHandler(remove));

export default coursesRouter;
