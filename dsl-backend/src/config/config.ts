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
  nodeEnv: process.env.NODE_ENV ?? "development",
  port: parsePort(process.env.PORT),
  mongoDbUri: process.env.MONGODB_URI ?? "",
  jwtSecret: process.env.JWT_SECRET ?? "",
  frontendUrl: process.env.FRONTEND_URL ?? "",
  minioInternalEndpoint: process.env.MINIO_INTERNAL_ENDPOINT ?? "",
  minioPublicEndpoint: process.env.MINIO_PUBLIC_ENDPOINT ?? "",
  minioAccessKey: process.env.MINIO_ACCESS_KEY ?? "",
  minioSecretKey: process.env.MINIO_SECRET_KEY ?? "",
  minioBucket: process.env.MINIO_BUCKET ?? "",
  minioRegion: process.env.MINIO_REGION ?? "us-east-1",
} as const;

const requiredInProduction = [
  ["MONGODB_URI", config.mongoDbUri],
  ["JWT_SECRET", config.jwtSecret],
  ["FRONTEND_URL", config.frontendUrl],
  ["MINIO_INTERNAL_ENDPOINT", config.minioInternalEndpoint],
  ["MINIO_PUBLIC_ENDPOINT", config.minioPublicEndpoint],
  ["MINIO_ACCESS_KEY", config.minioAccessKey],
  ["MINIO_SECRET_KEY", config.minioSecretKey],
  ["MINIO_BUCKET", config.minioBucket],
] as const;

/**
 * In production an empty variable must stop startup instead of degrading
 * silently (an empty JWT_SECRET would answer 401 to every request).
 */
export const assertProductionConfig = (): void => {
  if (config.nodeEnv !== "production") {
    return;
  }

  const missing = requiredInProduction.filter(([, value]) => value === "").map(([name]) => name);
  if (missing.length > 0) {
    console.error(`Missing required environment variables: ${missing.join(", ")}.`);
    process.exit(1);
  }
};
