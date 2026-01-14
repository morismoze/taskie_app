import { HttpStatus } from '@nestjs/common';
import { Test, TestingModule } from '@nestjs/testing';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';
import { ApiHttpException } from 'src/exception/api-http-exception.type';
import { UserEntity } from 'src/modules/user/persistence/user.entity';
import { CreateTaskRequest } from 'src/modules/workspace/workspace-module/dto/request/create-task-request.dto';
import { UpdateTaskRequest } from 'src/modules/workspace/workspace-module/dto/request/update-task-request.dto';
import {
  SortBy,
  WORKSPACE_OBJECTIVE_DEFAULT_QUERY_LIMIT,
  WorkspaceObjectiveRequestQuery,
} from 'src/modules/workspace/workspace-module/dto/request/workspace-objective-request-query.dto';
import { TaskAssignmentEntity } from '../task-assignment/persistence/task-assignment.entity';
import { ProgressStatus } from './domain/progress-status.enum';
import { TaskCore } from './domain/task-core.domain';
import { TaskWithAssigneesCoreAndCreatedByUser } from './domain/task-with-assignees-core.domain';
import { TaskEntity } from './persistence/task.entity';
import { TaskRepository } from './persistence/task.repository';
import { TaskService } from './task.service';

describe('TaskService', () => {
  let service: TaskService;
  let taskRepository: jest.Mocked<TaskRepository>;

  const mockCreatedByUser: TaskWithAssigneesCoreAndCreatedByUser['createdBy'] =
    {
      id: 'created-by-1',
      firstName: 'John',
      lastName: 'Doe',
      profileImageUrl: null,
    };

  const mockAssigneeUser = {
    firstName: 'Jane',
    lastName: 'Smith',
    profileImageUrl: 'https://example.com/image.jpg',
  } as UserEntity;

  const mockTaskAssignment: TaskAssignmentEntity = {
    id: 'assignment-1',
    status: ProgressStatus.IN_PROGRESS,
    assignee: {
      id: 'assignee-1',
      user: mockAssigneeUser,
    },
  } as TaskAssignmentEntity;

  const mockTaskCore: TaskCore = {
    id: 'task-1',
    title: 'Test Task',
    rewardPoints: 25,
    description: 'Test task description',
    dueDate: new Date('2024-12-31'),
    createdAt: new Date('2024-01-01'),
    updatedAt: new Date('2024-01-01'),
    deletedAt: null,
  };

  const mockTaskWithAssigneesCoreAndCreatedByUser: TaskWithAssigneesCoreAndCreatedByUser =
    {
      ...mockTaskCore,
      assignees: [
        {
          id: 'assignee-1',
          firstName: mockAssigneeUser.firstName,
          lastName: mockAssigneeUser.lastName,
          profileImageUrl: mockAssigneeUser.profileImageUrl,
          status: ProgressStatus.IN_PROGRESS,
        },
      ],
      createdBy: mockCreatedByUser,
    };

  const mockTaskEntity: TaskEntity = {
    id: 'task-1',
    title: 'Test Task',
    rewardPoints: 25,
    description: 'Test task description',
    dueDate: new Date('2024-12-31'),
    createdAt: new Date('2024-01-01'),
    updatedAt: new Date('2024-01-01'),
    deletedAt: null,
    createdBy: {
      id: 'created-by-1',
      user: {
        firstName: 'John',
        lastName: 'Doe',
        profileImageUrl: null,
      },
    },
    taskAssignments: [mockTaskAssignment],
  } as TaskEntity;

  beforeEach(async () => {
    jest.clearAllMocks();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        TaskService,
        {
          provide: TaskRepository,
          useValue: {
            findAllByWorkspaceId: jest.fn(),
            create: jest.fn(),
            findById: jest.fn(),
            findByTaskIdAndWorkspaceId: jest.fn(),
            update: jest.fn(),
          },
        },
      ],
    }).compile();

    service = module.get<TaskService>(TaskService);
    taskRepository = module.get(TaskRepository) as jest.Mocked<TaskRepository>;
  });

  describe('findPaginatedByWorkspaceWithAssignees', () => {
    it('returns paginated tasks with assignees and default query parameters', async () => {
      taskRepository.findAllByWorkspaceId.mockResolvedValue({
        data: [mockTaskEntity],
        totalPages: 1,
        total: 1,
      });

      const workspaceId = 'workspace-1';
      const query: WorkspaceObjectiveRequestQuery = {};
      const result = await service.findPaginatedByWorkspaceWithAssignees({
        workspaceId,
        query,
      });

      expect(taskRepository.findAllByWorkspaceId).toHaveBeenCalledWith({
        workspaceId,
        query: {
          page: 1,
          limit: WORKSPACE_OBJECTIVE_DEFAULT_QUERY_LIMIT,
          status: null,
          search: null,
          sort: SortBy.NEWEST,
        },
      });
      expect(result.data).toHaveLength(1);
      expect(result.data[0]).toEqual(
        expect.objectContaining({
          id: 'task-1',
          title: 'Test Task',
          rewardPoints: 25,
        }),
      );
      expect(result.totalPages).toBe(1);
      expect(result.total).toBe(1);
    });

    it('returns paginated tasks with custom query parameters', async () => {
      taskRepository.findAllByWorkspaceId.mockResolvedValue({
        data: [mockTaskEntity],
        totalPages: 2,
        total: 20,
      });

      const workspaceId = 'workspace-1';
      const query: WorkspaceObjectiveRequestQuery = {
        page: 2,
        limit: 10,
        status: ProgressStatus.COMPLETED,
        search: 'task',
        sort: SortBy.OLDEST,
      };
      const result = await service.findPaginatedByWorkspaceWithAssignees({
        workspaceId,
        query,
      });

      expect(taskRepository.findAllByWorkspaceId).toHaveBeenCalledWith({
        workspaceId,
        query: {
          page: 2,
          limit: 10,
          status: ProgressStatus.COMPLETED,
          search: 'task',
          sort: SortBy.OLDEST,
        },
      });
      expect(result.data).toHaveLength(1);
      expect(result.data[0]).toEqual(
        expect.objectContaining({
          id: 'task-1',
          title: 'Test Task',
          rewardPoints: 25,
        }),
      );
      expect(result.totalPages).toBe(2);
      expect(result.total).toBe(20);
    });

    it('correctly maps task assignments to assignees format', async () => {
      taskRepository.findAllByWorkspaceId.mockResolvedValue({
        data: [mockTaskEntity],
        totalPages: 1,
        total: 1,
      });

      const result = await service.findPaginatedByWorkspaceWithAssignees({
        workspaceId: 'workspace-1',
        query: {},
      });

      expect(result.data[0].assignees).toEqual([
        {
          id: 'assignee-1',
          firstName: 'Jane',
          lastName: 'Smith',
          profileImageUrl: 'https://example.com/image.jpg',
          status: ProgressStatus.IN_PROGRESS,
        },
      ]);
    });

    it('handles null createdBy', async () => {
      const taskEntityWithoutCreatedBy = {
        ...mockTaskEntity,
        createdBy: null,
      };
      taskRepository.findAllByWorkspaceId.mockResolvedValue({
        data: [taskEntityWithoutCreatedBy as TaskEntity],
        totalPages: 1,
        total: 1,
      });

      const result = await service.findPaginatedByWorkspaceWithAssignees({
        workspaceId: 'workspace-1',
        query: {},
      });

      expect(result.data[0].createdBy).toBeNull();
    });

    it('trims search query and handles null values', async () => {
      taskRepository.findAllByWorkspaceId.mockResolvedValue({
        data: [],
        totalPages: 1,
        total: 0,
      });

      const query: WorkspaceObjectiveRequestQuery = {
        search: '  spaces  ',
      };
      await service.findPaginatedByWorkspaceWithAssignees({
        workspaceId: 'workspace-1',
        query,
      });

      expect(taskRepository.findAllByWorkspaceId).toHaveBeenCalledWith(
        expect.objectContaining({
          query: expect.objectContaining({
            search: 'spaces',
          }),
        }),
      );
    });
  });

  describe('create', () => {
    it('creates a new task with required data', async () => {
      taskRepository.create.mockResolvedValue(mockTaskEntity);

      const workspaceId = 'workspace-1';
      const createdById = 'created-by-1';
      const data: Omit<CreateTaskRequest, 'assignees'> = {
        title: 'Test Task',
        description: 'Test task description',
        rewardPoints: 25,
        dueDate: '2024-12-31T00:00:00Z',
      };

      const result = await service.create({
        workspaceId,
        createdById,
        data,
      });

      expect(taskRepository.create).toHaveBeenCalledWith({
        workspaceId,
        data: {
          title: data.title,
          description: data.description,
          rewardPoints: data.rewardPoints,
          dueDate: expect.any(Date),
        },
        createdById,
        relations: {
          createdBy: {
            user: true,
          },
        },
      });
      expect(result.assignees).toEqual([]);
    });

    it('creates a task without description and dueDate', async () => {
      const taskEntityWithoutDetails = {
        ...mockTaskEntity,
        description: null,
        dueDate: null,
      };
      taskRepository.create.mockResolvedValue(
        taskEntityWithoutDetails as TaskEntity,
      );

      const workspaceId = 'workspace-1';
      const createdById = 'created-by-1';
      const data: Omit<CreateTaskRequest, 'assignees'> = {
        title: 'Test Task',
        rewardPoints: 25,
      };

      const result = await service.create({
        workspaceId,
        createdById,
        data,
      });

      expect(taskRepository.create).toHaveBeenCalledWith(
        expect.objectContaining({
          data: expect.objectContaining({
            description: null,
            dueDate: null,
          }),
        }),
      );
      expect(result.description).toBeNull();
      expect(result.dueDate).toBeNull();
    });

    it('converts dueDate ISO string to Date', async () => {
      taskRepository.create.mockResolvedValue(mockTaskEntity);

      const data: Omit<CreateTaskRequest, 'assignees'> = {
        title: 'Test Task',
        rewardPoints: 25,
        dueDate: '2024-12-31T10:30:00Z',
      };

      await service.create({
        workspaceId: 'workspace-1',
        createdById: 'created-by-1',
        data,
      });

      const callArgs = taskRepository.create.mock.calls[0][0];
      expect(callArgs.data.dueDate).toEqual(expect.any(Date));
      expect(callArgs.data.dueDate?.toISOString()).toContain('2024-12-31');
    });

    it('throws SERVER_ERROR if task creation fails', async () => {
      taskRepository.create.mockResolvedValue(null);

      const data: Omit<CreateTaskRequest, 'assignees'> = {
        title: 'Test Task',
        rewardPoints: 25,
      };

      try {
        await service.create({
          workspaceId: 'workspace-1',
          createdById: 'created-by-1',
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

    it('handles null createdBy in response', async () => {
      const taskEntityWithoutCreatedBy = {
        ...mockTaskEntity,
        createdBy: null,
      };
      taskRepository.create.mockResolvedValue(
        taskEntityWithoutCreatedBy as TaskEntity,
      );

      const result = await service.create({
        workspaceId: 'workspace-1',
        createdById: 'created-by-1',
        data: {
          title: 'Test Task',
          rewardPoints: 25,
        },
      });

      expect(result.createdBy).toBeNull();
    });
  });

  describe('findById', () => {
    it('returns a task by ID', async () => {
      taskRepository.findById.mockResolvedValue(mockTaskCore as TaskEntity);

      const taskId = 'task-1';
      const result = await service.findById(taskId);

      expect(taskRepository.findById).toHaveBeenCalledWith({ id: taskId });
      expect(result).toEqual(mockTaskCore);
    });

    it('returns null if task is not found', async () => {
      taskRepository.findById.mockResolvedValue(null);

      const taskId = 'non-existent-task';
      const result = await service.findById(taskId);

      expect(taskRepository.findById).toHaveBeenCalledWith({ id: taskId });
      expect(result).toBeNull();
    });
  });

  describe('findByTaskIdAndWorkspaceId', () => {
    it('returns a task by ID and workspace ID', async () => {
      taskRepository.findByTaskIdAndWorkspaceId.mockResolvedValue(
        mockTaskCore as TaskEntity,
      );

      const taskId = 'task-1';
      const workspaceId = 'workspace-1';
      const result = await service.findByTaskIdAndWorkspaceId({
        taskId,
        workspaceId,
      });

      expect(taskRepository.findByTaskIdAndWorkspaceId).toHaveBeenCalledWith({
        taskId,
        workspaceId,
      });
      expect(result).toEqual(mockTaskCore);
    });

    it('returns null if task is not found', async () => {
      taskRepository.findByTaskIdAndWorkspaceId.mockResolvedValue(null);

      const taskId = 'non-existent-task';
      const workspaceId = 'workspace-1';
      const result = await service.findByTaskIdAndWorkspaceId({
        taskId,
        workspaceId,
      });

      expect(result).toBeNull();
    });
  });

  describe('updateByTaskIdAndWorkspaceId', () => {
    it('updates a task with new data', async () => {
      taskRepository.findByTaskIdAndWorkspaceId.mockResolvedValue(
        mockTaskCore as TaskEntity,
      );
      taskRepository.update.mockResolvedValue({
        ...mockTaskEntity,
        title: 'Updated Task',
        description: 'Updated description',
        rewardPoints: 30,
        dueDate: new Date('2025-01-15'),
      } as TaskEntity);

      const taskId = 'task-1';
      const workspaceId = 'workspace-1';
      const data: UpdateTaskRequest = {
        title: 'Updated Task',
        description: 'Updated description',
        rewardPoints: 30,
        dueDate: '2025-01-15T00:00:00Z',
      };

      const result = await service.updateByTaskIdAndWorkspaceId({
        taskId,
        workspaceId,
        data,
      });

      expect(taskRepository.update).toHaveBeenCalledWith({
        id: taskId,
        data: {
          title: data.title,
          description: data.description,
          rewardPoints: data.rewardPoints,
          dueDate: expect.any(Date),
        },
        relations: {
          taskAssignments: {
            assignee: {
              user: true,
            },
          },
          createdBy: {
            user: true,
          },
        },
      });
      expect(result.title).toBe('Updated Task');
      expect(result.description).toBe('Updated description');
      expect(result.rewardPoints).toBe(30);
      expect(result.dueDate).toEqual(new Date('2025-01-15'));
    });

    it('throws INVALID_PAYLOAD if task not found', async () => {
      taskRepository.findByTaskIdAndWorkspaceId.mockResolvedValue(null);

      const taskId = 'non-existent-task';
      const workspaceId = 'workspace-1';
      const data: UpdateTaskRequest = {
        title: 'Updated Task',
        rewardPoints: 30,
      };

      try {
        await service.updateByTaskIdAndWorkspaceId({
          taskId,
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

    it('throws INVALID_PAYLOAD if task is deleted during update', async () => {
      taskRepository.findByTaskIdAndWorkspaceId.mockResolvedValue(
        mockTaskCore as TaskEntity,
      );
      taskRepository.update.mockResolvedValue(null);

      const taskId = 'task-1';
      const workspaceId = 'workspace-1';
      const data: UpdateTaskRequest = {
        title: 'Updated Task',
        rewardPoints: 30,
      };

      try {
        await service.updateByTaskIdAndWorkspaceId({
          taskId,
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

    it('handles null dueDate in update', async () => {
      taskRepository.findByTaskIdAndWorkspaceId.mockResolvedValue(
        mockTaskCore as TaskEntity,
      );
      taskRepository.update.mockResolvedValue(mockTaskEntity);

      const taskId = 'task-1';
      const workspaceId = 'workspace-1';
      const data: UpdateTaskRequest = {
        title: 'Updated Task',
        rewardPoints: 30,
        dueDate: null,
      };

      await service.updateByTaskIdAndWorkspaceId({
        taskId,
        workspaceId,
        data,
      });

      const callArgs = taskRepository.update.mock.calls[0][0];
      expect(callArgs.data.dueDate).toBeNull();
    });

    it('converts dueDate ISO string to UTC Date', async () => {
      taskRepository.findByTaskIdAndWorkspaceId.mockResolvedValue(
        mockTaskCore as TaskEntity,
      );
      taskRepository.update.mockResolvedValue(mockTaskEntity);

      const data: UpdateTaskRequest = {
        title: 'Updated Task',
        rewardPoints: 30,
        dueDate: '2025-01-15T10:30:00Z',
      };

      await service.updateByTaskIdAndWorkspaceId({
        taskId: 'task-1',
        workspaceId: 'workspace-1',
        data,
      });

      const callArgs = taskRepository.update.mock.calls[0][0];
      expect(callArgs.data.dueDate).toEqual(expect.any(Date));
      expect(callArgs.data.dueDate?.toISOString()).toContain('2025-01-15');
    });

    it('correctly formats assignees in response', async () => {
      taskRepository.findByTaskIdAndWorkspaceId.mockResolvedValue(
        mockTaskCore as TaskEntity,
      );
      taskRepository.update.mockResolvedValue(mockTaskEntity);

      const result = await service.updateByTaskIdAndWorkspaceId({
        taskId: 'task-1',
        workspaceId: 'workspace-1',
        data: {
          title: 'Updated Task',
          rewardPoints: 30,
        },
      });

      expect(result.assignees).toEqual([
        {
          id: 'assignee-1',
          firstName: 'Jane',
          lastName: 'Smith',
          profileImageUrl: 'https://example.com/image.jpg',
          status: ProgressStatus.IN_PROGRESS,
        },
      ]);
    });

    it('handles null createdBy in update response', async () => {
      const taskEntityWithoutCreatedBy = {
        ...mockTaskEntity,
        createdBy: null,
      };
      taskRepository.findByTaskIdAndWorkspaceId.mockResolvedValue(
        mockTaskCore as TaskEntity,
      );
      taskRepository.update.mockResolvedValue(
        taskEntityWithoutCreatedBy as TaskEntity,
      );

      const result = await service.updateByTaskIdAndWorkspaceId({
        taskId: 'task-1',
        workspaceId: 'workspace-1',
        data: {
          title: 'Updated Task',
          rewardPoints: 30,
        },
      });

      expect(result.createdBy).toBeNull();
    });
  });
});
