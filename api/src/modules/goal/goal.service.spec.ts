import { HttpStatus } from '@nestjs/common';
import { Test, TestingModule } from '@nestjs/testing';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';
import { ProgressStatus } from 'src/modules/task/task-module/domain/progress-status.enum';
import { UserEntity } from 'src/modules/user/persistence/user.entity';
import { CreateGoalRequest } from 'src/modules/workspace/workspace-module/dto/request/create-goal-request.dto';
import {
  SortBy,
  WORKSPACE_OBJECTIVE_DEFAULT_QUERY_LIMIT,
  WorkspaceObjectiveRequestQuery,
} from 'src/modules/workspace/workspace-module/dto/request/workspace-objective-request-query.dto';
import { WorkspaceUserRole } from 'src/modules/workspace/workspace-user-module/domain/workspace-user-role.enum';
import { GoalService } from './goal.service';
import { GoalEntity } from './persistence/goal.entity';
import { GoalRepository } from './persistence/goal.repository';

const mockUserEntityFactory = (overrides?: Partial<UserEntity>): UserEntity =>
  ({
    id: 'user-1',
    firstName: 'John',
    lastName: 'Doe',
    profileImageUrl: 'https://example.com/image.jpg',
    ...overrides,
  }) as UserEntity;

const mockWorkspaceUserEntityFactory = (overrides?: any) => ({
  id: 'workspace-user-1',
  workspaceRole: WorkspaceUserRole.MEMBER,
  user: mockUserEntityFactory(),
  ...overrides,
});

const mockGoalEntityFactory = (overrides?: Partial<GoalEntity>): GoalEntity => {
  const base = {
    id: 'goal-1',
    title: 'Test Goal',
    description: 'Test goal description',
    requiredPoints: 100,
    status: ProgressStatus.IN_PROGRESS,
    createdAt: new Date(),
    updatedAt: new Date(),
    deletedAt: null,
    workspaceId: 'workspace-1',
    assignee: mockWorkspaceUserEntityFactory({
      id: 'assignee-ws-user',
      user: mockUserEntityFactory({ firstName: 'Assignee' }),
    }),
    createdBy: mockWorkspaceUserEntityFactory({
      id: 'creator-ws-user',
      user: mockUserEntityFactory({ firstName: 'Creator' }),
    }),
    ...overrides,
  };

  return base as unknown as GoalEntity;
};

const createMockRepository = () => ({
  findAllByWorkspaceId: jest.fn(),
  create: jest.fn(),
  findById: jest.fn(),
  findByGoalIdAndWorkspaceId: jest.fn(),
  update: jest.fn(),
});

