export const apiClient = {
  get: async <T>(endpoint: string, params?: Record<string, string>): Promise<T> => {
    const baseUrl = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:5001/api/v1';
    
    let url = `${baseUrl}${endpoint}`;
    if (params) {
      const searchParams = new URLSearchParams(params);
      url += `?${searchParams.toString()}`;
    }

    try {
      const response = await fetch(url, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
        },
      });

      if (!response.ok) {
        throw new Error(`API Error: ${response.statusText}`);
      }

      const data = await response.json();
      // Backend pattern returns { status: 'success', data: ... }
      if (data.status === 'success' && data.data !== undefined) {
        return data.data as T;
      }
      return data as T;
    } catch (error) {
      console.error("API GET Error:", error);
      throw error;
    }
  },
  post: async <T>(endpoint: string, body: any): Promise<T> => {
    const baseUrl = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:5001/api/v1';
    
    try {
      const response = await fetch(`${baseUrl}${endpoint}`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(body),
      });

      if (!response.ok) {
        throw new Error(`API Error: ${response.statusText}`);
      }

      const data = await response.json();
      if (data.status === 'success' && data.data !== undefined) {
        return data.data as T;
      }
      return data as T;
    } catch (error) {
      console.error("API POST Error:", error);
      throw error;
    }
  },
};
