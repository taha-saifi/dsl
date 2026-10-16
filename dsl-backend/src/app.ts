import cors from "cors";
import express from "express";

import { config } from "./config/config";
import healthRouter from "./routes/health.routes";

const app = express();

app.use(cors({ origin: config.frontendUrl }));
app.use(express.json());
app.use("/api/health", healthRouter);

export default app;
