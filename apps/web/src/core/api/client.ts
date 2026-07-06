import axios from 'axios';
import { useUserStore } from '../store/user.store';

export const apiClient = axios.create({
  baseURL: process.env.NEXT_PUBLIC_API_URL || 'http://localhost:4000/api/v1',
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json',
  },
});

apiClient.interceptors.request.use((config) => {
  const token = useUserStore.getState().token;
  if (token && config.headers) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

apiClient.interceptors.response.use(
  (response) => response,
  (error) => {
    // We can map this to domain specific exceptions if needed.
    if (error.response?.status === 401 || error.response?.status === 403) {
      // Clear token on auth error
      useUserStore.getState().clearContext();
    }
    return Promise.reject(error);
  }
);
