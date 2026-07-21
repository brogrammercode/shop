import { Request, Response, NextFunction } from 'express';
import { authenticate, requireBranchEmployee } from '../core_hr/core_hr.middleware';
import { coreHrRepo } from '../core_hr/core_hr.repo';

export { authenticate };
export const attachBranchEmployee = async (req: Request, _res: Response, next: NextFunction) => {
  try {
    if (req.user?.uid) {
      const employee = await coreHrRepo.findEmployeeByUid(req.user.uid);
      if (employee) {
        req.employee = employee;
      }
    }
    next();
  } catch (error) {
    next(error);
  }
};
export const requirePosKdsAccess = requireBranchEmployee;
