import app from "./app";
import { config } from "./config/config";
import { connectToDatabase } from "./config/db";

const startServer = async (): Promise<void> => {
  await connectToDatabase();

  app.listen(config.port, () => {
    console.log(`Server listening on port ${config.port}.`);
  });
};

void startServer();
