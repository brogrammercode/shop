import { Router } from "express";
import authRoutes from "../features/auth/auth.route";
import businessRoutes from "../features/business/business.route";
import orderRoutes from "../features/order/order.route";

const router = Router();

router.use("/auth", authRoutes);
router.use("/business", businessRoutes);
router.use("/order", orderRoutes);

export default router;
