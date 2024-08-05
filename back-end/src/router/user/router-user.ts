import { PrismaClient } from "@prisma/client";
import { Router } from "express";
import { middlewareAuth } from "../../middleware/auth/auth";
import Security from "../../utils/security/security";
import ServiceUser, { BodyCreateServiceUser, BodyUpdateServiceUser } from "../../services/user/service-user";
import middlewareBodyVerify from "../../middleware/body-verify/body-verify";

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

  router.get("/:id",
    middlewareAuth(prismaClient, security, ["adm"]),
    async (request, response) => {
      const { payloadAccessToken, params } = request;

      try {
        response.status(200).json(await serviceUser.get(payloadAccessToken!, Number(params.id)));
      } catch (error) {
        console.error(error);
        response.status(500).json({ message: "Error", description: `${error}` });
      }
    }
  );

  router.post("/",
    middlewareAuth(prismaClient, security, ["adm"]),
    middlewareBodyVerify<BodyCreateServiceUser>(["name", "password", "profileTypeName"]),
    async (request, response) => {
      const { body, payloadAccessToken } = request;

      try {
        response.status(200).json(await serviceUser.create(payloadAccessToken!, body, security));
      } catch (error) {
        console.error(error);
        response.status(500).json({ message: "Error", description: `${error}` });
      }
    }
  );

  router.post("/:id",
    middlewareAuth(prismaClient, security, ["adm"]),
    middlewareBodyVerify<BodyUpdateServiceUser>(["name", "password", "profileTypeName"]),
    async (request, response) => {
      const { payloadAccessToken, body, params } = request;

      try {
        response.status(200).json(await serviceUser.update(payloadAccessToken!, Number(params.id), body, security));
      } catch (error) {
        console.error(error);
        response.status(500).json({ message: "Error", description: `${error}` });
      }
    }
  );

  router.delete("/:id",
    middlewareAuth(prismaClient, security, ["adm"]),
    async (request, response) => {
      const { payloadAccessToken, params } = request;

      try {
        response.status(200).json(await serviceUser.delete(payloadAccessToken!, Number(params.id)));
      } catch (error) {
        console.error(error);
        response.status(500).json({ message: "Error", description: `${error}` });
      }
    }
  );

  return router;
}