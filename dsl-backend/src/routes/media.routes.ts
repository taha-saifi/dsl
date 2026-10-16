import { Router } from "express";

import { getById, list, remove, uploadMedia } from "../controllers/media.controller";
import { authenticate } from "../middleware/auth.middleware";
import { requireRole } from "../middleware/role.middleware";
import { upload } from "../middleware/upload.middleware";
import { asyncHandler } from "../utils/asyncHandler";

const mediaRouter = Router();

// Authoring routes: teachers and admins only. Students read through /api/learn.
mediaRouter.use(asyncHandler(authenticate), requireRole("teacher", "admin"));
mediaRouter.get("/", asyncHandler(list));
mediaRouter.post("/upload", upload.single("file"), asyncHandler(uploadMedia));
mediaRouter.get("/:id", asyncHandler(getById));
mediaRouter.delete("/:id", asyncHandler(remove));

export default mediaRouter;
