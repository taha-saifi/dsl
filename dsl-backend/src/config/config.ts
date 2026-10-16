import dotenv from "dotenv";

dotenv.config();

const parsePort = (value: string | undefined): number => {
  if (value === undefined || value === "") {
    return 5000;
  }

  const port = Number(value);
  if (!Number.isInteger(port) || port <= 0 || port > 65535) {
    throw new Error("PORT must be a valid port number.");
  }

  return port;
};

export const config = {
  port: parsePort(process.env.PORT),
  mongoDbUri: process.env.MONGODB_URI ?? "",
  frontendUrl: process.env.FRONTEND_URL ?? "",
} as const;