describe('GoalService', () => {
  let service: GoalService;
  let goalRepository: ReturnType<typeof createMockRepository>;

  beforeEach(async () => {
    jest.clearAllMocks();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        GoalService,
        {
          provide: GoalRepository,
          useValue: createMockRepository(),
        },
      ],
    }).compile();

    service = module.get<GoalService>(GoalService);
    goalRepository = module.get(GoalRepository);
  });

  describe('findPaginatedByWorkspaceWithAssignee', () => {
    it('returns paginated goals with mapped assignee and creator', async () => {
      const entity = mockGoalEntityFactory();
      goalRepository.findAllByWorkspaceId.mockResolvedValue({
        data: [entity],
        totalPages: 1,
        total: 1,
      });

      const result = await service.findPaginatedByWorkspaceWithAssignee({
        workspaceId: 'workspace-1',
        query: {},
      });

      expect(goalRepository.findAllByWorkspaceId).toHaveBeenCalledWith({
        workspaceId: 'workspace-1',
        query: {
          page: 1,
          limit: WORKSPACE_OBJECTIVE_DEFAULT_QUERY_LIMIT,
          status: null,
          sort: SortBy.NEWEST,
        },
        relations: {
          assignee: { user: true },
          createdBy: { user: true },
        },
      });

      expect(result.data).toHaveLength(1);
      expect(result.data[0].id).toBe(entity.id);
      expect(result.data[0].assignee.firstName).toBe('Assignee');
      expect(result.data[0].createdBy?.firstName).toBe('Creator');
    });

    it('passes custom query parameters correctly', async () => {
      goalRepository.findAllByWorkspaceId.mockResolvedValue({
        data: [],
        totalPages: 0,
        total: 0,
      });

      const query: WorkspaceObjectiveRequestQuery = {
        page: 2,
        limit: 10,
        status: ProgressStatus.COMPLETED,
        sort: SortBy.OLDEST,
      };

      await service.findPaginatedByWorkspaceWithAssignee({
        workspaceId: 'workspace-1',
        query,
      });

      expect(goalRepository.findAllByWorkspaceId).toHaveBeenCalledWith({
        workspaceId: 'workspace-1',
        query: {
          page: 2,
          limit: 10,
          status: ProgressStatus.COMPLETED,
          sort: SortBy.OLDEST,
        },
        relations: expect.any(Object),
      });
    });

    it('handles null createdBy', async () => {
      const entity = mockGoalEntityFactory({ createdBy: null });
      goalRepository.findAllByWorkspaceId.mockResolvedValue({
        data: [entity],
        totalPages: 1,
        total: 1,
      });

      const result = await service.findPaginatedByWorkspaceWithAssignee({
        workspaceId: 'workspace-1',
        query: {},
      });

      expect(result.data[0].createdBy).toBeNull();
    });
  });

  describe('create', () => {
    it('creates a new goal and maps response', async () => {
      const mockEntity = mockGoalEntityFactory();
      goalRepository.create.mockResolvedValue(mockEntity);

      const data: CreateGoalRequest = {
        title: 'New Goal',
        description: 'Desc',
        requiredPoints: 200,
        assignee: 'assignee-1',
      };

      const result = await service.create({
        workspaceId: 'workspace-1',
        createdById: 'creator-1',
        data,
      });

      expect(goalRepository.create).toHaveBeenCalledWith({
        workspaceId: 'workspace-1',
        createdById: 'creator-1',
        data: {
          title: data.title,
          description: data.description,
          requiredPoints: data.requiredPoints,
          assigneeId: data.assignee,
        },
        relations: {
          assignee: { user: true },
          createdBy: { user: true },
        },
      });

      expect(result.title).toBe(mockEntity.title);
      expect(result.assignee.firstName).toBe('Assignee');
    });

    it('creates goal with null description', async () => {
      const mockEntity = mockGoalEntityFactory({ description: null });
      goalRepository.create.mockResolvedValue(mockEntity);

      const data: CreateGoalRequest = {
        title: 'Goal',
        requiredPoints: 100,
        assignee: 'assignee-1',
      };

      const result = await service.create({
        workspaceId: 'workspace-1',
        createdById: 'creator-1',
        data,
      });

      expect(goalRepository.create).toHaveBeenCalledWith(
        expect.objectContaining({
          data: expect.objectContaining({ description: null }),
        }),
      );
      expect(result.description).toBeNull();
    });

    it('throws SERVER_ERROR if creation returns null', async () => {
      goalRepository.create.mockResolvedValue(null);

      const data: CreateGoalRequest = {
        title: 'Goal',
        requiredPoints: 100,
        assignee: 'assignee-1',
      };

      await expect(
        service.create({
          workspaceId: 'workspace-1',
          createdById: 'creator-1',
          data,
        }),
      ).rejects.toMatchObject({
        status: HttpStatus.INTERNAL_SERVER_ERROR,
        response: { code: ApiErrorCode.SERVER_ERROR },
      });
    });
  });

  describe('findByGoalIdAndWorkspaceId', () => {
    it('returns goal if found', async () => {
      const mockEntity = mockGoalEntityFactory();
      goalRepository.findByGoalIdAndWorkspaceId.mockResolvedValue(mockEntity);

      const result = await service.findByGoalIdAndWorkspaceId({
        goalId: 'goal-1',
        workspaceId: 'workspace-1',
      });

      expect(result).toEqual(mockEntity);
    });

    it('returns null if not found', async () => {
      goalRepository.findByGoalIdAndWorkspaceId.mockResolvedValue(null);

      const result = await service.findByGoalIdAndWorkspaceId({
        goalId: 'goal-1',
        workspaceId: 'workspace-1',
      });

      expect(result).toBeNull();
    });
  });

  describe('updateByGoalIdAndWorkspaceId', () => {
    it('updates goal with new data', async () => {
      const existingGoal = mockGoalEntityFactory();
      const updatedGoal = mockGoalEntityFactory({
        title: 'Updated',
        requiredPoints: 500,
      });

      goalRepository.findByGoalIdAndWorkspaceId.mockResolvedValue(existingGoal);
      goalRepository.update.mockResolvedValue(updatedGoal);

      const data = {
        title: 'Updated',
        requiredPoints: 500,
        assigneeId: 'new-assignee',
      };

      const result = await service.updateByGoalIdAndWorkspaceId({
        goalId: 'goal-1',
        workspaceId: 'ws-1',
        data,
      });

      expect(goalRepository.update).toHaveBeenCalledWith({
        id: 'goal-1',
        data: {
          title: data.title,
          description: undefined,
          requiredPoints: data.requiredPoints,
          assigneeId: data.assigneeId,
        },
        relations: expect.any(Object),
      });

      expect(result.title).toBe('Updated');
    });

    it('throws NOT_FOUND if goal does not exist', async () => {
      goalRepository.findByGoalIdAndWorkspaceId.mockResolvedValue(null);

      await expect(
        service.updateByGoalIdAndWorkspaceId({
          goalId: 'goal-1',
          workspaceId: 'ws-1',
          data: { title: 'New' } as any,
        }),
      ).rejects.toMatchObject({
        status: HttpStatus.NOT_FOUND,
        response: { code: ApiErrorCode.INVALID_PAYLOAD },
      });
    });

    it('throws GOAL_CLOSED if goal is closed', async () => {
      const closedGoal = mockGoalEntityFactory({
        status: ProgressStatus.CLOSED,
      });
      goalRepository.findByGoalIdAndWorkspaceId.mockResolvedValue(closedGoal);

      await expect(
        service.updateByGoalIdAndWorkspaceId({
          goalId: 'goal-1',
          workspaceId: 'ws-1',
          data: { title: 'New' } as any,
        }),
      ).rejects.toMatchObject({
        status: HttpStatus.UNPROCESSABLE_ENTITY,
        response: { code: ApiErrorCode.GOAL_CLOSED },
      });
    });

    it('throws NOT_FOUND if update returns null', async () => {
      goalRepository.findByGoalIdAndWorkspaceId.mockResolvedValue(
        mockGoalEntityFactory(),
      );
      goalRepository.update.mockResolvedValue(null);

      await expect(
        service.updateByGoalIdAndWorkspaceId({
          goalId: 'goal-1',
          workspaceId: 'ws-1',
          data: { title: 'New' } as any,
        }),
      ).rejects.toMatchObject({
        status: HttpStatus.NOT_FOUND,
        response: { code: ApiErrorCode.INVALID_PAYLOAD },
      });
    });
  });

  describe('closeByGoalIdAndWorkspaceId', () => {
    it('closes goal successfully', async () => {
      const openGoal = mockGoalEntityFactory({
        status: ProgressStatus.IN_PROGRESS,
      });
      const closedGoal = mockGoalEntityFactory({
        status: ProgressStatus.CLOSED,
      });

      goalRepository.findByGoalIdAndWorkspaceId.mockResolvedValue(openGoal);
      goalRepository.update.mockResolvedValue(closedGoal);

      await service.closeByGoalIdAndWorkspaceId({
        goalId: 'goal-1',
        workspaceId: 'ws-1',
      });

      expect(goalRepository.update).toHaveBeenCalledWith({
        id: 'goal-1',
        data: { status: ProgressStatus.CLOSED },
      });
    });

    it('is idempotent (returns early if already closed)', async () => {
      const closedGoal = mockGoalEntityFactory({
        status: ProgressStatus.CLOSED,
      });
      goalRepository.findByGoalIdAndWorkspaceId.mockResolvedValue(closedGoal);

      await service.closeByGoalIdAndWorkspaceId({
        goalId: 'goal-1',
        workspaceId: 'ws-1',
      });

      expect(goalRepository.update).not.toHaveBeenCalled();
    });

    it('throws NOT_FOUND if goal does not exist', async () => {
      goalRepository.findByGoalIdAndWorkspaceId.mockResolvedValue(null);

      await expect(
        service.closeByGoalIdAndWorkspaceId({
          goalId: 'goal-1',
          workspaceId: 'ws-1',
        }),
      ).rejects.toMatchObject({
        status: HttpStatus.NOT_FOUND,
        response: { code: ApiErrorCode.INVALID_PAYLOAD },
      });
    });

    it('throws NOT_FOUND if update returns null', async () => {
      goalRepository.findByGoalIdAndWorkspaceId.mockResolvedValue(
        mockGoalEntityFactory(),
      );
      goalRepository.update.mockResolvedValue(null);

      await expect(
        service.closeByGoalIdAndWorkspaceId({
          goalId: 'goal-1',
          workspaceId: 'ws-1',
        }),
      ).rejects.toMatchObject({
        status: HttpStatus.NOT_FOUND,
        response: { code: ApiErrorCode.INVALID_PAYLOAD },
      });
    });
  });
});
