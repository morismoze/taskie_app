import { HttpStatus } from '@nestjs/common';
import { Test, TestingModule } from '@nestjs/testing';
import { DateTime } from 'luxon';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';
import { GoalService } from 'src/modules/goal/goal.service';
import { SessionService } from 'src/modules/session/session.service';
import { TaskAssignmentService } from 'src/modules/task/task-assignment/task-assignment.service';
import { ProgressStatus } from 'src/modules/task/task-module/domain/progress-status.enum';
import { TaskService } from 'src/modules/task/task-module/task.service';
import { UnitOfWorkService } from 'src/modules/unit-of-work/unit-of-work.service';
import { UserStatus } from 'src/modules/user/domain/user-status.enum';
import { User } from 'src/modules/user/domain/user.domain';
import { UserService } from 'src/modules/user/user.service';
import { WorkspaceInviteService } from '../workspace-invite/workspace-invite.service';
import { WorkspaceUserRole } from '../workspace-user-module/domain/workspace-user-role.enum';
import { WorkspaceUserService } from '../workspace-user-module/workspace-user.service';
import { Workspace } from './domain/workspace.domain';
import { WorkspaceRepository } from './persistence/workspace.repository';
import { WorkspaceService } from './workspace.service';

// --- FACTORIES ---

const mockUserFactory = (overrides?: Partial<User>): User =>
  ({
    id: 'user-1',
    email: 'test@example.com',
    firstName: 'John',
    lastName: 'Doe',
    profileImageUrl: null,
    provider: null,
    socialId: null,
    status: UserStatus.ACTIVE,
    createdAt: new Date(),
    updatedAt: new Date(),
    deletedAt: null,
    ...overrides,
  }) as User;

const mockWorkspaceFactory = (overrides?: Partial<Workspace>): Workspace =>
  ({
    id: 'workspace-1',
    name: 'Test Workspace',
    description: 'Desc',
    pictureUrl: null,
    createdAt: new Date(),
    updatedAt: new Date(),
    deletedAt: null,
    createdBy: mockUserFactory(),
    members: [],
    ...overrides,
  }) as Workspace;

const mockWorkspaceUserFactory = (overrides?: any) => ({
  id: 'workspace-user-1',
  workspaceRole: WorkspaceUserRole.MEMBER,
  user: mockUserFactory(),
  workspace: mockWorkspaceFactory(),
  // Dodao sam default null za createdBy da izbjegnem cirkularne greške,
  // ali u testovima gdje je bitno (npr. getWorkspaceUsers) ćemo ga overrideati
  createdBy: null,
  ...overrides,
});

const mockTaskCoreFactory = (overrides?: any) => ({
  id: 'task-1',
  title: 'Task Title',
  description: 'Task Desc',
  rewardPoints: 100,
  dueDate: new Date(),
  createdAt: new Date(),
  updatedAt: new Date(),
  deletedAt: null,
  assignees: [],
  createdBy: null,
  ...overrides,
});

const mockGoalCoreFactory = (overrides?: any) => ({
  id: 'goal-1',
  title: 'Goal',
  description: 'Desc',
  requiredPoints: 500,
  status: ProgressStatus.IN_PROGRESS,
  // Proširio sam assignee objekt jer ga getWorkspaceGoals koristi
  assignee: {
    id: 'assignee-id',
    firstName: 'John',
    lastName: 'Doe',
    profileImageUrl: null,
  },
  createdBy: null,
  createdAt: new Date(),
  ...overrides,
});

// --- MOCK REPOSITORIES/SERVICES ---

const createMockRepository = () => ({
  create: jest.fn(),
  update: jest.fn(),
  findById: jest.fn(),
  findAllByUserId: jest.fn(),
  delete: jest.fn(),
});

const createMockUserService = () => ({
  create: jest.fn(),
  createVirtualUser: jest.fn(),
  update: jest.fn(),
});

const createMockWorkspaceUserService = () => ({
  create: jest.fn(),
  findByUserIdAndWorkspaceId: jest.fn(),
  findByIdAndWorkspaceId: jest.fn(),
  findByIdAndWorkspaceIdWithUser: jest.fn(),
  findByIdAndWorkspaceIdWithUserAndCreatedByUser: jest.fn(),
  findByIdsAndWorkspaceIdWithUserAndCreatedByUser: jest.fn(), // Dodano jer fali u tvom snippetu
  findAllByUserIdWithWorkspace: jest.fn(),
  countManagers: jest.fn(),
  getLeaderboardData: jest.fn(),
  update: jest.fn(),
  delete: jest.fn(),
  countByWorkspace: jest.fn(),
});

