import { PrismaClient } from "@prisma/client";
import Security from "../../utils/security/security";
import { ProfileType } from "../../types/types";

export type BodySignInServiceAuth = {
  userName: string,
  userPassword: string,
  companyName: string
}

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
      })
    });
  }
}
