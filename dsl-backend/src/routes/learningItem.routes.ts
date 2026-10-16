import { Router } from "express";

import {
  addTranslation,
  create,
  getById,
  list,
  remove,
  removeTranslation,
  update,
  updateTranslation,
} from "../controllers/learningItem.controller";
import { authenticate } from "../middleware/auth.middleware";
import { requireRole } from "../middleware/role.middleware";
import { asyncHandler } from "../utils/asyncHandler";

const learningItemsRouter = Router();

learningItemsRouter.use(asyncHandler(authenticate));
learningItemsRouter.get("/", asyncHandler(list));
learningItemsRouter.post("/", requireRole("teacher", "admin"), asyncHandler(create));
learningItemsRouter.post(
  "/:id/translations",
  requireRole("teacher", "admin"),
  asyncHandler(addTranslation),
);
learningItemsRouter.patch(
  "/:id/translations/:language",
  requireRole("teacher", "admin"),
  asyncHandler(updateTranslation),
);
learningItemsRouter.delete(
  "/:id/translations/:language",
  requireRole("teacher", "admin"),
  asyncHandler(removeTranslation),
);
learningItemsRouter.get("/:id", asyncHandler(getById));
learningItemsRouter.patch("/:id", requireRole("teacher", "admin"), asyncHandler(update));
learningItemsRouter.delete("/:id", requireRole("teacher", "admin"), asyncHandler(remove));

export default learningItemsRouter;
