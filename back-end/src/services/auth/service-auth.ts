import { PrismaClient } from "@prisma/client";
import Security, { PayloadAcessToken } from "../../utils/security/security";
import { ProfileType } from "../../types/types";
import { DataMessage, generateMessage } from "../../utils/message/message";
export default class ServiceAuth {
  prismaClient: PrismaClient;

  constructor(prismaClient: PrismaClient) {
    this.prismaClient = prismaClient;
  }


  async signIn(body: BodySignInServiceAuth, security: Security): Promise<DataMessage> {
    const { companyName, userName, userPassword } = body;

    if (await this.prismaClient.company.findUnique({
      where: {
        name: companyName
      }
    }) !== null) throw "Empresa já cadastrada !"

    const encryptedUserPassword = security.encrypt(userPassword);

    await this.prismaClient.$transaction(async (client) => {
      const company = await client.company.create({
        data: {
          name: companyName
        }
      });

      await client.user.create({
        data: {
          name: userName,
          password: encryptedUserPassword,
          companyId: company.id,
          profileTypeName: ProfileType.adm
        }
      });
    });

    return generateMessage("Sucesso", "Usuario criado !");
  }

  async logIn(body: BodyLogInServiceAuth, security: Security): Promise<ResponseLogInServiceAuth> {
    const { userName, userPassword, companyName } = body;

    const company = await this.prismaClient.company.findUnique({
      where: {
        name: companyName
      }
    });

    if (company === null) throw "Empresa não encontrada !";

    const user = await this.prismaClient.user.findUnique({
      where: {
        name_companyId: {
          name: userName,
          companyId: company.id
        }
      }
    })

    if (user === null) throw "Usuario não encontrado !";

    if (user.deleted) throw "Usuario deletado !";

    const decryptedPassword = security.decrypt(user.password);

    if (userPassword !== decryptedPassword) throw "Senha incorreta !";

    const { accessToken, tokenId } = security.generateAccessToken(user.id, company.id);

    await this.prismaClient.user.update({
      where: {
        id: user.id,
      },
      data: {
        activeTokenId: tokenId
      }
    })

    return {
      accessToken
    }
  }

  async logOut(payloadAccessToken: PayloadAcessToken): Promise<DataMessage> {
    const { userId } = payloadAccessToken;

    await this.prismaClient.user.update({
      where: {
        id: userId
      },
      data: {
        activeTokenId: null
      }
    })

    return generateMessage("Sucesso", "Usuario deslogado !");
  }


  async getAccount(payloadAccessToken: PayloadAcessToken): Promise<ResponseGetAccountServiceAuth> {
    const company = await this.prismaClient.company.findUnique({
      where: {
        id: payloadAccessToken.companyId
      }
    });

    if (company === null)
      throw "Empresa não encontrada !";

    const user = await this.prismaClient.user.findUnique({
      where: {
        id: payloadAccessToken.userId
      }
    });

    if (user === null)
      throw "Usuario não encontrado !";

    return {
      userName: user.name,
      profileType: user.profileTypeName,
      companyName: company.name
    }
  }
}

export type BodySignInServiceAuth = {
  userName: string,
  userPassword: string,
  companyName: string
}

export type BodyLogInServiceAuth = {
  userName: string,
  userPassword: string,
  companyName: string
}

export type ResponseLogInServiceAuth = {
  accessToken: string,
}

export type ResponseGetAccountServiceAuth = {
  userName: string,
  companyName: string,
  profileType: string,
}