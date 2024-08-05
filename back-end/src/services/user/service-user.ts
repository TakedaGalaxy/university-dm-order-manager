import { PrismaClient } from "@prisma/client";
import Security, { PayloadAcessToken } from "../../utils/security/security";
import { DataMessage, generateMessage } from "../../utils/message/message";

export default class ServiceUser {
  prismaClient: PrismaClient;

  constructor(prismaClient: PrismaClient) {
    this.prismaClient = prismaClient;
  }

  async getAll(payloadAccessToken: PayloadAcessToken) {
    const { companyId } = payloadAccessToken;

    const users = await this.prismaClient.user.findMany({
      where: {
        companyId,
        deleted: false
      }, select: {
        id: true,
        name: true,
        profileTypeName: true,
        OrderBeingMade: true,
        OrderCompleted: true,
        OrderCreated: true,
        OrderDelivered: true,
      }
    })

    return users
  }

  async get(payloadAccessToken: PayloadAcessToken, userId: number) {
    const user = await this.prismaClient.user.findUnique({
      where: {
        id: userId,
        companyId: payloadAccessToken.companyId,
        deleted: false
      },
      select: {
        id: true,
        name: true,
        profileTypeName: true,
        OrderBeingMade: true,
        OrderCompleted: true,
        OrderCreated: true,
        OrderDelivered: true,
      }
    });

    if (user === null)
      throw "Usuario não econtrado !";

    return user;
  }

  async create(payloadAccessToken: PayloadAcessToken, body: BodyCreateServiceUser, security: Security): Promise<DataMessage> {
    const { name, password, profileTypeName } = body;

    if (await this.prismaClient.profileType.findUnique({
      where: {
        name: profileTypeName
      }
    }) === null)
      throw "Tipo de conta não encontrada !";

    if (await this.prismaClient.user.findUnique({
      where: {
        name_companyId: {
          name: name,
          companyId: payloadAccessToken.companyId,
        }
      }
    }) !== null)
      throw "Name de usuario em uso !";

    await this.prismaClient.user.create({
      data: {
        name,
        password: security.encrypt(password),
        profileTypeName: profileTypeName,
        companyId: payloadAccessToken.companyId
      }
    })

    return generateMessage("Sucesso", "Usuario criado !");
  }

  async update(payloadAccessToken: PayloadAcessToken, userId: number, body: BodyCreateServiceUser, security: Security): Promise<DataMessage> {
    const { name, password, profileTypeName } = body;

    if (payloadAccessToken.userId === userId)
      throw "Não pode alterar proprios dados !";


    if (await this.prismaClient.profileType.findUnique({
      where: {
        name: profileTypeName
      }
    }) === null)
      throw "Tipo de conta não encontrada !";

    if (await this.prismaClient.user.findUnique({
      where: {
        name_companyId: {
          name: name,
          companyId: payloadAccessToken.companyId,
        }
      }
    }) !== null)
      throw "Name de usuario em uso !";

    if (await this.prismaClient.user.findUnique({
      where: {
        id: userId,
        companyId: payloadAccessToken.companyId,
        deleted: false
      }
    }) === null)
      throw "Usuario não encontrado!";

    await this.prismaClient.user.update({
      where: {
        id: userId,
        companyId: payloadAccessToken.companyId,
        deleted: false
      },
      data: {
        name,
        password: security.encrypt(password),
        profileTypeName: profileTypeName,
        companyId: payloadAccessToken.companyId,
        activeTokenId: null
      }
    })

    return generateMessage("Sucesso", "Usuario atualizado !");
  }

  async delete(payloadAccessToken: PayloadAcessToken, userId: number): Promise<DataMessage>{
    if (payloadAccessToken.userId === userId)
      throw "Não pode alterar proprios dados !";


    if (await this.prismaClient.user.findUnique({
      where: {
        id: userId,
        companyId: payloadAccessToken.companyId,
        deleted: false
      }
    }) === null)
      throw "Usuario não encontrado!";

    await this.prismaClient.user.update({
      where: {
        id: userId,
        companyId: payloadAccessToken.companyId,
      },
      data: {
        activeTokenId: null,
        deleted: true
      }
    })

    return generateMessage("Sucesso", "Usuario deleteado !");
  }
}

export type BodyCreateServiceUser = {
  name: string,
  password: string,
  profileTypeName: string,
}

export type BodyUpdateServiceUser = {
  name: string,
  password: string,
  profileTypeName: string,
}