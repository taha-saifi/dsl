import { Router } from "express";

import { getById, list, remove, uploadMedia } from "../controllers/media.controller";
import { authenticate } from "../middleware/auth.middleware";
import { requireRole } from "../middleware/role.middleware";
import { upload } from "../middleware/upload.middleware";
import { asyncHandler } from "../utils/asyncHandler";

const mediaRouter = Router();

mediaRouter.use(asyncHandler(authenticate));
mediaRouter.get("/", asyncHandler(list));
mediaRouter.post("/upload", requireRole("teacher", "admin"), upload.single("file"), asyncHandler(uploadMedia));
mediaRouter.get("/:id", asyncHandler(getById));
mediaRouter.delete("/:id", requireRole("teacher", "admin"), asyncHandler(remove));

export default mediaRouter;
