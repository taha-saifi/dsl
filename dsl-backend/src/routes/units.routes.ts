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

unitsRouter.use(asyncHandler(authenticate));
unitsRouter.get("/", asyncHandler(list));
unitsRouter.get("/:id", asyncHandler(getById));
unitsRouter.post("/", requireRole("teacher", "admin"), asyncHandler(create));
unitsRouter.post("/:id/learning-items", requireRole("teacher", "admin"), asyncHandler(attachLearningItem));
unitsRouter.patch("/reorder", requireRole("teacher", "admin"), asyncHandler(reorder));
unitsRouter.patch(
  "/:id/learning-items/reorder",
  requireRole("teacher", "admin"),
  asyncHandler(reorderLearningItems),
);
unitsRouter.patch("/:id", requireRole("teacher", "admin"), asyncHandler(update));
unitsRouter.delete(
  "/:id/learning-items/:learningItemId",
  requireRole("teacher", "admin"),
  asyncHandler(detachLearningItem),
);
unitsRouter.delete("/:id", requireRole("teacher", "admin"), asyncHandler(remove));

export default unitsRouter;
