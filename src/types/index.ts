export interface User {
  _id: string;
  email: string;
  role: "admin" | "teacher" | "student";
  firstName: string;
  lastName: string;
}

export interface Specialization {
  _id: string;
  name: string;
  slug: string;
  iconUrl?: string;
}
