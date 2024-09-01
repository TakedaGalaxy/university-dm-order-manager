import { Server } from 'socket.io';
import Security, { PayloadAcessToken } from '../../utils/security/security';
import { PrismaClient } from '@prisma/client';
import { TypeOrder } from '../order/service-order';

type HandshakeType = {
  headers: {
    authorization: string
  }
}

export class SocketManager {
  private io: any;
  private security: Security
  private prismaClient: PrismaClient;

  private listListenUsers: { userId: number, companyId: number, socketId: string }[];

  constructor(server: any, prismaClient: PrismaClient, security: Security) {
    this.security = security;
    this.prismaClient = prismaClient;
    this.listListenUsers = [];
    this.io = new Server(server);
    this.setupEvents();
  }

  logConnected = () => {
    console.log('[SOCKET] New user connected');
  }

  logDisconnected = () => {
    console.log('[SOCKET] User disconnected');
  }

  updateUsersConnected = async (handshake: HandshakeType, socket: any) => {
    if(handshake.headers.authorization === undefined) {
      console.log('Authorization not found');
      return;
    }

    let paylaod: PayloadAcessToken;
    try {
      paylaod = this.security.verifyToken(handshake.headers.authorization);
    } catch (_) {
      console.log('Invalid token');
      return;
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

    if (user === null) {
      console.log('User not found');
      return;
    }

    if (user.activeTokenId !== paylaod.tokenId){
      console.log('Token revoked');
      return;
    }

    const findUser = this.listListenUsers.find((user) => user.userId === paylaod.userId);
    if (findUser !== undefined) {
      console.log('User already connected');
      return;
    }

    this.listListenUsers.push({ userId: paylaod.userId, companyId: user.companyId, socketId: socket.id });
    this.logConnected();
  }

  updateUsersDisconnected = (socket: any) => {
    const findUser = this.listListenUsers.find((user) => user.socketId === socket.id);
    if (findUser === undefined)
      return;

    this.listListenUsers = this.listListenUsers.filter((user) => user.socketId !== socket.id);
    this.logDisconnected();
  }

  notifyNewOrder = (order: TypeOrder) => {
    const users = this.listListenUsers.filter((user) => user.companyId === order.companyId);
    users.forEach((user) => {
      this.io.to(user.socketId).emit('new_order', JSON.stringify(order));
    });
  }

  setupEvents() {
    try {
      // Lidar com conexões de clientes
      this.io.on('connection', (socket: any) => {
        this.updateUsersConnected(socket.handshake, socket);

        // Lidar com a desconexão do cliente
        socket.on('disconnect', async () => {
          console.log(socket.id)
          this.updateUsersDisconnected(socket);
        });
      })
    } catch (error) {
      console.error(error);
    }
  }
}