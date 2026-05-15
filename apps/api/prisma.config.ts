import "dotenv/config";
import { defineConfig, env } from "prisma/config";

export default defineConfig({
  schema: "src/infra/database/schema.prisma",
  datasource: {
    url: env("DB_STRING"),
  },
});
