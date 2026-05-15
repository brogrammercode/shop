import express, { Application, Request, Response } from "express";
import cors from "cors";
import helmet from "helmet";
import compression from "compression";
import config from "./core/config";
import logger from "./utils/logger";
import { HttpStatus } from "./constants/status";
import routes from "./routes/index";
import errorHandler from "./middlewares/error.middleware";

export const createApp = (): Application => {
    const app = express();

    app.use(helmet());
    app.use(cors({
        origin: config.CORS_ORIGIN,
        credentials: true,
        methods: ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
        allowedHeaders: ["Content-Type", "Authorization"],
    }));
    app.use(compression());
    app.use(express.json({ limit: "50mb" }));
    app.use(express.urlencoded({ limit: "50mb", extended: false }));

    app.use((req, _res, next) => {
        logger.info(`${req.method} ${req.url}`);
        next();
    });

    app.get("/", (_req: Request, res: Response) => {
        res.status(HttpStatus.OK).json({
            status: "success",
            message: `API v1 running on port ${config.PORT}`,
        });
    });

    app.use("/api/v1", routes);
    app.use(errorHandler);

    return app;
};

export default createApp;
