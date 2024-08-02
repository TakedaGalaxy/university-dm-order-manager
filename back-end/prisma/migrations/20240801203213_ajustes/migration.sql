-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_User" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "activeTokenId" TEXT,
    "deleted" BOOLEAN NOT NULL DEFAULT false,
    "companyId" INTEGER NOT NULL,
    "profileTypeName" TEXT NOT NULL,
    CONSTRAINT "User_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Company" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "User_profileTypeName_fkey" FOREIGN KEY ("profileTypeName") REFERENCES "ProfileType" ("name") ON DELETE RESTRICT ON UPDATE CASCADE
);
INSERT INTO "new_User" ("activeTokenId", "companyId", "deleted", "id", "name", "password", "profileTypeName") SELECT "activeTokenId", "companyId", "deleted", "id", "name", "password", "profileTypeName" FROM "User";
DROP TABLE "User";
ALTER TABLE "new_User" RENAME TO "User";
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;
