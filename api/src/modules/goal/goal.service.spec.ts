import { HttpStatus } from '@nestjs/common';
import { Test, TestingModule } from '@nestjs/testing';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';
import { ApiHttpException } from 'src/exception/api-http-exception.type';
import { ProgressStatus } from 'src/modules/task/task-module/domain/progress-status.enum';
import { CreateGoalRequest } from 'src/modules/workspace/workspace-module/dto/request/create-goal-request.dto';
import {
  SortBy,
  WORKSPACE_OBJECTIVE_DEFAULT_QUERY_LIMIT,
  WorkspaceObjectiveRequestQuery,
} from 'src/modules/workspace/workspace-module/dto/request/workspace-objective-request-query.dto';
import { GoalCore } from './domain/goal-core.domain';
import { GoalWithAssigneeUserCore } from './domain/goal-with-assignee-user-core.domain';
import { GoalService } from './goal.service';
import { GoalEntity } from './persistence/goal.entity';
import { GoalRepository } from './persistence/goal.repository';

describe('GoalService', () => {
  let service: GoalService;
  let goalRepository: jest.Mocked<GoalRepository>;

  const mockAssignee: GoalWithAssigneeUserCore['assignee'] = {
    id: 'assignee-1',
    firstName: 'Jane',
    lastName: 'Doe',
    profileImageUrl: null,
  };

  const mockCreatedBy: GoalWithAssigneeUserCore['createdBy'] = {
    id: 'created-by-1',
    firstName: 'John',
    lastName: 'Smith',
    profileImageUrl: 'https://example.com/image.jpg',
  };

  const mockGoalCore: GoalCore = {
    id: 'goal-1',
    title: 'Test Goal',
    description: 'Test goal description',
    requiredPoints: 100,
    status: ProgressStatus.IN_PROGRESS,
    createdAt: new Date('2024-01-01'),
    updatedAt: new Date('2024-01-01'),
    deletedAt: null,
  };

  const mockGoalWithAssigneeUserCore: GoalWithAssigneeUserCore = {
    ...mockGoalCore,
    assignee: mockAssignee,
    createdBy: mockCreatedBy,
  };

  const mockGoalEntity: GoalEntity = {
    id: 'goal-1',
    title: 'Test Goal',
    description: 'Test goal description',
    requiredPoints: 100,
    status: ProgressStatus.IN_PROGRESS,
    createdAt: new Date('2024-01-01'),
    updatedAt: new Date('2024-01-01'),
    deletedAt: null,
    assignee: {
      id: 'assignee-1',
      user: {
        firstName: 'Jane',
        lastName: 'Doe',
        profileImageUrl: null,
      },
    },
    createdBy: {
      id: 'created-by-1',
      user: {
        firstName: 'John',
        lastName: 'Smith',
        profileImageUrl: 'https://example.com/image.jpg',
      },
    },
  } as GoalEntity;

  beforeEach(async () => {
    jest.clearAllMocks();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        GoalService,
        {
          provide: GoalRepository,
          useValue: {
            findAllByWorkspaceId: jest.fn(),
            create: jest.fn(),
            findById: jest.fn(),
            findByGoalIdAndWorkspaceId: jest.fn(),
            update: jest.fn(),
          },
        },
      ],
    }).compile();

    service = module.get<GoalService>(GoalService);
    goalRepository = module.get(GoalRepository) as jest.Mocked<GoalRepository>;
  });

  describe('findPaginatedByWorkspaceWithAssignee', () => {
    it('returns paginated goals with assignee and default query parameters', async () => {
      goalRepository.findAllByWorkspaceId.mockResolvedValue({
        data: [mockGoalEntity],
        totalPages: 1,
        total: 1,
      });

      const workspaceId = 'workspace-1';
      const query: WorkspaceObjectiveRequestQuery = {};
      const result = await service.findPaginatedByWorkspaceWithAssignee({
        workspaceId,
        query,
      });

      expect(goalRepository.findAllByWorkspaceId).toHaveBeenCalledWith({
        workspaceId,
        query: {
          page: 1,
          limit: WORKSPACE_OBJECTIVE_DEFAULT_QUERY_LIMIT,
          status: null,
          search: null,
          sort: SortBy.NEWEST,
        },
        relations: {
          assignee: {
            user: true,
          },
          createdBy: {
            user: true,
          },
        },
      });
      expect(result.data).toEqual([mockGoalWithAssigneeUserCore]);
      expect(result.totalPages).toBe(1);
      expect(result.total).toBe(1);
    });

    it('returns paginated goals with custom query parameters', async () => {
      goalRepository.findAllByWorkspaceId.mockResolvedValue({
        data: [mockGoalEntity],
        totalPages: 2,
        total: 20,
      });

      const workspaceId = 'workspace-1';
      const query: WorkspaceObjectiveRequestQuery = {
        page: 2,
        limit: 10,
        status: ProgressStatus.COMPLETED,
        search: 'test',
        sort: SortBy.OLDEST,
      };
      const result = await service.findPaginatedByWorkspaceWithAssignee({
        workspaceId,
        query,
      });

      expect(goalRepository.findAllByWorkspaceId).toHaveBeenCalledWith({
        workspaceId,
        query: {
          page: 2,
          limit: 10,
          status: ProgressStatus.COMPLETED,
          search: 'test',
          sort: SortBy.OLDEST,
        },
        relations: {
          assignee: {
            user: true,
          },
          createdBy: {
            user: true,
          },
        },
      });
      expect(result.totalPages).toBe(2);
      expect(result.total).toBe(20);
    });

    it('trims search query and handles null values', async () => {
      goalRepository.findAllByWorkspaceId.mockResolvedValue({
        data: [],
        totalPages: 1,
        total: 0,
      });

      const workspaceId = 'workspace-1';
      const query: WorkspaceObjectiveRequestQuery = {
        search: '  spaces  ',
      };
      await service.findPaginatedByWorkspaceWithAssignee({
        workspaceId,
        query,
      });

      expect(goalRepository.findAllByWorkspaceId).toHaveBeenCalledWith(
        expect.objectContaining({
          query: expect.objectContaining({
            search: 'spaces',
          }),
        }),
      );
    });
  });

  describe('create', () => {
    it('creates a new goal with required data', async () => {
      goalRepository.create.mockResolvedValue(mockGoalEntity);

      const workspaceId = 'workspace-1';
      const createdById = 'created-by-1';
      const data: CreateGoalRequest = {
        title: 'Test Goal',
        description: 'Test goal description',
        requiredPoints: 100,
        assignee: 'assignee-1',
      };

      const result = await service.create({
        workspaceId,
        createdById,
        data,
      });

      expect(goalRepository.create).toHaveBeenCalledWith({
        workspaceId,
        data: {
          title: data.title,
          description: data.description || null,
          requiredPoints: data.requiredPoints,
          assigneeId: data.assignee,
        },
        createdById,
        relations: {
          assignee: {
            user: true,
          },
          createdBy: {
            user: true,
          },
        },
      });
      expect(result).toEqual(mockGoalWithAssigneeUserCore);
    });

    it('creates a goal without description', async () => {
      const goalEntityWithoutDescription = {
        ...mockGoalEntity,
        description: null,
      } as GoalEntity;
      goalRepository.create.mockResolvedValue(goalEntityWithoutDescription);

      const workspaceId = 'workspace-1';
      const createdById = 'created-by-1';
      const data: CreateGoalRequest = {
        title: 'Test Goal',
        requiredPoints: 100,
        assignee: 'assignee-1',
      };

      const result = await service.create({
        workspaceId,
        createdById,
        data,
      });

      expect(goalRepository.create).toHaveBeenCalledWith(
        expect.objectContaining({
          data: expect.objectContaining({
            description: null,
          }),
        }),
      );
      expect(result.description).toBeNull();
    });

    it('throws ApiHttpException SERVER_ERROR if goal creation fails', async () => {
      goalRepository.create.mockResolvedValue(null);

      const workspaceId = 'workspace-1';
      const createdById = 'created-by-1';
      const data: CreateGoalRequest = {
        title: 'Test Goal',
        requiredPoints: 100,
        assignee: 'assignee-1',
      };

      try {
        await service.create({
          workspaceId,
          createdById,
          data,
        });
      } catch (error) {
        expect(error).toBeInstanceOf(ApiHttpException);
        expect((error as ApiHttpException).getStatus()).toBe(
          HttpStatus.INTERNAL_SERVER_ERROR,
        );
        expect((error as ApiHttpException).getResponse()).toEqual({
          code: ApiErrorCode.SERVER_ERROR,
        });
      }
    });
  });

  describe('findByGoalIdAndWorkspaceId', () => {
    it('returns a goal by ID and workspace ID', async () => {
      goalRepository.findByGoalIdAndWorkspaceId.mockResolvedValue(
        mockGoalEntity,
      );

      const goalId = 'goal-1';
      const workspaceId = 'workspace-1';
      const result = await service.findByGoalIdAndWorkspaceId({
        goalId,
        workspaceId,
      });

      expect(goalRepository.findByGoalIdAndWorkspaceId).toHaveBeenCalledWith({
        goalId,
        workspaceId,
      });
      expect(result).toEqual(mockGoalEntity);
    });

    it('returns null if goal is not found', async () => {
      goalRepository.findByGoalIdAndWorkspaceId.mockResolvedValue(null);

      const goalId = 'non-existent-goal';
      const workspaceId = 'workspace-1';
      const result = await service.findByGoalIdAndWorkspaceId({
        goalId,
        workspaceId,
      });

      expect(result).toBeNull();
    });
  });

  describe('updateByGoalIdAndWorkspaceId', () => {
    it('updates a goal with new data', async () => {
      goalRepository.findByGoalIdAndWorkspaceId.mockResolvedValue(
        mockGoalEntity,
      );
      goalRepository.update.mockResolvedValue(mockGoalEntity);

      const goalId = 'goal-1';
      const workspaceId = 'workspace-1';
      const data = {
        title: 'Updated Goal',
        requiredPoints: 150,
        assigneeId: 'new-assignee',
      };

      const result = await service.updateByGoalIdAndWorkspaceId({
        goalId,
        workspaceId,
        data,
      });

      expect(goalRepository.update).toHaveBeenCalledWith({
        id: goalId,
        data: {
          title: data.title,
          requiredPoints: data.requiredPoints,
          assigneeId: data.assigneeId,
          description: undefined,
        },
        relations: {
          assignee: {
            user: true,
          },
          createdBy: {
            user: true,
          },
        },
      });
      expect(result).toEqual(mockGoalWithAssigneeUserCore);
    });

    it('throws ApiHttpException INVALID_PAYLOAD if goal not found', async () => {
      goalRepository.findByGoalIdAndWorkspaceId.mockResolvedValue(null);

      const goalId = 'non-existent-goal';
      const workspaceId = 'workspace-1';
      const data = {
        title: 'Updated Goal',
      };

      try {
        await service.updateByGoalIdAndWorkspaceId({
          goalId,
          workspaceId,
          data,
        });
      } catch (error) {
        expect(error).toBeInstanceOf(ApiHttpException);
        expect((error as ApiHttpException).getStatus()).toBe(
          HttpStatus.NOT_FOUND,
        );
        expect((error as ApiHttpException).getResponse()).toEqual({
          code: ApiErrorCode.INVALID_PAYLOAD,
        });
      }
    });

    it('throws ApiHttpException GOAL_CLOSED if goal is closed', async () => {
      const closedGoal = {
        ...mockGoalCore,
        status: ProgressStatus.CLOSED,
      } as GoalEntity;
      goalRepository.findByGoalIdAndWorkspaceId.mockResolvedValue(closedGoal);

      const goalId = 'goal-1';
      const workspaceId = 'workspace-1';
      const data = {
        title: 'Updated Goal',
      };

      try {
        await service.updateByGoalIdAndWorkspaceId({
          goalId,
          workspaceId,
          data,
        });
      } catch (error) {
        expect(error).toBeInstanceOf(ApiHttpException);
        expect((error as ApiHttpException).getStatus()).toBe(
          HttpStatus.UNPROCESSABLE_ENTITY,
        );
        expect((error as ApiHttpException).getResponse()).toEqual({
          code: ApiErrorCode.GOAL_CLOSED,
        });
      }
    });

    it('throws ApiHttpException INVALID_PAYLOAD if goal is deleted during update', async () => {
      goalRepository.findByGoalIdAndWorkspaceId.mockResolvedValue(
        mockGoalEntity,
      );
      goalRepository.update.mockResolvedValue(null);

      const goalId = 'goal-1';
      const workspaceId = 'workspace-1';
      const data = {
        title: 'Updated Goal',
      };

      try {
        await service.updateByGoalIdAndWorkspaceId({
          goalId,
          workspaceId,
          data,
        });
      } catch (error) {
        expect(error).toBeInstanceOf(ApiHttpException);
        expect((error as ApiHttpException).getStatus()).toBe(
          HttpStatus.NOT_FOUND,
        );
        expect((error as ApiHttpException).getResponse()).toEqual({
          code: ApiErrorCode.INVALID_PAYLOAD,
        });
      }
    });
  });

  describe('closeByGoalIdAndWorkspaceId', () => {
    it('closes a goal', async () => {
      goalRepository.findByGoalIdAndWorkspaceId.mockResolvedValue(
        mockGoalEntity,
      );
      goalRepository.update.mockResolvedValue({
        ...mockGoalEntity,
        status: ProgressStatus.CLOSED,
      } as GoalEntity);

      const goalId = 'goal-1';
      const workspaceId = 'workspace-1';

      await service.closeByGoalIdAndWorkspaceId({
        goalId,
        workspaceId,
      });

      expect(goalRepository.update).toHaveBeenCalledWith({
        id: goalId,
        data: {
          status: ProgressStatus.CLOSED,
        },
      });
    });

    it('returns early if goal is already closed (idempotency)', async () => {
      const closedGoal = {
        ...mockGoalCore,
        status: ProgressStatus.CLOSED,
      } as GoalEntity;
      goalRepository.findByGoalIdAndWorkspaceId.mockResolvedValue(closedGoal);

      const goalId = 'goal-1';
      const workspaceId = 'workspace-1';

      await service.closeByGoalIdAndWorkspaceId({
        goalId,
        workspaceId,
      });

      // Update should not be called if goal is already closed
      expect(goalRepository.update).not.toHaveBeenCalled();
    });

    it('throws ApiHttpException INVALID_PAYLOAD if goal not found', async () => {
      goalRepository.findByGoalIdAndWorkspaceId.mockResolvedValue(null);

      const goalId = 'non-existent-goal';
      const workspaceId = 'workspace-1';

      try {
        await service.closeByGoalIdAndWorkspaceId({
          goalId,
          workspaceId,
        });
      } catch (error) {
        expect(error).toBeInstanceOf(ApiHttpException);
        expect((error as ApiHttpException).getStatus()).toBe(
          HttpStatus.NOT_FOUND,
        );
        expect((error as ApiHttpException).getResponse()).toEqual({
          code: ApiErrorCode.INVALID_PAYLOAD,
        });
      }
    });

    it('throws ApiHttpException INVALID_PAYLOAD if goal is deleted during close', async () => {
      goalRepository.findByGoalIdAndWorkspaceId.mockResolvedValue(
        mockGoalEntity,
      );
      goalRepository.update.mockResolvedValue(null);

      const goalId = 'goal-1';
      const workspaceId = 'workspace-1';

      try {
        await service.closeByGoalIdAndWorkspaceId({
          goalId,
          workspaceId,
        });
      } catch (error) {
        expect(error).toBeInstanceOf(ApiHttpException);
        expect((error as ApiHttpException).getStatus()).toBe(
          HttpStatus.NOT_FOUND,
        );
        expect((error as ApiHttpException).getResponse()).toEqual({
          code: ApiErrorCode.INVALID_PAYLOAD,
        });
      }
    });
  });
});
