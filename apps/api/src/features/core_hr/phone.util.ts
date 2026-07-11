import { BadRequestError } from '../../utils/error';
import { _CORE_HR_CONSTANTS } from './core_hr.constant';

export const normalizePhoneNumber = (phone: string) => {
  const raw = phone?.toString().trim() || '';
  const hasPlus = raw.startsWith('+');
  const digits = raw.replace(/\D/g, '');

  if (!digits) {
    throw new BadRequestError(_CORE_HR_CONSTANTS._E_R_R_O_R_S.PHONE_REQUIRED);
  }

  const normalized = hasPlus
    ? `+${digits}`
    : digits.length === 10
      ? `+91${digits}`
      : `+${digits}`;

  if (!/^\+[1-9]\d{7,14}$/.test(normalized)) {
    throw new BadRequestError(_CORE_HR_CONSTANTS._E_R_R_O_R_S.INVALID_PHONE);
  }

  return normalized;
};

export const isSyntheticPhone = (phone?: string | null) => {
  return !phone ||
    phone.startsWith(_CORE_HR_CONSTANTS._D_E_F_A_U_L_T_S.NO_PHONE_PREFIX) ||
    phone.startsWith(_CORE_HR_CONSTANTS._D_E_F_A_U_L_T_S.MERGED_FIELD_PREFIX);
};
