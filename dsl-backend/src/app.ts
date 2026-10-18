import cors from "cors";
import express from "express";

import { config } from "./config/config";
import { errorHandler } from "./middleware/error.middleware";
import adminUsersRouter from "./routes/adminUsers.routes";
import authRouter from "./routes/auth.routes";
import coursesRouter from "./routes/courses.routes";
import exercisesRouter from "./routes/exercise.routes";
import healthRouter from "./routes/health.routes";
import learnRouter from "./routes/learn.routes";
import learningItemsRouter from "./routes/learningItem.routes";
import mediaRouter from "./routes/media.routes";
import questionsRouter from "./routes/question.routes";
import specializationsRouter from "./routes/specializations.routes";
import unitsRouter from "./routes/units.routes";

const app = express();

// One proxy hop (Traefik) in front of the app: trust exactly that one, so
// req.ip and req.protocol come from it but a client can't spoof X-Forwarded-For.
app.set("trust proxy", 1);
app.disable("x-powered-by");

app.use(cors({ origin: config.frontendUrl }));
app.use(express.json());
app.use("/api/health", healthRouter);
app.use("/api/auth", authRouter);
app.use("/api/admin/users", adminUsersRouter);
app.use("/api/learn", learnRouter);
app.use("/api/specializations", specializationsRouter);
app.use("/api/courses", coursesRouter);
app.use("/api/units", unitsRouter);
app.use("/api/media", mediaRouter);
app.use("/api/learning-items", learningItemsRouter);
app.use("/api/exercises", exercisesRouter);
app.use("/api/questions", questionsRouter);
app.use(errorHandler);

export default app;
