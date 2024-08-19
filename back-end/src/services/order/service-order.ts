import { Order, PrismaClient, User } from "@prisma/client";
import Security, { PayloadAcessToken } from "../../utils/security/security";
import { DataMessage, generateMessage } from "../../utils/message/message";

export type TypeOrder =
  Omit<Order, "beingMadeByUserId" | "createdByUserId" | "completedByUserId" | "deliveredByUserId"> &
  {
    beingMadeByUser: Pick<User, "id" | "name"> | null
    createdByUser: Pick<User, "id" | "name"> | null
    completedByUser: Pick<User, "id" | "name"> | null
    deliveredByUser: Pick<User, "id" | "name"> | null
  }

export default class ServiceOrder {
  prismaClient: PrismaClient;

  constructor(prismaClient: PrismaClient) {
    this.prismaClient = prismaClient;
  }

  async create(payloadAccessToken: PayloadAcessToken, body: BodyCreateServiceOrder) {
    const { table, description } = body;

    const order = await this.prismaClient.order.create({
      data: {
        table,
        description,
        createdByUserId: payloadAccessToken.userId,
        companyId: payloadAccessToken.companyId
      },
      select: {
        id: true,
        table: true,
        description: true,
        companyId: true,
        createdByUser: { select: { id: true, name: true } },
        createdAt: true,
        beingMadeByUser: { select: { id: true, name: true } },
        beingMandeAt: true,
        completedByUser: { select: { id: true, name: true } },
        completedAt: true,
        deliveredByUser: { select: { id: true, name: true } },
        deliveredAt: true,
        cancelled: true
      }
    })

    return { message: generateMessage("Sucesso", "Pedido criado com sucesso !"), order };
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
        createdByUser: { select: { id: true, name: true } },
        createdAt: true,
        beingMadeByUser: { select: { id: true, name: true } },
        beingMandeAt: true,
        completedByUser: { select: { id: true, name: true } },
        completedAt: true,
        deliveredByUser: { select: { id: true, name: true } },
        deliveredAt: true,
        cancelled: true
      }
    })

    return orders;
  }

  async getById(payloadAccessToken: PayloadAcessToken, id: number): Promise<TypeOrder> {
    const { companyId } = payloadAccessToken;

    const order = await this.prismaClient.order.findUnique({
      where: {
        id,
        companyId: companyId,
      },
      select: {
        id: true,
        table: true,
        companyId: true,
        description: true,
        createdByUser: { select: { id: true, name: true } },
        createdAt: true,
        beingMadeByUser: { select: { id: true, name: true } },
        beingMandeAt: true,
        completedByUser: { select: { id: true, name: true } },
        completedAt: true,
        deliveredByUser: { select: { id: true, name: true } },
        deliveredAt: true,
        cancelled: true
      }
    })

    if (order === null)
      throw "Pedido não encontrado !";

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

  async cancel(payloadAccessToken: PayloadAcessToken, id: number) {
    const order = await this.prismaClient.order.findUnique({
      where: {
        id,
        companyId: payloadAccessToken.companyId
      }
    });

    if (order === null)
      throw "Pedido não encontrado !";

    if (order.cancelled)
      throw "Pedido já cancelado !";

    if (order.deliveredAt !== null)
      throw "Pedido já entregue, não  pode ser cancelado!";

    await this.prismaClient.order.update({
      where: {
        id,
        companyId: payloadAccessToken.companyId,
        cancelled: false
      }, data: {
        cancelled: true
      }
    })

    return generateMessage("Sucesso", "Pedido cancelado !");
  }

  async setDelivered(payloadAccessToken: PayloadAcessToken, id: number) {
    const order = await this.prismaClient.order.findUnique({
      where: {
        id,
        companyId: payloadAccessToken.companyId
      }
    });

    if (order === null)
      throw "Pedido não encontrado !";

    if (order.cancelled)
      throw "Pedido cancelado !";

    if (order.completedAt === null)
      throw "Pedido não foi completo !";

    if (order.deliveredAt !== null)
      throw "Pedido já entregue !";

    await this.prismaClient.order.update({
      where: {
        id,
        companyId: payloadAccessToken.companyId
      },
      data: {
        deliveredByUserId: payloadAccessToken.userId,
        deliveredAt: new Date()
      }
    });

    return generateMessage("Sucesso", "Pedido marcado como entregue !");
  }

  async setComplete(payloadAccessToken: PayloadAcessToken, id: number) {
    const order = await this.prismaClient.order.findUnique({
      where: {
        id,
        companyId: payloadAccessToken.companyId
      }
    });

    if (order === null)
      throw "Pedido não encontrado !";

    if (order.cancelled)
      throw "Pedido cancelado !";

    if (order.beingMandeAt === null)
      throw "Pedido não foi começado !";

    if (order.completedAt !== null)
      throw "Pedido já foi completo !";

    if (order.beingMadeByUserId !== payloadAccessToken.userId)
      throw "Pedido está sendo feito por outro usuario !";

    await this.prismaClient.order.update({
      where: {
        id,
        companyId: payloadAccessToken.companyId
      },
      data: {
        completedByUserId: payloadAccessToken.userId,
        completedAt: new Date()
      }
    });

    return generateMessage("Sucesso", "Pedido marcado como completo !");
  }

  async setProducing(payloadAccessToken: PayloadAcessToken, id: number) {
    const order = await this.prismaClient.order.findUnique({
      where: {
        id,
        companyId: payloadAccessToken.companyId
      }
    });

    if (order === null)
      throw "Pedido não encontrado !";

    if (order.cancelled)
      throw "Pedido cancelado !";

    if (order.beingMandeAt !== null)
      throw "Pedido já foi começado a ser feito !";

    await this.prismaClient.order.update({
      where: {
        id,
        companyId: payloadAccessToken.companyId
      },
      data: {
        beingMadeByUserId: payloadAccessToken.userId,
        beingMandeAt: new Date()
      }
    });

    return generateMessage("Sucesso", "Pedido marcado como sendo feito !");
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