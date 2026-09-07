export interface User {
  _id: string;
  email: string;
  role: "admin" | "teacher" | "student";
  firstName: string;
  lastName: string;
}
