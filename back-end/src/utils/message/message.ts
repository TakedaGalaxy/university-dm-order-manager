export type DataMessage = {
  message: string,
  description: string
}

export function generateMessage(message: string, description: string): DataMessage {
  return {
    message, description
  }
}