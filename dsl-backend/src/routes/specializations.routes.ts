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

specializationsRouter.use(asyncHandler(authenticate));
specializationsRouter.get("/", asyncHandler(list));
specializationsRouter.get("/:id", asyncHandler(getById));
specializationsRouter.post("/", requireRole("teacher", "admin"), asyncHandler(create));
specializationsRouter.patch("/:id", requireRole("teacher", "admin"), asyncHandler(update));
specializationsRouter.delete("/:id", requireRole("teacher", "admin"), asyncHandler(remove));

export default specializationsRouter;
