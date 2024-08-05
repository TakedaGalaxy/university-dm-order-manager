/*
  Warnings:

  - A unique constraint covering the columns `[name,companyId]` on the table `User` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateIndex
CREATE UNIQUE INDEX "User_name_companyId_key" ON "User"("name", "companyId");
