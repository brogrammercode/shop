import { authenticate, requireBranchEmployee } from '../core_hr/core_hr.middleware';

export { authenticate };
export const requirePosKdsAccess = requireBranchEmployee;
