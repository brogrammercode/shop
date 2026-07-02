import { Router } from "express";
import coreHrRoutes from "../features/core_hr/core_hr.route";
import inventoryRoutes from "../features/inventory/inventory.route";
import catalogRoutes from "../features/catalog/catalog.route";
import posKdsRoutes from "../features/pos_kds/pos_kds.route";
import manufacturingRoutes from "../features/manufacturing/manufacturing.route";
import financeRoutes from "../features/finance/finance.route";
import crmRoutes from "../features/crm/crm.route";
// import authRoutes from "../features/auth/auth.route";
// import businessRoutes from "../features/business/business.route";
// import orderRoutes from "../features/order/order.route";
// import productRoutes from "../features/product/product.route";
// import uploadRoutes from "../features/upload/upload.route";

const router = Router();

router.use("/hr", coreHrRoutes);
router.use("/inventory", inventoryRoutes);
router.use("/catalog", catalogRoutes);
router.use("/pos-kds", posKdsRoutes);
router.use("/manufacturing", manufacturingRoutes);
router.use("/finance", financeRoutes);
router.use("/crm", crmRoutes);
// router.use("/auth", authRoutes);
// router.use("/business", businessRoutes);
// router.use("/product", productRoutes);
// router.use("/order", orderRoutes);
// router.use("/upload", uploadRoutes);

export default router;
