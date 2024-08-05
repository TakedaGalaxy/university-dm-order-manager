import { PrismaClient } from "@prisma/client";
import { response, Router } from "express";
import ServiceAuth, { BodyLogInServiceAuth, BodySignInServiceAuth } from "../../services/auth/service-auth";
import middlewareBodyVerify from "../../middleware/body-verify/body-verify";
import Security from "../../utils/security/security";
import { middlewareAuth } from "../../middleware/auth/auth";

export default function routerAuth(prismaClient: PrismaClient, security: Security): Router {
  const router = Router();

  const serviceAuth = new ServiceAuth(prismaClient);

  router.post("/sign-in",
    middlewareBodyVerify<BodySignInServiceAuth>(["userName", "userPassword", "companyName"]),
    async (request, response) => {
      const { body } = request;

      try {
        response.status(200).json(await serviceAuth.signIn(body, security));
      } catch (error) {
        console.error(error);
        response.status(500).json({ message: "Error", description: `${error}` });
      }
    }
  );

  router.post("/",
    middlewareBodyVerify<BodyLogInServiceAuth>(["userName", "userPassword", "companyName"]),
    async (request, response) => {
      const { body } = request;

      try {
        response.status(200).json(await serviceAuth.logIn(body, security));
      } catch (error) {
        console.error(error);
        response.status(500).json({ message: "Error", description: `${error}` });
        return;;
      }
    });

  router.delete("/",
    middlewareAuth(prismaClient, security),
    async (request, response) => {
      const { payloadAccessToken } = request;

      try {
        response.status(200).json(await serviceAuth.logOut(payloadAccessToken!));
      } catch (error) {
        console.error(error);
        response.status(500).json({ message: "Error", description: `${error}` });
        return;;
      }
    });

  return router;
}