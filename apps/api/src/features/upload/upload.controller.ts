import { Request, Response } from "express";
import { v2 as cloudinary } from "cloudinary";
import { config } from "../../core/config";
import { sendSuccess } from "../../utils/error";
import { HttpStatus } from "../../constants/status";

cloudinary.config({
  cloud_name: config.CLOUDINARY_CLOUD_NAME,
  api_key: config.CLOUDINARY_API_KEY,
  api_secret: config.CLOUDINARY_API_SECRET,
});

export const uploadImage = async (req: Request, res: Response) => {
  try {
    if (!req.file) {
      return res.status(HttpStatus.BAD_REQUEST).json({ success: false, message: "No image file provided." });
    }

    const b64 = Buffer.from(req.file.buffer).toString("base64");
    const dataURI = "data:" + req.file.mimetype + ";base64," + b64;
    const result = await cloudinary.uploader.upload(dataURI, {
      resource_type: "auto",
      folder: "shop-uploads",
    });

    return sendSuccess(res, { url: result.secure_url }, "Image uploaded successfully", HttpStatus.CREATED);
  } catch (error: any) {
    return res.status(HttpStatus.INTERNAL_SERVER_ERROR).json({
      success: false,
      message: error.message || "Failed to upload image",
    });
  }
};
