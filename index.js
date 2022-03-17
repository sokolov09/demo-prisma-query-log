const { createPrismaQueryEventHandler } = require("prisma-query-log");
const { PrismaClient } = require("@prisma/client");

(async () => {
  const prisma = new PrismaClient({
    log: [
      {
        level: "query",
        emit: "event",
      },
    ],
  });
  prisma.$on("query", createPrismaQueryEventHandler());
  const result = await prisma.test.create({
    data: {
      description: `she will give him ten days of "love,"  at blabla....`,
    },
  });
  console.log("OK");
})();
