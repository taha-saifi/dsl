import cors from "cors";
import express from "express";

import { config } from "./config/config";
import { errorHandler } from "./middleware/error.middleware";
import authRouter from "./routes/auth.routes";
import coursesRouter from "./routes/courses.routes";
import exercisesRouter from "./routes/exercise.routes";
import healthRouter from "./routes/health.routes";
import learningItemsRouter from "./routes/learningItem.routes";
import mediaRouter from "./routes/media.routes";
import questionsRouter from "./routes/question.routes";
import specializationsRouter from "./routes/specializations.routes";
import unitsRouter from "./routes/units.routes";

const app = express();

app.use(cors({ origin: config.frontendUrl }));
app.use(express.json());
app.use("/api/health", healthRouter);
app.use("/api/auth", authRouter);
app.use("/api/specializations", specializationsRouter);
app.use("/api/courses", coursesRouter);
app.use("/api/units", unitsRouter);
app.use("/api/media", mediaRouter);
app.use("/api/learning-items", learningItemsRouter);
app.use("/api/exercises", exercisesRouter);
app.use("/api/questions", questionsRouter);
app.use(errorHandler);

export default app;
