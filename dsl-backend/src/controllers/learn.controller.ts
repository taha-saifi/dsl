import type { Request, Response } from "express";

import { ensureSpecializationExists } from "../services/resourceDependencies.service";
import {
  listLanguageSummaries,
  listSpecializationSummaries,
} from "../services/studentCatalog.service";
import { getOptionalObjectId } from "../utils/requestValidation";

export const specializations = async (_request: Request, response: Response): Promise<void> => {
  response.status(200).json({ data: await listSpecializationSummaries() });
};

export const languages = async (request: Request, response: Response): Promise<void> => {
  const specializationId = getOptionalObjectId(request.query.specializationId, "Specialization id");
  if (specializationId) {
    await ensureSpecializationExists(specializationId);
  }

  response.status(200).json({ data: await listLanguageSummaries(specializationId) });
};
