import { Router } from "express";
import authRoutes from "../features/auth/auth.route";
import businessRoutes from "../features/business/business.route";
import orderRoutes from "../features/order/order.route";
import productRoutes from "../features/product/product.route";
import uploadRoutes from "../features/upload/upload.route";

const router = Router();

router.use("/auth", authRoutes);
router.use("/business", businessRoutes);
router.use("/product", productRoutes);
router.use("/order", orderRoutes);
router.use("/upload", uploadRoutes);

export default router;
