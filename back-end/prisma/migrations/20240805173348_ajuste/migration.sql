-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Order" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "table" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "cancelled" BOOLEAN NOT NULL DEFAULT false,
    "companyId" INTEGER NOT NULL,
    "crearedAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdByUserId" INTEGER NOT NULL,
    "beingMandeAt" DATETIME,
    "beingMadeByUserId" INTEGER,
    "completedByUserId" INTEGER,
    "completedAt" DATETIME,
    "deliveredByUserId" INTEGER,
    "deliveredAt" DATETIME,
    CONSTRAINT "Order_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Company" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Order_createdByUserId_fkey" FOREIGN KEY ("createdByUserId") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Order_beingMadeByUserId_fkey" FOREIGN KEY ("beingMadeByUserId") REFERENCES "User" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "Order_completedByUserId_fkey" FOREIGN KEY ("completedByUserId") REFERENCES "User" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "Order_deliveredByUserId_fkey" FOREIGN KEY ("deliveredByUserId") REFERENCES "User" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);
INSERT INTO "new_Order" ("beingMadeByUserId", "beingMandeAt", "cancelled", "companyId", "completedAt", "completedByUserId", "crearedAt", "createdByUserId", "deliveredAt", "deliveredByUserId", "description", "id", "table") SELECT "beingMadeByUserId", "beingMandeAt", "cancelled", "companyId", "completedAt", "completedByUserId", "crearedAt", "createdByUserId", "deliveredAt", "deliveredByUserId", "description", "id", "table" FROM "Order";
DROP TABLE "Order";
ALTER TABLE "new_Order" RENAME TO "Order";
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;
