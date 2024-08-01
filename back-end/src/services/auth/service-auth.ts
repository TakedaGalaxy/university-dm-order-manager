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
    console.log(companyName, userName, userPassword);
  }
}