const createMockTaskService = () => ({
  findPaginatedByWorkspaceWithAssignees: jest.fn(),
  create: jest.fn(),
  findByTaskIdAndWorkspaceId: jest.fn(),
  updateByTaskIdAndWorkspaceId: jest.fn(),
});

const createMockGoalService = () => ({
  findPaginatedByWorkspaceWithAssignee: jest.fn(),
  create: jest.fn(),
  findByGoalIdAndWorkspaceId: jest.fn(),
  updateByGoalIdAndWorkspaceId: jest.fn(),
  closeByGoalIdAndWorkspaceId: jest.fn(),
});

const createMockTaskAssignmentService = () => ({
  getAccumulatedPointsForWorkspaceUser: jest.fn(),
  createMultiple: jest.fn(),
  updateAssignmentsByTaskId: jest.fn(),
  deleteByTaskIdAndAssigneeId: jest.fn(),
  closeAssignmentsByTaskId: jest.fn(),
  findAllByTaskId: jest.fn(),
});

const createMockWorkspaceInviteService = () => ({
  createInviteToken: jest.fn(),
  findByTokenWithWorkspace: jest.fn(),
  claimInvite: jest.fn(),
});

const createMockSessionService = () => ({
  incrementAccessTokenVersionByUserId: jest.fn(),
});

const createMockUnitOfWorkService = () => ({
  withTransaction: jest.fn().mockImplementation((cb) => cb()),
});

