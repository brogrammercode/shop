import { Router } from "express";
import { uploadImage } from "./upload.controller";
import multer from "multer";
import { authenticate } from "../core_hr/core_hr.middleware";

const router = Router();
const upload = multer({ storage: multer.memoryStorage() });

router.post("/image", authenticate, upload.single("file"), uploadImage);

export default router;
