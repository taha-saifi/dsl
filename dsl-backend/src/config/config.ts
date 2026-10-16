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
  jwtSecret: process.env.JWT_SECRET ?? "",
  frontendUrl: process.env.FRONTEND_URL ?? "",
  minioInternalEndpoint: process.env.MINIO_INTERNAL_ENDPOINT ?? "",
  minioPublicEndpoint: process.env.MINIO_PUBLIC_ENDPOINT ?? "",
  minioAccessKey: process.env.MINIO_ACCESS_KEY ?? "",
  minioSecretKey: process.env.MINIO_SECRET_KEY ?? "",
  minioBucket: process.env.MINIO_BUCKET ?? "",
  minioRegion: process.env.MINIO_REGION ?? "us-east-1",
} as const;
