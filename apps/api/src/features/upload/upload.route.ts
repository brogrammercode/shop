import { Router } from "express";
import multer from "multer";
import { uploadImages } from "./upload.controller";

const router = Router();
const upload = multer({ storage: multer.memoryStorage() });

router.post("/images", upload.array("images"), uploadImages);

export default router;
