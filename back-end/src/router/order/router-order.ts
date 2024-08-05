import { PrismaClient } from "@prisma/client";
import { Router } from "express";
import Security from "../../utils/security/security";
import { middlewareAuth } from "../../middleware/auth/auth";
import middlewareBodyVerify from "../../middleware/body-verify/body-verify";
import ServiceOrder, { BodyCreateServiceOrder, BodyUpdateServiceOrder } from "../../services/order/service-order";

export default function routerOrder(prismaClient: PrismaClient, security: Security): Router {
  const router = Router();

  const serviceOrder = new ServiceOrder(prismaClient);

  router.post("/",
    middlewareAuth(prismaClient, security, ["waiter"]),
    middlewareBodyVerify<BodyCreateServiceOrder>(["table", "description"]),
    async (request, response) => {
      const { payloadAccessToken, body } = request;

      try {
        response.status(200).json(await serviceOrder.create(payloadAccessToken!, body));
      } catch (error) {
        console.error(error);
        response.status(500).json({ message: "Error", description: `${error}` });
      }
    }
  );

  router.get("/",
    middlewareAuth(prismaClient, security, ["adm", "waiter", "chef"]),
    async (request, response) => {
      const { payloadAccessToken } = request;

      try {
        response.status(200).json(await serviceOrder.getAll(payloadAccessToken!));
      } catch (error) {
        console.error(error);
        response.status(500).json({ message: "Error", description: `${error}` });
      }
    }
  );

  router.get("/:id",
    middlewareAuth(prismaClient, security, ["adm", "waiter", "chef"]),
    async (request, response) => {
      const { payloadAccessToken, params } = request;

      try {
        response.status(200).json(await serviceOrder.getById(payloadAccessToken!, Number(params.id)));
      } catch (error) {
        console.error(error);
        response.status(500).json({ message: "Error", description: `${error}` });
      }
    }
  );

  router.post("/:id",
    middlewareAuth(prismaClient, security, ["waiter"]),
    middlewareBodyVerify<BodyUpdateServiceOrder>(["table", "description"]),
    async (request, response) => {
      const { payloadAccessToken, params, body } = request;

      try {
        response.status(200).json(await serviceOrder.update(payloadAccessToken!, Number(params.id), body));
      } catch (error) {
        console.error(error);
        response.status(500).json({ message: "Error", description: `${error}` });
      }
    }
  );

  router.delete("/:id",
    middlewareAuth(prismaClient, security, ["waiter"]),
    async (request, response) => {
      const { payloadAccessToken, params } = request;

      try {
        response.status(200).json(await serviceOrder.cancel(payloadAccessToken!, Number(params.id)));
      } catch (error) {
        console.error(error);
        response.status(500).json({ message: "Error", description: `${error}` });
      }
    }
  );

  router.put("/delivered/:id",
    middlewareAuth(prismaClient, security, ["waiter"]),
    async (request, response) => {
      const { payloadAccessToken, params } = request;

      try {
        response.status(200).json(await serviceOrder.setDelivered(payloadAccessToken!, Number(params.id)));
      } catch (error) {
        console.error(error);
        response.status(500).json({ message: "Error", description: `${error}` });
      }
    }
  );

  router.put("/complete/:id",
    middlewareAuth(prismaClient, security, ["chef"]),
    async (request, response) => {
      const { payloadAccessToken, params } = request;

      try {
        response.status(200).json(await serviceOrder.setComplete(payloadAccessToken!, Number(params.id)));
      } catch (error) {
        console.error(error);
        response.status(500).json({ message: "Error", description: `${error}` });
      }
    }
  );

  return router;
}