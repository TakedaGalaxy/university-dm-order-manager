import { PrismaClient } from "@prisma/client";

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


  async signIn(body: BodySignInServiceAuth) {
    const { companyName, userName, userPassword } = body;

    const encryptedPassword = "";

    await this.prismaClient.$transaction(async (client) => {

      const company = await client.company.create({
        data: {
          name: companyName
        }
      });

      const user = await client.user.create({
        data: {
          name: userName,
          password: encryptedPassword,
          companyId: company.id,
          profileTypeName: "adm"
        }
      })
    });
  }
}
