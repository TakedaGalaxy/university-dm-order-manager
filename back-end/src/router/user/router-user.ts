import { PrismaClient } from "@prisma/client";
import { Router } from "express";
import { middlewareAuth } from "../../middleware/auth/auth";
import Security from "../../utils/security/security";
import ServiceUser from "../../services/user/service-user";

export default function routerUser(prismaClient: PrismaClient, security: Security): Router {
  const router = Router();

  const serviceUser = new ServiceUser(prismaClient);

  router.get("/",
    middlewareAuth(prismaClient, security, ["adm"]),
    async (request, response) => {
      const { payloadAccessToken } = request;

      try {
        response.status(200).json(await serviceUser.getAll(payloadAccessToken!));
      } catch (error) {
        console.error(error);
        response.status(500).json({ message: "Error", description: `${error}` });
      }
    }
  );

  return router;
}