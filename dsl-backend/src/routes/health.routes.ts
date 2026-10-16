import { Router } from "express";

const healthRouter = Router();

healthRouter.get("/", (_request, response) => {
  response.status(200).json({ data: { status: "ok" } });
});

export default healthRouter;
