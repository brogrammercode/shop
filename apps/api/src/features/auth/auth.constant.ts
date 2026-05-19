export const AUTH_MESSAGES = {
    LOGIN_SUCCESS: 'Logged in successfully',
    REFRESH_SUCCESS: 'Token refreshed successfully',
    SESSION_SUCCESS: 'Session verified successfully',
    EMAIL_REQUIRED: 'Email is required from firebase token',
    USER_NOT_FOUND: 'User not found',
    LOGIN_REQUIRED: 'Please log in to get access',
    USER_DELETED: 'The user belonging to this token no longer exists',
};

export const AUTH_DEFAULTS = {
    EMPTY_COVER: '',
    EMPTY_BIO: '',
    USERNAME_FALLBACK: 'user',
} as const;
