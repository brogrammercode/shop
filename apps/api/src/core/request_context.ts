import { AsyncLocalStorage } from 'async_hooks';

export interface RequestContextData {
  uid: string;
}

export const requestContext = new AsyncLocalStorage<RequestContextData>();
