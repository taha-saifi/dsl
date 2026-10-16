import { Router } from "express";

import {
  attachLearningItem,
  create,
  detachLearningItem,
  getById,
  list,
  remove,
  reorder,
  reorderLearningItems,
  update,
} from "../controllers/units.controller";
import { authenticate } from "../middleware/auth.middleware";
import { requireRole } from "../middleware/role.middleware";
import { asyncHandler } from "../utils/asyncHandler";

const unitsRouter = Router();

// Authoring routes: teachers and admins only. Students read through /api/learn.
unitsRouter.use(asyncHandler(authenticate), requireRole("teacher", "admin"));
unitsRouter.get("/", asyncHandler(list));
unitsRouter.get("/:id", asyncHandler(getById));
unitsRouter.post("/", asyncHandler(create));
unitsRouter.post("/:id/learning-items", asyncHandler(attachLearningItem));
unitsRouter.patch("/reorder", asyncHandler(reorder));
unitsRouter.patch(
  "/:id/learning-items/reorder",
  asyncHandler(reorderLearningItems),
);
unitsRouter.patch("/:id", asyncHandler(update));
unitsRouter.delete(
  "/:id/learning-items/:learningItemId",
  asyncHandler(detachLearningItem),
);
unitsRouter.delete("/:id", asyncHandler(remove));

export default unitsRouter;
