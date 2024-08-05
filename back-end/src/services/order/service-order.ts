import { PrismaClient } from "@prisma/client";
import Security, { PayloadAcessToken } from "../../utils/security/security";
import { DataMessage, generateMessage } from "../../utils/message/message";

export default class ServiceOrder {
  prismaClient: PrismaClient;

  constructor(prismaClient: PrismaClient) {
    this.prismaClient = prismaClient;
  }

  async create(payloadAccessToken: PayloadAcessToken, body: BodyCreateServiceOrder) {
    const { table, description } = body;

    await this.prismaClient.order.create({
      data: {
        table,
        description,
        createdByUserId: payloadAccessToken.userId,
        companyId: payloadAccessToken.companyId
      }
    })

    return generateMessage("Sucesso", "Pedido criado com sucesso !");
  }
}

export type BodyCreateServiceOrder = {
  table: string,
  description: string
}