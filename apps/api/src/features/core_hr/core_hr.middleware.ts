import { Request, Response, NextFunction } from 'express';
import { Jwt } from '../../infra/security/jwt';
import config from '../../core/config';
import { _CORE_HR_CONSTANTS } from './core_hr.constant';
import { UnauthorizedError, ForbiddenError } from '../../utils/error';
import { coreHrRepo } from './core_hr.repo';

declare global {
  namespace Express {
    interface Request {
      user?: { uid: string; id: string };
      employee?: any;
    }
  }
}

export const authenticate = (req: Request, _res: Response, next: NextFunction) => {
  try {
    const authHeader = req.headers[_CORE_HR_CONSTANTS._J_W_T.AUTH_HEADER] as string;
    if (!authHeader?.startsWith(_CORE_HR_CONSTANTS._J_W_T.BEARER_PREFIX)) {
      throw new UnauthorizedError(_CORE_HR_CONSTANTS._E_R_R_O_R_S.TOKEN_MISSING);
    }

    const token = authHeader.split(' ')[1];
    const decoded = Jwt.verify<{ uid: string; id: string }>(token, config.JWT_SECRET);
    req.user = decoded;
    next();
  } catch {
    next(new UnauthorizedError(_CORE_HR_CONSTANTS._E_R_R_O_R_S.INVALID_TOKEN));
  }
};

export const requireBranchEmployee = async (req: Request, _res: Response, next: NextFunction) => {
  try {
    if (!req.user) {
      throw new UnauthorizedError(_CORE_HR_CONSTANTS._E_R_R_O_R_S._U_N_A_U_T_H_O_R_I_Z_E_D);
    }

    const employee = await coreHrRepo.findEmployeeByUid(req.user.uid);
    if (!employee) {
      throw new ForbiddenError(_CORE_HR_CONSTANTS._E_R_R_O_R_S.NOT_AN_EMPLOYEE);
    }

    req.employee = employee;
    next();
  } catch (error) {
    next(error);
  }
};

export const requirePermission = (permission: string) => {
  return (req: Request, _res: Response, next: NextFunction) => {
    try {
      const employee = req.employee;
      if (!employee || !employee.role_rel) {
        throw new ForbiddenError(_CORE_HR_CONSTANTS._E_R_R_O_R_S.PERMISSION_DENIED);
      }

      const permissions: string[] = employee.role_rel.permissions || [];
      if (!permissions.includes(_CORE_HR_CONSTANTS._P_E_R_M_I_S_S_I_O_N_S._A_L_L) && !permissions.includes(permission)) {
        throw new ForbiddenError(_CORE_HR_CONSTANTS._E_R_R_O_R_S.PERMISSION_DENIED);
      }

      next();
    } catch (error) {
      next(error);
    }
  };
};
