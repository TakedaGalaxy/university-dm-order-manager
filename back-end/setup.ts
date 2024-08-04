import { PrismaClient } from "@prisma/client";
import { ProfileType } from "./src/types/types";

async function createProfileTypes(prismaClient: PrismaClient) {
  await prismaClient.profileType.create({
    data: {
      name: ProfileType.adm
    }
  })

  await prismaClient.profileType.create({
    data: {
      name: ProfileType.chef
    }
  })

  await prismaClient.profileType.create({
    data: {
      name: ProfileType.waiter
    }
  })
}

const prismaClient = new PrismaClient();

console.log("Start Setup !");

createProfileTypes(prismaClient).then(() => {
  console.log("Setup complete !");

}).catch((error) => {
  console.error("Error on setup ", error);
})
