import { PrismaClient } from "@prisma/client";
import { Router } from "express";
import ServiceAuth, { BodySignInServiceAuth } from "../../services/auth/service-auth";
import middlewareBodyVerify from "../../middleware/body-verify/body-verify";

export default function routerAuth(prismaClient: PrismaClient): Router {
  const router = Router();

  const serviceAuth = new ServiceAuth(prismaClient);

  router.post("/sign-in",
    middlewareBodyVerify<BodySignInServiceAuth>(["userName", "userPassword", "companyName"]),
    async (request, response) => {
      const { body } = request;

      try {
        await serviceAuth.signIn(body);
      } catch (error) {
        console.error(error);
        response.status(500).json({ message: "Error", description: "" });
        return;;
      }

      response.status(200).json({ message: "Sucesso", description: "Usuario criado com sucesso !" });
    }
  );
  
  return router;
}