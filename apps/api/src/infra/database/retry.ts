const DATABASE_RETRY_ATTEMPTS = 2;
const DATABASE_RETRY_DELAY_MS = 120;

const TRANSIENT_DATABASE_ERROR_MESSAGES = [
  'Server has closed the connection',
  'Connection terminated due to connection timeout',
  'Connection terminated unexpectedly',
  'timeout expired',
  'Unable to start a transaction',
  'Timed out fetching a new connection',
  'Can\'t reach database server',
];

export const withDatabaseRetry = async <T>(operation: () => Promise<T>): Promise<T> => {
  let lastError: unknown;

  for (let attempt = 0; attempt <= DATABASE_RETRY_ATTEMPTS; attempt += 1) {
    try {
      return await operation();
    } catch (error) {
      lastError = error;
      if (attempt >= DATABASE_RETRY_ATTEMPTS || !isTransientDatabaseError(error)) {
        throw error;
      }
      await wait(DATABASE_RETRY_DELAY_MS * (attempt + 1));
    }
  }

  throw lastError;
};

const isTransientDatabaseError = (error: unknown) => {
  const message = error instanceof Error ? error.message : String(error);
  return TRANSIENT_DATABASE_ERROR_MESSAGES.some((value) => message.includes(value));
};

const wait = (duration: number) => new Promise((resolve) => {
  setTimeout(resolve, duration);
});
