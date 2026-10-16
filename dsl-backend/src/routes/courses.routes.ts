import { Router } from "express";

import { create, getById, list, remove, update } from "../controllers/courses.controller";
import { authenticate } from "../middleware/auth.middleware";
import { requireRole } from "../middleware/role.middleware";
import { asyncHandler } from "../utils/asyncHandler";

const coursesRouter = Router();

// Authoring routes: teachers and admins only. Students read through /api/learn.
coursesRouter.use(asyncHandler(authenticate), requireRole("teacher", "admin"));
coursesRouter.get("/", asyncHandler(list));
coursesRouter.get("/:id", asyncHandler(getById));
coursesRouter.post("/", asyncHandler(create));
coursesRouter.patch("/:id", asyncHandler(update));
coursesRouter.delete("/:id", asyncHandler(remove));

export default coursesRouter;
