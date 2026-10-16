import { model, Schema } from "mongoose";

export interface ISpecialization {
  name: string;
  slug: string;
  iconUrl?: string;
  createdAt: Date;
}

export const toKebabCase = (value: string): string =>
  value
    .normalize("NFKD")
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase()
    .trim()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/(^-|-$)/g, "");

const specializationSchema = new Schema<ISpecialization>(
  {
    name: {
      type: String,
      required: true,
      trim: true,
    },
    slug: {
      type: String,
      required: true,
      unique: true,
      lowercase: true,
      trim: true,
      match: /^[a-z0-9]+(?:-[a-z0-9]+)*$/,
    },
    iconUrl: {
      type: String,
      trim: true,
    },
  },
  { timestamps: { createdAt: true, updatedAt: false } },
);

specializationSchema.pre("validate", function generateSlug() {
  if (!this.slug && this.name) {
    this.slug = toKebabCase(this.name);
  }
});

const Specialization = model<ISpecialization>("Specialization", specializationSchema);

export default Specialization;
