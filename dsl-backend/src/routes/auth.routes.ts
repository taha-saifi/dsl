import { Router } from "express";

import { login, me, register, updateMe } from "../controllers/auth.controller";
import { authenticate } from "../middleware/auth.middleware";
import { requireRole } from "../middleware/role.middleware";
import { asyncHandler } from "../utils/asyncHandler";

const authRouter = Router();

authRouter.post("/register", asyncHandler(register));
authRouter.post("/login", asyncHandler(login));
authRouter.get("/me", asyncHandler(authenticate), asyncHandler(me));
authRouter.patch("/me", asyncHandler(authenticate), requireRole("student"), asyncHandler(updateMe));

export default authRouter;
