import { Server } from "socket.io";
import { Server as HttpServer } from "http";
import config from "../../core/config";
import logger from "../../utils/logger";

class SocketManager {
    private io: Server | null = null;

    init(httpServer: HttpServer) {
        this.io = new Server(httpServer, {
            cors: {
                origin: config.CORS_ORIGIN,
                methods: ["GET", "POST"],
                credentials: true,
            },
            pingTimeout: 60000,
            pingInterval: 25000,
            transports: ["websocket", "polling"],
            allowEIO3: true,
        });

        this.io.on("connection", (socket) => {
            logger.info(`Socket connected: ${socket.id}`);

            socket.on("join", (orgId: string) => {
                logger.info(`Socket ${socket.id} joined room:  ${orgId}`);
                socket.join(orgId);
            });

            socket.on("leave", (orgId: string) => {
                logger.info(`Socket ${socket.id} left room: ${orgId}`);
                socket.leave(orgId);
            });

            socket.on("disconnect", () => {
                logger.info(`Socket disconnected: ${socket.id}`);
            });
        });

        logger.info("Socket.io initialized");
    }

    emit(event: string, room: string, payload: unknown) {
        this.io?.to(room).emit(event, payload);
    }

    close() {
        return new Promise<void>((resolve) => {
            if (!this.io) {
                resolve();
                return;
            }

            this.io.close(() => {
                this.io = null;
                logger.info("Socket.io closed");
                resolve();
            });
        });
    }
}

const socketManager = new SocketManager();
export default socketManager;
