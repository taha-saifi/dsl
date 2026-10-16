import { Router } from "express";

import {
  create,
  getById,
  list,
  remove,
  update,
} from "../controllers/specializations.controller";
import { authenticate } from "../middleware/auth.middleware";
import { requireRole } from "../middleware/role.middleware";
import { asyncHandler } from "../utils/asyncHandler";

const specializationsRouter = Router();

// Authoring routes: teachers and admins only. Students read through /api/learn.
specializationsRouter.use(asyncHandler(authenticate), requireRole("teacher", "admin"));
specializationsRouter.get("/", asyncHandler(list));
specializationsRouter.get("/:id", asyncHandler(getById));
specializationsRouter.post("/", asyncHandler(create));
specializationsRouter.patch("/:id", asyncHandler(update));
specializationsRouter.delete("/:id", asyncHandler(remove));

export default specializationsRouter;
