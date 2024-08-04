import { NextFunction, Request, Response } from "express";
import { ProfileType } from "../../types/types";
import { generateMessage } from "../../utils/message/message";
import Security, { PayloadAcessToken } from "../../utils/security/security";
import { PrismaClient } from "@prisma/client";

export function middlewareAuth(prismaClient: PrismaClient, security: Security, profileType?: Array<keyof typeof ProfileType>) {
  return async (request: Request, response: Response, next: NextFunction) => {
    const accessToken = request.headers.authorization;

    if (accessToken === undefined) {
      response.status(500).json(generateMessage("Não autorizado", "Absência de token !"));
      return;
    }

    let payload: PayloadAcessToken;

    try {
      payload = security.verifyToken(accessToken);
    } catch (error) {
      response.status(500).json(generateMessage("Não autorizado", "Token invalido !"));
      return;
    }

    const user = await prismaClient.user.findUnique({
      where: {
        id: payload.userId
      }
    });

    if (user === null) {
      response.status(500).json(generateMessage("Não autorizado", "Usuario não encontrado !"));
      return;
    }

    if (user.activeTokenId !== payload.tokenId) {
      response.status(500).json(generateMessage("Não autorizado", "Token revogado !"));
      return;
    }

    request.payloadAccessToken = payload;
    next();
  };
}