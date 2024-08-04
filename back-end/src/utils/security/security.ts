import crypto from "crypto"
import jwt from "jsonwebtoken"

export default class Security {
  private readonly key: Buffer

  constructor(key: string) {
    this.key = Buffer.from(key, "hex");
  }

  encrypt(input: string): string {
    const iv = crypto.randomBytes(16);

    const cipher = crypto.createCipheriv("aes-256-cbc", this.key, iv);

    let encrypted = cipher.update(input);

    encrypted = Buffer.concat([encrypted, cipher.final()]);

    return encrypted.toString("hex") + "-" + iv.toString("hex");
  }

  decrypt(input: string) {
    const [dataString, ivString] = input.split("-");

    const iv = Buffer.from(ivString, 'hex');
    const encryptedText = Buffer.from(dataString, 'hex');

    const decipher = crypto.createDecipheriv("aes-256-cbc", this.key, iv);

    let decrypted = decipher.update(encryptedText);
    decrypted = Buffer.concat([decrypted, decipher.final()]);

    return decrypted.toString();
  }

  generateAccessToken(userId: number, companyId: number): { accessToken: string, tokenId: string } {
    // Dados do usuário (payload) que serão incorporados no token
    const tokenId = `${userId}:${new Date().getTime()}`;

    const payload: PayloadAcessToken = {
      userId,
      companyId,
      tokenId
    };

    const options = {
      expiresIn: '8h'
    };

    const accessToken = jwt.sign(payload, this.key, options);

    return {
      accessToken, tokenId
    }
  }

  verifyToken(token: string): PayloadAcessToken {
    let payload;

    try {
      payload = jwt.verify(token, this.key);
    } catch (error) {
      console.log(error);
      throw "Token invalido !";
    }

    return payload as PayloadAcessToken;
  }
}

export type PayloadAcessToken = {
  userId: number,
  companyId: number,
  tokenId: string,
}