import { Server, WebSocket } from "ws";
import * as stream from "node:stream";
import http from "http";
import Security, { PayloadAcessToken } from "../../utils/security/security";
import { PrismaClient } from "@prisma/client";
import { generateMessage } from "../../utils/message/message";
import { TypeOrder } from "../order/service-order";

type TypeCompanyId = number;
type TypeUserId = number;

export default class ServiceWebsocketOrder {
  private refWebSocketServer: Server
  private security: Security
  private prismaClient: PrismaClient;

  private listListenUsers: Map<TypeCompanyId, Map<TypeUserId, WebSocket>>;

  constructor(prismaClient: PrismaClient, security: Security) {
    this.refWebSocketServer = new WebSocket.Server({ noServer: true });
    this.security = security;
    this.prismaClient = prismaClient;
    this.listListenUsers = new Map();

    this.refWebSocketServer.on('connection', (client) => {
      this.onConnection();

      client.on('message', (message) => this.onMessage(client, message.toString()));
    });
  }

  upgradeConnection() {
    return (request: http.IncomingMessage, socket: stream.Duplex, head: Buffer) => {
      const pathname = request.url;

      if (pathname === '/websocket/order') {
        this.refWebSocketServer.handleUpgrade(request, socket, head, (ws) => {
          this.refWebSocketServer.emit('connection', ws, request);
        });
      } else {
        socket.destroy();
      }
    };
  }

  async onMessage(client: WebSocket, message: string) {
    try {
      const { accessToken, command } = JSON.parse(message);

      if (accessToken === undefined)
        throw "Token de acesso não encontrado !"

      let paylaod: PayloadAcessToken;
      try {
        paylaod = this.security.verifyToken(accessToken);
      } catch (_) {
        throw "Token invalido !";
      }

      const user = await this.prismaClient.user.findUnique({
        where: {
          id: paylaod.userId,
          deleted: false,
        }, include: {
          company: {
            select: {
              name: true
            }
          }
        }
      })

      if (user === null)
        throw "Usuario não encontrado !";

      if (user.activeTokenId !== paylaod.tokenId)
        throw "Token revogado !";

      switch (command) {
        case "listen":
          let listUsersByCompany = this.listListenUsers.get(paylaod.companyId);

          if (listUsersByCompany === undefined)
            listUsersByCompany = new Map<TypeUserId, WebSocket>();

          let clientWebSocket = listUsersByCompany.get(paylaod.userId);

          if (clientWebSocket !== undefined)
            throw "Usuario já está escutando !";

          listUsersByCompany.set(paylaod.userId, client);

          this.listListenUsers.set(paylaod.companyId, listUsersByCompany);

          client.on('close', () => this.onClose(paylaod.companyId, paylaod.userId));

          console.log(`[WEBSOCKET]: NEW LISTEN USER (${user.company.name}:${user.name})`)
          client.send(JSON.stringify(generateMessage("Sucesso", "Cliente está escutando !")));
          break;
        default:
          throw "Comando não encontrado ! ";
      }

    } catch (error) {
      client.send(JSON.stringify({
        error: true,
        message: "Falha",
        description: `${error}`
      }))
    }
  }

  onConnection() {
    console.log("[WEBSOCKET]: NEW CLIENT");
  }

  onClose(companyId: number, userId: number) {
    console.log(`[WEBSOCKET]: CLOSE CLIENT (${companyId}:${userId})`);

    let users = this.listListenUsers.get(companyId);

    if (users === undefined) return;

    users.delete(userId);

    this.listListenUsers.set(companyId, users);
  }

  broadcastUpdateOrder(order: TypeOrder) {
    const usersList = this.listListenUsers.get(order.companyId);

    usersList?.forEach((clientWebSocket) => {
      clientWebSocket.send(JSON.stringify(order));
    });
  }
}