describe('WorkspaceService', () => {
  let service: WorkspaceService;
  let workspaceRepository: ReturnType<typeof createMockRepository>;
  let workspaceUserService: ReturnType<typeof createMockWorkspaceUserService>;
  let userService: ReturnType<typeof createMockUserService>;
  let taskService: ReturnType<typeof createMockTaskService>;
  let goalService: ReturnType<typeof createMockGoalService>;
  let taskAssignmentService: ReturnType<typeof createMockTaskAssignmentService>;
  let workspaceInviteService: ReturnType<
    typeof createMockWorkspaceInviteService
  >;
  let sessionService: ReturnType<typeof createMockSessionService>;

  beforeEach(async () => {
    jest.clearAllMocks();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        WorkspaceService,
        {
          provide: WorkspaceRepository,
          useValue: createMockRepository(),
        },
        {
          provide: WorkspaceUserService,
          useValue: createMockWorkspaceUserService(),
        },
        {
          provide: UserService,
          useValue: createMockUserService(),
        },
        {
          provide: TaskService,
          useValue: createMockTaskService(),
        },
        {
          provide: GoalService,
          useValue: createMockGoalService(),
        },
        {
          provide: TaskAssignmentService,
          useValue: createMockTaskAssignmentService(),
        },
        {
          provide: WorkspaceInviteService,
          useValue: createMockWorkspaceInviteService(),
        },
        {
          provide: SessionService,
          useValue: createMockSessionService(),
        },
        {
          provide: UnitOfWorkService,
          useValue: createMockUnitOfWorkService(),
        },
      ],
    }).compile();

    service = module.get<WorkspaceService>(WorkspaceService);
    workspaceRepository = module.get(WorkspaceRepository);
    workspaceUserService = module.get(WorkspaceUserService);
    userService = module.get(UserService);
    taskService = module.get(TaskService);
    goalService = module.get(GoalService);
    taskAssignmentService = module.get(TaskAssignmentService);
    workspaceInviteService = module.get(WorkspaceInviteService);
    sessionService = module.get(SessionService);
  });

  // --- TVOJI POPRAVLJENI TESTOVI ---

  describe('create', () => {
    it('creates a workspace and adds creator as manager', async () => {
      const mockWorkspace = mockWorkspaceFactory();
      workspaceRepository.create.mockResolvedValue(mockWorkspace);

      const result = await service.create({
        createdById: 'user-1',
        data: { name: 'New WS', description: 'Desc' },
      });

      expect(workspaceRepository.create).toHaveBeenCalledWith({
        data: {
          name: 'New WS',
          description: 'Desc',
          pictureUrl: null,
        },
        createdById: 'user-1',
        relations: { createdBy: true },
      });

      expect(workspaceUserService.create).toHaveBeenCalledWith({
        workspaceId: mockWorkspace.id,
        userId: 'user-1',
        createdById: null,
        workspaceRole: WorkspaceUserRole.MANAGER,
      });

      expect(result.id).toBe(mockWorkspace.id);
    });

    it('throws SERVER_ERROR if workspace creation fails', async () => {
      workspaceRepository.create.mockResolvedValue(null);

      await expect(
        service.create({
          createdById: 'user-1',
          data: { name: 'Fail' },
        }),
      ).rejects.toMatchObject({
        status: HttpStatus.INTERNAL_SERVER_ERROR,
        response: { code: ApiErrorCode.SERVER_ERROR },
      });
    });
  });

  describe('updateWorkspace', () => {
    it('updates workspace data', async () => {
      const updatedWorkspace = mockWorkspaceFactory({ name: 'Updated' });
      workspaceRepository.update.mockResolvedValue(updatedWorkspace);

      const result = await service.updateWorkspace({
        workspaceId: 'ws-1',
        data: { name: 'Updated' },
      });

      expect(workspaceRepository.update).toHaveBeenCalledWith({
        id: 'ws-1',
        data: { name: 'Updated' },
        relations: { createdBy: true },
      });
      expect(result.name).toBe('Updated');
    });

    it('throws NOT_FOUND if update fails', async () => {
      workspaceRepository.update.mockResolvedValue(null);

      await expect(
        service.updateWorkspace({
          workspaceId: 'ws-1',
          data: { name: 'Updated' },
        }),
      ).rejects.toMatchObject({
        status: HttpStatus.NOT_FOUND,
        response: { code: ApiErrorCode.INVALID_PAYLOAD },
      });
    });
  });

  describe('createInviteToken', () => {
    it('creates invite token successfully', async () => {
      const workspace = mockWorkspaceFactory();
      const wsUser = mockWorkspaceUserFactory();
      const invite = {
        token: 'token-123',
        expiresAt: new Date(),
      };

      workspaceRepository.findById.mockResolvedValue(workspace);
      workspaceUserService.findByUserIdAndWorkspaceId.mockResolvedValue(wsUser);
      workspaceInviteService.createInviteToken.mockResolvedValue(invite as any);

      const result = await service.createInviteToken({
        workspaceId: 'ws-1',
        createdById: 'user-1',
      });

      expect(result.token).toBe('token-123');
      expect(workspaceInviteService.createInviteToken).toHaveBeenCalledWith({
        workspaceId: 'ws-1',
        createdByWorkspaceUserId: wsUser.id,
      });
    });

    it('throws NOT_FOUND if workspace does not exist', async () => {
      workspaceRepository.findById.mockResolvedValue(null);

      await expect(
        service.createInviteToken({
          workspaceId: 'ws-1',
          createdById: 'user-1',
        }),
      ).rejects.toMatchObject({
        status: HttpStatus.NOT_FOUND,
        response: { code: ApiErrorCode.INVALID_PAYLOAD },
      });
    });
  });

  describe('createTask', () => {
    it('creates task and assignments', async () => {
      const workspace = mockWorkspaceFactory();
      const wsUser = mockWorkspaceUserFactory();
      const newTask = mockTaskCoreFactory();
      const createdAssignments = [
        {
          assignee: {
            id: 'ws-u-1',
            user: { firstName: 'John', lastName: 'Doe', profileImageUrl: null },
          },
          status: ProgressStatus.IN_PROGRESS,
        },
      ];

      workspaceRepository.findById.mockResolvedValue(workspace);
      workspaceUserService.findByUserIdAndWorkspaceId.mockResolvedValue(wsUser);
      taskService.create.mockResolvedValue(newTask);
      taskAssignmentService.createMultiple.mockResolvedValue(
        createdAssignments,
      );

      const result = await service.createTask({
        workspaceId: 'ws-1',
        createdById: 'user-1',
        data: {
          title: 'Task',
          rewardPoints: 100,
          assignees: ['ws-u-1'],
        } as any,
      });

      expect(taskService.create).toHaveBeenCalledWith({
        workspaceId: 'ws-1',
        createdById: wsUser.id,
        data: expect.any(Object),
      });

      expect(taskAssignmentService.createMultiple).toHaveBeenCalledWith({
        assignments: [
          { workspaceUserId: 'ws-u-1', status: ProgressStatus.IN_PROGRESS },
        ],
        taskId: newTask.id,
      });

      expect(result.assignees).toHaveLength(1);
    });
  });

  describe('updateTask', () => {
    it('updates task if not closed', async () => {
      const workspace = mockWorkspaceFactory();
      const updatedTask = mockTaskCoreFactory({
        assignees: [
          {
            id: 'a1',
            firstName: 'A',
            lastName: 'B',
            profileImageUrl: null,
            status: ProgressStatus.IN_PROGRESS,
          },
        ],
      });

      workspaceRepository.findById.mockResolvedValue(workspace);
      taskAssignmentService.findAllByTaskId.mockResolvedValue([
        { status: ProgressStatus.IN_PROGRESS },
      ]);
      taskService.updateByTaskIdAndWorkspaceId.mockResolvedValue(updatedTask);

      const result = await service.updateTask({
        workspaceId: 'ws-1',
        taskId: 't-1',
        payload: { title: 'Updated' } as any,
      });

      expect(taskService.updateByTaskIdAndWorkspaceId).toHaveBeenCalled();
      expect(result.title).toBe('Task Title'); // from mock factory
    });

    it('throws TASK_CLOSED if any assignment is closed', async () => {
      workspaceRepository.findById.mockResolvedValue(mockWorkspaceFactory());
      taskAssignmentService.findAllByTaskId.mockResolvedValue([
        { status: ProgressStatus.CLOSED },
      ]);

      await expect(
        service.updateTask({
          workspaceId: 'ws-1',
          taskId: 't-1',
          payload: {} as any,
        }),
      ).rejects.toMatchObject({
        status: HttpStatus.UNPROCESSABLE_ENTITY,
        response: { code: ApiErrorCode.TASK_CLOSED },
      });
    });
  });

  describe('createGoal', () => {
    it('creates goal if required points are greater than current accumulated points', async () => {
      const workspace = mockWorkspaceFactory();
      const wsUser = mockWorkspaceUserFactory();
      const newGoal = mockGoalCoreFactory({ requiredPoints: 1000 });

      workspaceRepository.findById.mockResolvedValue(workspace);
      workspaceUserService.findByUserIdAndWorkspaceId.mockResolvedValue(wsUser);
      taskAssignmentService.getAccumulatedPointsForWorkspaceUser.mockResolvedValue(
        500,
      );
      goalService.create.mockResolvedValue(newGoal);

      const result = await service.createGoal({
        workspaceId: 'ws-1',
        createdById: 'user-1',
        data: {
          title: 'Goal',
          requiredPoints: 1000,
          assignee: 'ws-u-target',
        } as any,
      });

      expect(result.requiredPoints).toBe(1000);
      expect(result.accumulatedPoints).toBe(500);
    });

    it('throws UNPROCESSABLE_ENTITY if required points are insufficient', async () => {
      workspaceRepository.findById.mockResolvedValue(mockWorkspaceFactory());
      workspaceUserService.findByUserIdAndWorkspaceId.mockResolvedValue(
        mockWorkspaceUserFactory(),
      );
      taskAssignmentService.getAccumulatedPointsForWorkspaceUser.mockResolvedValue(
        1000,
      ); // User has 1000

      await expect(
        service.createGoal({
          workspaceId: 'ws-1',
          createdById: 'user-1',
          data: { requiredPoints: 200, assignee: 'ws-u-target' } as any, // Requires 200
        }),
      ).rejects.toMatchObject({
        status: HttpStatus.UNPROCESSABLE_ENTITY,
        response: { code: ApiErrorCode.INVALID_PAYLOAD },
      });
    });
  });

  describe('leaveWorkspace', () => {
    it('allows MEMBER to leave freely', async () => {
      const wsUser = mockWorkspaceUserFactory({
        workspaceRole: WorkspaceUserRole.MEMBER,
      });
      workspaceUserService.findByUserIdAndWorkspaceId.mockResolvedValue(wsUser);

      await service.leaveWorkspace({
        workspaceId: 'ws-1',
        userId: 'user-1',
      });

      expect(workspaceUserService.countByWorkspace).not.toHaveBeenCalled();
      expect(workspaceUserService.delete).toHaveBeenCalledWith(wsUser.id);
    });

    it('allows MANAGER to leave if OTHER MANAGERS exist', async () => {
      const wsUser = mockWorkspaceUserFactory({
        workspaceRole: WorkspaceUserRole.MANAGER,
      });
      workspaceUserService.findByUserIdAndWorkspaceId.mockResolvedValue(wsUser);
      // Mock: There IS another manager
      workspaceUserService.countByWorkspace.mockResolvedValueOnce(1);

      await service.leaveWorkspace({
        workspaceId: 'ws-1',
        userId: 'user-1',
      });

      expect(workspaceUserService.countByWorkspace).toHaveBeenCalledWith(
        'ws-1',
        expect.objectContaining({ role: WorkspaceUserRole.MANAGER }),
      );
      // Calls workspaceUser delete (just leaving)
      expect(workspaceUserService.delete).toHaveBeenCalledWith(wsUser.id);
      // Does NOT delete workspace
      expect(workspaceRepository.delete).not.toHaveBeenCalled();
    });

    it('throws SOLE_MANAGER_CONFLICT if user is SOLE MANAGER and REAL USERS exist', async () => {
      const wsUser = mockWorkspaceUserFactory({
        workspaceRole: WorkspaceUserRole.MANAGER,
      });
      workspaceUserService.findByUserIdAndWorkspaceId.mockResolvedValue(wsUser);

      // Mock 1: No other managers
      workspaceUserService.countByWorkspace.mockResolvedValueOnce(0);
      // Mock 2: Yes other real users
      workspaceUserService.countByWorkspace.mockResolvedValueOnce(1);

      await expect(
        service.leaveWorkspace({
          workspaceId: 'ws-1',
          userId: 'user-1',
        }),
      ).rejects.toMatchObject({
        status: HttpStatus.CONFLICT,
        response: { code: ApiErrorCode.SOLE_MANAGER_CONFLICT },
      });

      expect(workspaceUserService.delete).not.toHaveBeenCalled();
      expect(workspaceRepository.delete).not.toHaveBeenCalled();
    });

    it('deletes WORKSPACE if user is SOLE MANAGER and NO REAL USERS exist', async () => {
      const wsUser = mockWorkspaceUserFactory({
        workspaceRole: WorkspaceUserRole.MANAGER,
      });
      workspaceUserService.findByUserIdAndWorkspaceId.mockResolvedValue(wsUser);

      // Mock 1: No other managers
      workspaceUserService.countByWorkspace.mockResolvedValueOnce(0);
      // Mock 2: No other real users
      workspaceUserService.countByWorkspace.mockResolvedValueOnce(0);

      await service.leaveWorkspace({
        workspaceId: 'ws-1',
        userId: 'user-1',
      });

      // Should NOT call workspaceUser delete (cascade handles it)
      expect(workspaceUserService.delete).not.toHaveBeenCalled();
      // SHOULD delete the workspace itself
      expect(workspaceRepository.delete).toHaveBeenCalledWith('ws-1');
    });
  });

  describe('updateWorkspaceUser', () => {
    it('updates virtual user core data', async () => {
      const workspace = mockWorkspaceFactory();
      const virtualWsUser = mockWorkspaceUserFactory({
        id: 'virt-ws-u',
        user: mockUserFactory({
          email: null, // Virtual user marker
          provider: null,
          socialId: null,
        }),
        createdBy: mockUserFactory(),
      });
      const updater = mockWorkspaceUserFactory({ id: 'updater-id' });

      workspaceRepository.findById.mockResolvedValue(workspace);
      workspaceUserService.findByIdAndWorkspaceIdWithUser.mockResolvedValue(
        virtualWsUser,
      );
      workspaceUserService.findByUserIdAndWorkspaceId.mockResolvedValue(
        updater,
      );
      workspaceUserService.findByIdAndWorkspaceIdWithUserAndCreatedByUser.mockResolvedValue(
        virtualWsUser,
      );

      await service.updateWorkspaceUser({
        updatedById: 'updater',
        workspaceId: 'ws-1',
        workspaceUserId: 'virt-ws-u',
        data: { firstName: 'New', lastName: 'Name' } as any,
      });

      expect(userService.update).toHaveBeenCalledWith({
        id: virtualWsUser.user.id,
        data: { firstName: 'New', lastName: 'Name' },
      });
      expect(workspaceUserService.update).not.toHaveBeenCalled();
    });

    it('updates real user workspace role', async () => {
      const workspace = mockWorkspaceFactory();
      const realWsUser = mockWorkspaceUserFactory({
        user: mockUserFactory({ email: 'real@email.com' }), // Real user marker
        createdBy: null,
      });
      const updater = mockWorkspaceUserFactory({ id: 'updater-id' });
      workspaceRepository.findById.mockResolvedValue(workspace);
      workspaceUserService.findByIdAndWorkspaceIdWithUser.mockResolvedValue(
        realWsUser,
      );
      workspaceUserService.findByUserIdAndWorkspaceId.mockResolvedValue(
        updater,
      );
      workspaceUserService.findByIdAndWorkspaceIdWithUserAndCreatedByUser.mockResolvedValue(
        realWsUser,
      );

      await service.updateWorkspaceUser({
        updatedById: 'updater',
        workspaceId: 'ws-1',
        workspaceUserId: realWsUser.id,
        data: { role: WorkspaceUserRole.MANAGER } as any,
      });

      expect(workspaceUserService.update).toHaveBeenCalledWith({
        id: realWsUser.id,
        data: { workspaceRole: WorkspaceUserRole.MANAGER },
      });
      expect(userService.update).not.toHaveBeenCalled();
      // Should trigger session invalidation for real user
      expect(
        sessionService.incrementAccessTokenVersionByUserId,
      ).toHaveBeenCalledWith(realWsUser.user.id);
    });
  });

  // --- PREOSTALI TESTOVI (KOJI SU NEDOSTAJALI) ---

  describe('getWorkspacesByUser', () => {
    it('returns list of workspaces', async () => {
      const workspaces = [mockWorkspaceFactory(), mockWorkspaceFactory()];
      workspaceRepository.findAllByUserId.mockResolvedValue(workspaces);

      const result = await service.getWorkspacesByUser('user-1');
      expect(result).toHaveLength(2);
    });
  });

  describe('getUserSoleOwnerWorkspaces', () => {
    it('returns workspaces where user is the last manager', async () => {
      const wsUser = mockWorkspaceUserFactory({
        workspaceRole: WorkspaceUserRole.MANAGER,
        workspace: mockWorkspaceFactory({ id: 'ws-1', name: 'Sole' }),
      });
      workspaceUserService.findAllByUserIdWithWorkspace.mockResolvedValue([
        wsUser,
      ]);

      const result = await service.getUserSoleOwnerWorkspaces('user-1');
      expect(result).toHaveLength(1);
      expect(result[0].id).toBe('ws-1');
    });
  });

  describe('getWorkspaceInfoByWorkspaceInviteToken', () => {
    it('returns workspace info for valid token', async () => {
      const invite = {
        workspace: mockWorkspaceFactory(),
        createdAt: new Date(),
      };
      workspaceInviteService.findByTokenWithWorkspace.mockResolvedValue(
        invite as any,
      );

      const result =
        await service.getWorkspaceInfoByWorkspaceInviteToken('token');
      expect(result.id).toBe(invite.workspace.id);
    });

    it('throws NOT_FOUND for invalid token', async () => {
      workspaceInviteService.findByTokenWithWorkspace.mockResolvedValue(null);
      await expect(
        service.getWorkspaceInfoByWorkspaceInviteToken('invalid'),
      ).rejects.toMatchObject({ status: HttpStatus.NOT_FOUND });
    });
  });

  describe('joinWorkspace', () => {
    it('joins workspace successfully', async () => {
      const invite = {
        workspace: mockWorkspaceFactory(),
        createdAt: new Date(),
      };
      workspaceInviteService.claimInvite.mockResolvedValue(invite as any);

      const result = await service.joinWorkspace({
        inviteToken: 'token',
        usedById: 'user-1',
      });
      expect(result.id).toBe(invite.workspace.id);
    });
  });

  describe('createVirtualUser', () => {
    it('creates virtual user', async () => {
      const workspace = mockWorkspaceFactory();
      const creator = mockWorkspaceUserFactory();
      const newUser = mockUserFactory();
      const newWsUser = mockWorkspaceUserFactory();

      workspaceRepository.findById.mockResolvedValue(workspace);
      workspaceUserService.findByUserIdAndWorkspaceId.mockResolvedValue(
        creator,
      );
      userService.createVirtualUser.mockResolvedValue(newUser);
      workspaceUserService.create.mockResolvedValue(newWsUser);

      const result = await service.createVirtualUser({
        workspaceId: 'ws-1',
        createdById: 'user-1',
        data: { firstName: 'V', lastName: 'U' },
      });

      expect(userService.createVirtualUser).toHaveBeenCalled();
      expect(result.id).toBe(newWsUser.id);
    });
  });

  describe('getWorkspaceUsers', () => {
    it('returns sorted workspace users', async () => {
      const member1 = mockWorkspaceUserFactory({
        id: '1',
        user: mockUserFactory({ firstName: 'B' }),
      });
      const member2 = mockWorkspaceUserFactory({
        id: '2',
        user: mockUserFactory({ firstName: 'A' }),
      });
      const workspace = mockWorkspaceFactory({ members: [member1, member2] });

      workspaceRepository.findById.mockResolvedValue(workspace);

      const result = await service.getWorkspaceUsers('ws-1');
      expect(result[0].firstName).toBe('A'); // Sorted alphabetically
      expect(result[1].firstName).toBe('B');
    });
  });

  describe('removeUserFromWorkspace', () => {
    it('removes user and invalidates session', async () => {
      const wsUser = mockWorkspaceUserFactory();
      workspaceRepository.findById.mockResolvedValue(mockWorkspaceFactory());
      workspaceUserService.findByIdAndWorkspaceIdWithUser.mockResolvedValue(
        wsUser,
      );

      await service.removeUserFromWorkspace({
        workspaceId: 'ws-1',
        workspaceUserId: wsUser.id,
      });

      expect(
        sessionService.incrementAccessTokenVersionByUserId,
      ).toHaveBeenCalled();
      expect(workspaceUserService.delete).toHaveBeenCalled();
    });
  });

  describe('getWorkspaceLeaderboard', () => {
    it('returns leaderboard data', async () => {
      workspaceRepository.findById.mockResolvedValue(mockWorkspaceFactory());
      workspaceUserService.getLeaderboardData.mockResolvedValue([]);

      await service.getWorkspaceLeaderboard('ws-1');
      expect(workspaceUserService.getLeaderboardData).toHaveBeenCalledWith(
        'ws-1',
      );
    });
  });

  describe('getWorkspaceUserAccumulatedPoints', () => {
    it('returns points', async () => {
      taskAssignmentService.getAccumulatedPointsForWorkspaceUser.mockResolvedValue(
        100,
      );
      const result = await service.getWorkspaceUserAccumulatedPoints({
        workspaceId: 'ws-1',
        workspaceUserId: 'user-1',
      });
      expect(result.accumulatedPoints).toBe(100);
    });
  });

  describe('getWorkspaceTasks', () => {
    it('returns paginated tasks with mapped assignees', async () => {
      const task = mockTaskCoreFactory({
        assignees: [mockWorkspaceUserFactory().user], // Mapped in service logic from core
      });
      workspaceRepository.findById.mockResolvedValue(mockWorkspaceFactory());
      taskService.findPaginatedByWorkspaceWithAssignees.mockResolvedValue({
        data: [task],
        total: 1,
        totalPages: 1,
      });

      const result = await service.getWorkspaceTasks({
        workspaceId: 'ws-1',
        query: {},
      });
      expect(result.items).toHaveLength(1);
    });
  });

  describe('closeTask', () => {
    it('closes all assignments', async () => {
      taskService.findByTaskIdAndWorkspaceId.mockResolvedValue(
        mockTaskCoreFactory(),
      );

      await service.closeTask({ workspaceId: 'ws-1', taskId: 't-1' });
      expect(
        taskAssignmentService.closeAssignmentsByTaskId,
      ).toHaveBeenCalledWith('t-1');
    });
  });

  describe('addTaskAssignees', () => {
    it('adds assignees to task', async () => {
      const task = mockTaskCoreFactory();
      const existingUser = mockWorkspaceUserFactory();

      taskService.findByTaskIdAndWorkspaceId.mockResolvedValue(task);
      taskAssignmentService.findAllByTaskId.mockResolvedValue([]); // Task not closed
      workspaceUserService.findByIdsAndWorkspaceIdWithUserAndCreatedByUser.mockResolvedValue(
        [existingUser],
      );

      const result = await service.addTaskAssignees({
        workspaceId: 'ws-1',
        taskId: 't-1',
        payload: { assigneeIds: ['u1'] },
      });

      expect(taskAssignmentService.createMultiple).toHaveBeenCalled();
      expect(result).toHaveLength(1);
    });
  });

  describe('removeTaskAssignee', () => {
    it('removes assignee', async () => {
      taskService.findByTaskIdAndWorkspaceId.mockResolvedValue(
        mockTaskCoreFactory(),
      );
      taskAssignmentService.findAllByTaskId.mockResolvedValue([]); // Not closed

      await service.removeTaskAssignee({
        workspaceId: 'ws-1',
        taskId: 't-1',
        payload: { assigneeId: 'u1' },
      });

      expect(
        taskAssignmentService.deleteByTaskIdAndAssigneeId,
      ).toHaveBeenCalled();
    });
  });

  describe('updateTaskAssignments', () => {
    it('updates assignment statuses', async () => {
      taskService.findByTaskIdAndWorkspaceId.mockResolvedValue(
        mockTaskCoreFactory(),
      );
      taskAssignmentService.findAllByTaskId.mockResolvedValue([]); // Not closed
      taskAssignmentService.updateAssignmentsByTaskId.mockResolvedValue([
        { assignee: { id: 'u1' }, status: ProgressStatus.COMPLETED } as any,
      ]);

      const result = await service.updateTaskAssignments({
        workspaceId: 'ws-1',
        taskId: 't-1',
        assignments: [],
      });

      expect(
        taskAssignmentService.updateAssignmentsByTaskId,
      ).toHaveBeenCalled();
      expect(result).toHaveLength(1);
    });

    it('throws if completing task past due date', async () => {
      const pastDate = DateTime.now().minus({ days: 1 }).toJSDate();
      taskService.findByTaskIdAndWorkspaceId.mockResolvedValue(
        mockTaskCoreFactory({ dueDate: pastDate }),
      );
      taskAssignmentService.findAllByTaskId.mockResolvedValue([]);

      await expect(
        service.updateTaskAssignments({
          workspaceId: 'ws-1',
          taskId: 't-1',
          assignments: [{ assigneeId: 'u1', status: ProgressStatus.COMPLETED }],
        }),
      ).rejects.toMatchObject({
        response: {
          code: ApiErrorCode.TASK_ASSIGNMENTS_COMPLETED_STATUS_DUE_DATE_PASSED,
        },
      });
    });
  });

  describe('getWorkspaceGoals', () => {
    it('returns goals with accumulated points', async () => {
      const goal = mockGoalCoreFactory();
      workspaceRepository.findById.mockResolvedValue(mockWorkspaceFactory());
      goalService.findPaginatedByWorkspaceWithAssignee.mockResolvedValue({
        data: [goal],
        total: 1,
        totalPages: 1,
      });
      taskAssignmentService.getAccumulatedPointsForWorkspaceUser.mockResolvedValue(
        100,
      );

      const result = await service.getWorkspaceGoals({
        workspaceId: 'ws-1',
        query: {},
      });
      expect(result.items[0].accumulatedPoints).toBe(100);
    });
  });

  describe('updateGoal', () => {
    it('updates goal and returns with points', async () => {
      const updatedGoal = mockGoalCoreFactory();
      workspaceRepository.findById.mockResolvedValue(mockWorkspaceFactory());
      goalService.updateByGoalIdAndWorkspaceId.mockResolvedValue(updatedGoal);
      taskAssignmentService.getAccumulatedPointsForWorkspaceUser.mockResolvedValue(
        100,
      );

      const result = await service.updateGoal({
        workspaceId: 'ws-1',
        goalId: 'g-1',
        payload: { title: 'Up' },
      });

      expect(result.title).toBe(updatedGoal.title);
      expect(result.accumulatedPoints).toBe(100);
    });

    it('validates assignee existence if provided', async () => {
      workspaceRepository.findById.mockResolvedValue(mockWorkspaceFactory());
      workspaceUserService.findByIdAndWorkspaceId.mockResolvedValue(null);

      await expect(
        service.updateGoal({
          workspaceId: 'ws-1',
          goalId: 'g-1',
          payload: { assigneeId: 'invalid' },
        }),
      ).rejects.toMatchObject({ status: HttpStatus.NOT_FOUND });
    });
  });

  describe('closeGoal', () => {
    it('closes goal', async () => {
      await service.closeGoal({ workspaceId: 'ws-1', goalId: 'g-1' });
      expect(goalService.closeByGoalIdAndWorkspaceId).toHaveBeenCalledWith({
        goalId: 'g-1',
        workspaceId: 'ws-1',
      });
    });
  });
});
