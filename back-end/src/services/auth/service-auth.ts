import { PrismaClient } from "@prisma/client";
import Security from "../../utils/security/security";
import { ProfileType } from "../../types/types";
export default class ServiceAuth {
  prismaClient: PrismaClient;

  constructor(prismaClient: PrismaClient) {
    this.prismaClient = prismaClient;
  }


  async signIn(body: BodySignInServiceAuth, security: Security) {
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
