import type { NextFunction, Request, RequestHandler, Response } from "express";

import type { UserRole } from "../models/User";
import { ApiError } from "./error.middleware";

export const requireRole = (...allowedRoles: UserRole[]): RequestHandler =>
  (request: Request, _response: Response, next: NextFunction): void => {
    if (!request.user || !allowedRoles.includes(request.user.role)) {
      next(
        new ApiError(
          403,
          `This action requires one of the following roles: ${allowedRoles.join(", ")}.`,
          "FORBIDDEN_ROLE",
        ),
      );
      return;
    }

    next();
  };
