import app from "./app";
import { config } from "./config/config";
import { connectToDatabase } from "./config/db";
import { ensureBucketExists } from "./config/storage";

const startServer = async (): Promise<void> => {
  await connectToDatabase();

  try {
    await ensureBucketExists();
    console.log(`MinIO bucket "${config.minioBucket}" is ready.`);
  } catch (error: unknown) {
    const message = error instanceof Error ? error.message : "Unknown storage error";
    console.error(`MinIO bucket setup failed: ${message}`);
    process.exit(1);
  }

  app.listen(config.port, () => {
    console.log(`Server listening on port ${config.port}.`);
  });
};

void startServer();
