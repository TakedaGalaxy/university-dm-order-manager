import { NextFunction, Request, Response } from "express";

export default function middlewareBodyVerify<bodyType>(keys: Array<keyof bodyType>,) {
  return (request: Request, response: Response, next: NextFunction) => {
    const { body } = request;

    const paramsNotFound: Array<string> = [];

    keys.forEach((value) => {
      if (body[value] === undefined)
        paramsNotFound.push(value as string);
    })

    if (paramsNotFound.length) {
      response.status(500).json({ message: "Body Invalid", description: paramsNotFound.toString() });
      return;
    }

    next();
  };
};