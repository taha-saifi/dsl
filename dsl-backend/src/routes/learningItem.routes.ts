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

// Authoring routes: teachers and admins only. Students read through /api/learn.
learningItemsRouter.use(asyncHandler(authenticate), requireRole("teacher", "admin"));
learningItemsRouter.get("/", asyncHandler(list));
learningItemsRouter.post("/", asyncHandler(create));
learningItemsRouter.post(
  "/:id/translations",
  asyncHandler(addTranslation),
);
learningItemsRouter.patch(
  "/:id/translations/:language",
  asyncHandler(updateTranslation),
);
learningItemsRouter.delete(
  "/:id/translations/:language",
  asyncHandler(removeTranslation),
);
learningItemsRouter.get("/:id", asyncHandler(getById));
learningItemsRouter.patch("/:id", asyncHandler(update));
learningItemsRouter.delete("/:id", asyncHandler(remove));

export default learningItemsRouter;
