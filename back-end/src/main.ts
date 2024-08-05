import express from "express";
import cors from "cors";
import "dotenv/config";
import routerAuth from "./router/auth/router-auth";
import { PrismaClient } from "@prisma/client";
import Security from "./utils/security/security";

const { ADDRESS, PORT, CRYPTO_KEY } = process.env;

if (ADDRESS === undefined || PORT === undefined || CRYPTO_KEY === undefined) throw ".ENV invalid !"

const app = express();

app.use(cors());

app.use(express.json());

app.get("/", (request, response) => {
  response.status(200).json({ message: "Running" });
});

const prismaClient = new PrismaClient();

app.use("/auth", routerAuth(prismaClient, new Security(CRYPTO_KEY)));

app.listen(Number(PORT), ADDRESS, () => {
  console.log(`[SERVER]: http://${ADDRESS}:${PORT}`);
});