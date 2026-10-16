import {
  CreateBucketCommand,
  HeadBucketCommand,
  PutBucketPolicyCommand,
  S3Client,
} from "@aws-sdk/client-s3";

import { config } from "./config";

export const s3Client = new S3Client({
  endpoint: config.minioInternalEndpoint,
  forcePathStyle: true,
  region: config.minioRegion,
  credentials: {
    accessKeyId: config.minioAccessKey,
    secretAccessKey: config.minioSecretKey,
  },
});

const buildPublicReadPolicy = (bucket: string): string =>
  JSON.stringify({
    Version: "2012-10-17",
    Statement: [
      {
        Effect: "Allow",
        Principal: "*",
        Action: ["s3:GetObject"],
        Resource: [`arn:aws:s3:::${bucket}/*`],
      },
    ],
  });

export const ensureBucketExists = async (): Promise<void> => {
  const bucket = config.minioBucket;

  try {
    await s3Client.send(new HeadBucketCommand({ Bucket: bucket }));
    return;
  } catch (_error: unknown) {
    // Bucket doesn't exist (or isn't accessible) — create it below.
  }

  await s3Client.send(new CreateBucketCommand({ Bucket: bucket }));
  await s3Client.send(
    new PutBucketPolicyCommand({
      Bucket: bucket,
      Policy: buildPublicReadPolicy(bucket),
    }),
  );
};
