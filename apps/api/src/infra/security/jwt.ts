import jwt, { SignOptions } from 'jsonwebtoken';

export class Jwt {
    static sign(payload: object, secret: string, options?: SignOptions): string {
        return jwt.sign(payload, secret, options as any);
    }

    static verify<T>(token: string, secret: string): T {
        return jwt.verify(token, secret) as T;
    }
}
