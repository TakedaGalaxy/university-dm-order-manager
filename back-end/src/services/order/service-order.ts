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

  async getAll(payloadAccessToken: PayloadAcessToken) {
    const { companyId } = payloadAccessToken;

    const orders = await this.prismaClient.order.findMany({
      where: {
        companyId: companyId
      },
      select: {
        id: true,
        table: true,
        description: true,
        createdByUser: { select: { name: true } },
        createdAt: true,
        beingMadeByUser: { select: { name: true } },
        beingMandeAt: true,
        completedByUser: { select: { name: true } },
        completedAt: true,
        deliveredByUser: { select: { name: true } },
        deliveredAt: true,
        cancelled: true
      }
    })

    return orders;
  }

  async getById(payloadAccessToken: PayloadAcessToken, id: number) {
    const { companyId } = payloadAccessToken;

    const order = await this.prismaClient.order.findUnique({
      where: {
        id,
        companyId: companyId,
      },
      select: {
        id: true,
        table: true,
        description: true,
        createdByUser: { select: { name: true } },
        createdAt: true,
        beingMadeByUser: { select: { name: true } },
        beingMandeAt: true,
        completedByUser: { select: { name: true } },
        completedAt: true,
        deliveredByUser: { select: { name: true } },
        deliveredAt: true,
        cancelled: true
      }
    })

    return order;
  }

  async update(payloadAccessToken: PayloadAcessToken, id: number, body: BodyCreateServiceOrder) {
    const order = await this.prismaClient.order.findUnique({
      where: {
        id,
        companyId: payloadAccessToken.companyId
      }
    })

    if (order === null)
      throw "Pedido não encontrado !";

    if (order.createdByUserId !== payloadAccessToken.userId)
      throw "Não pode alterar pedido feito por outro funcionario !";

    if (order.cancelled)
      throw "Não pode alterar pedido cancelado";

    if (order.completedAt !== null)
      throw "Não pode alterar pedido completo";

    await this.prismaClient.order.update({
      where: {
        id,
        companyId: payloadAccessToken.companyId,
        cancelled: false
      }, data: {
        table: body.table,
        description: body.description
      }
    });

    return generateMessage("Sucesso", "Pedido alterado com sucesso !");
  }
}

export type BodyCreateServiceOrder = {
  table: string,
  description: string
}

export type BodyUpdateServiceOrder = {
  table: string,
  description: string
}