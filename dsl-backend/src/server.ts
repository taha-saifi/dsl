import mongoose from "mongoose";

import app from "./app";
import { assertProductionConfig, config } from "./config/config";
import { connectToDatabase } from "./config/db";
import { ensureBucketExists } from "./config/storage";

const SHUTDOWN_TIMEOUT_MS = 10_000;

const startServer = async (): Promise<void> => {
  assertProductionConfig();
  await connectToDatabase();

  try {
    await ensureBucketExists();
    console.log(`MinIO bucket "${config.minioBucket}" is ready.`);
  } catch (error: unknown) {
    const message = error instanceof Error ? error.message : "Unknown storage error";
    console.error(`MinIO bucket setup failed: ${message}`);
    process.exit(1);
  }

  const server = app.listen(config.port, () => {
    console.log(`Server listening on port ${config.port}.`);
  });

  // `docker stop` sends SIGTERM: finish in-flight requests, close Mongo, then exit.
  let shuttingDown = false;
  const shutdown = (signal: string): void => {
    if (shuttingDown) {
      return;
    }
    shuttingDown = true;
    console.log(`${signal} received, shutting down.`);

    setTimeout(() => {
      console.error("Shutdown timed out, forcing exit.");
      process.exit(1);
    }, SHUTDOWN_TIMEOUT_MS).unref();

    server.close(() => {
      void mongoose.disconnect().finally(() => {
        console.log("Shutdown complete.");
        process.exit(0);
      });
    });
    server.closeIdleConnections();
  };

  process.on("SIGTERM", () => shutdown("SIGTERM"));
  process.on("SIGINT", () => shutdown("SIGINT"));
};

void startServer();
