import { Router } from "express";

import { create, list, resetPassword } from "../controllers/adminUsers.controller";
import { authenticate } from "../middleware/auth.middleware";
import { requireRole } from "../middleware/role.middleware";
import { asyncHandler } from "../utils/asyncHandler";

const adminUsersRouter = Router();

adminUsersRouter.use(asyncHandler(authenticate), requireRole("admin"));
adminUsersRouter.get("/", asyncHandler(list));
adminUsersRouter.post("/", asyncHandler(create));
adminUsersRouter.patch("/:id/password", asyncHandler(resetPassword));

export default adminUsersRouter;
