import { Router } from 'express';
import { BusinessController } from './business.controller';
import { protect } from '../auth/auth.middleware';

const router = Router();
const controller = new BusinessController();

router.post('/initialize', protect, controller.initialize);
router.get('/search', protect, controller.search);
router.get('/context', protect, controller.getContext);
router.post('/join-requests', protect, controller.requestJoin);
router.get('/join-requests', protect, controller.getJoinRequests);
router.get('/join-requests/me', protect, controller.getMyJoinRequests);
router.post('/join-requests/:id/approve', protect, controller.approveJoinRequest);
router.post('/join-requests/:id/reject', protect, controller.rejectJoinRequest);

router.get('/branches', protect, controller.getBranches);
router.get('/branches/:id', protect, controller.getBranch);
router.post('/branches', protect, controller.createBranch);
router.patch('/branches/:id', protect, controller.updateBranch);
router.delete('/branches/:id', protect, controller.deleteBranch);

router.get('/departments', protect, controller.getDepartments);
router.get('/departments/:id', protect, controller.getDepartment);
router.post('/departments', protect, controller.createDepartment);
router.patch('/departments/:id', protect, controller.updateDepartment);
router.delete('/departments/:id', protect, controller.deleteDepartment);

router.get('/posts', protect, controller.getPosts);
router.get('/posts/:id', protect, controller.getPost);
router.post('/posts', protect, controller.createPost);
router.patch('/posts/:id', protect, controller.updatePost);
router.delete('/posts/:id', protect, controller.deletePost);

router.get('/shifts', protect, controller.getShifts);
router.get('/shifts/:id', protect, controller.getShift);
router.post('/shifts', protect, controller.createShift);
router.patch('/shifts/:id', protect, controller.updateShift);
router.delete('/shifts/:id', protect, controller.deleteShift);

router.get('/roles', protect, controller.getRoles);
router.get('/roles/:id', protect, controller.getRole);
router.post('/roles', protect, controller.createRole);
router.patch('/roles/:id', protect, controller.updateRole);
router.delete('/roles/:id', protect, controller.deleteRole);

router.get('/employees', protect, controller.getEmployees);
router.get('/employees/:id', protect, controller.getEmployee);
router.post('/employees', protect, controller.createEmployee);
router.patch('/employees/:id', protect, controller.updateEmployee);
router.delete('/employees/:id', protect, controller.deleteEmployee);

export default router;
