import type { NextFunction, Request, Response } from "express";
import jwt, { type JwtPayload } from "jsonwebtoken";

import { config } from "../config/config";
import User from "../models/User";
import { ApiError } from "./error.middleware";

interface AuthTokenPayload extends JwtPayload {
  userId: string;
  role: string;
}

const getBearerToken = (authorization: string | undefined): string | undefined => {
  if (!authorization?.startsWith("Bearer ")) {
    return undefined;
  }

  const token = authorization.slice("Bearer ".length).trim();
  return token || undefined;
};

const isAuthTokenPayload = (payload: string | JwtPayload): payload is AuthTokenPayload =>
  typeof payload !== "string" && typeof payload.userId === "string";

export const authenticate = async (
  request: Request,
  _response: Response,
  next: NextFunction,
): Promise<void> => {
  const token = getBearerToken(request.header("authorization"));

  if (!token || !config.jwtSecret) {
    next(new ApiError(401, "Unauthorized.", "UNAUTHORIZED"));
    return;
  }

  try {
    const decoded = jwt.verify(token, config.jwtSecret);
    if (!isAuthTokenPayload(decoded)) {
      next(new ApiError(401, "Unauthorized.", "UNAUTHORIZED"));
      return;
    }

    const user = await User.findById(decoded.userId);
    if (!user) {
      next(new ApiError(401, "Unauthorized.", "UNAUTHORIZED"));
      return;
    }

    request.user = user;
    next();
  } catch (_error: unknown) {
    next(new ApiError(401, "Unauthorized.", "UNAUTHORIZED"));
  }
};
