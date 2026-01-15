import { HttpStatus } from '@nestjs/common';
import { Test, TestingModule } from '@nestjs/testing';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';
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
import { TaskEntity } from './persistence/task.entity';
import { TaskRepository } from './persistence/task.repository';
import { TaskService } from './task.service';

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
  user: mockUserEntityFactory(),
  ...overrides,
});

const mockTaskAssignmentEntityFactory = (
  overrides?: Partial<TaskAssignmentEntity>,
): TaskAssignmentEntity =>
  ({
    id: 'assignment-1',
    status: ProgressStatus.IN_PROGRESS,
    assignee: mockWorkspaceUserEntityFactory(),
    ...overrides,
  }) as TaskAssignmentEntity;

const mockTaskEntityFactory = (overrides?: Partial<TaskEntity>): TaskEntity => {
  const base = {
    id: 'task-1',
    title: 'Test Task',
    rewardPoints: 25,
    description: 'Test task description',
    dueDate: new Date('2024-12-31'),
    createdAt: new Date(),
    updatedAt: new Date(),
    deletedAt: null,
    workspaceId: 'workspace-1',
    createdBy: mockWorkspaceUserEntityFactory({
      id: 'creator-ws-user',
      user: mockUserEntityFactory({ firstName: 'Creator' }),
    }),
    taskAssignments: [mockTaskAssignmentEntityFactory()],
    ...overrides,
  };

  return base as unknown as TaskEntity;
};

const createMockRepository = () => ({
  findAllByWorkspaceId: jest.fn(),
  create: jest.fn(),
  findById: jest.fn(),
  findByTaskIdAndWorkspaceId: jest.fn(),
  update: jest.fn(),
});

describe('TaskService', () => {
  let service: TaskService;
  let taskRepository: ReturnType<typeof createMockRepository>;

  beforeEach(async () => {
    jest.clearAllMocks();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        TaskService,
        {
          provide: TaskRepository,
          useValue: createMockRepository(),
        },
      ],
    }).compile();

    service = module.get<TaskService>(TaskService);
    taskRepository = module.get(TaskRepository);
  });

  describe('findPaginatedByWorkspaceWithAssignees', () => {
    it('returns paginated tasks with mapped assignees', async () => {
      const entity = mockTaskEntityFactory();
      taskRepository.findAllByWorkspaceId.mockResolvedValue({
        data: [entity],
        totalPages: 1,
        total: 1,
      });

      const result = await service.findPaginatedByWorkspaceWithAssignees({
        workspaceId: 'workspace-1',
        query: {},
      });

      expect(taskRepository.findAllByWorkspaceId).toHaveBeenCalledWith({
        workspaceId: 'workspace-1',
        query: {
          page: 1,
          limit: WORKSPACE_OBJECTIVE_DEFAULT_QUERY_LIMIT,
          status: null,
          search: null,
          sort: SortBy.NEWEST,
        },
      });

      expect(result.data).toHaveLength(1);
      expect(result.data[0].id).toBe(entity.id);
      expect(result.data[0].assignees[0].firstName).toBe(
        entity.taskAssignments[0].assignee.user.firstName,
      );
      expect(result.data[0].createdBy?.firstName).toBe(
        entity.createdBy!.user.firstName,
      );
    });

    it('passes custom query parameters correctly', async () => {
      taskRepository.findAllByWorkspaceId.mockResolvedValue({
        data: [],
        totalPages: 0,
        total: 0,
      });

      const query: WorkspaceObjectiveRequestQuery = {
        page: 2,
        limit: 10,
        status: ProgressStatus.COMPLETED,
        search: 'task',
        sort: SortBy.OLDEST,
      };

      await service.findPaginatedByWorkspaceWithAssignees({
        workspaceId: 'workspace-1',
        query,
      });

      expect(taskRepository.findAllByWorkspaceId).toHaveBeenCalledWith({
        workspaceId: 'workspace-1',
        query: {
          page: 2,
          limit: 10,
          status: ProgressStatus.COMPLETED,
          search: 'task',
          sort: SortBy.OLDEST,
        },
      });
    });

    it('handles null createdBy', async () => {
      const entity = mockTaskEntityFactory({ createdBy: null });
      taskRepository.findAllByWorkspaceId.mockResolvedValue({
        data: [entity],
        totalPages: 1,
        total: 1,
      });

      const result = await service.findPaginatedByWorkspaceWithAssignees({
        workspaceId: 'workspace-1',
        query: {},
      });

      expect(result.data[0].createdBy).toBeNull();
    });

    it('trims search query', async () => {
      taskRepository.findAllByWorkspaceId.mockResolvedValue({
        data: [],
        totalPages: 0,
        total: 0,
      });

      await service.findPaginatedByWorkspaceWithAssignees({
        workspaceId: 'workspace-1',
        query: { search: '  term  ' },
      });

      expect(taskRepository.findAllByWorkspaceId).toHaveBeenCalledWith(
        expect.objectContaining({
          query: expect.objectContaining({ search: 'term' }),
        }),
      );
    });
  });

  describe('create', () => {
    it('creates a new task and maps response', async () => {
      const mockEntity = mockTaskEntityFactory();
      taskRepository.create.mockResolvedValue(mockEntity);

      const data: Omit<CreateTaskRequest, 'assignees'> = {
        title: 'New Task',
        description: 'Desc',
        rewardPoints: 100,
        dueDate: '2024-12-31T00:00:00Z',
      };

      const result = await service.create({
        workspaceId: 'workspace-1',
        createdById: 'creator-1',
        data,
      });

      expect(taskRepository.create).toHaveBeenCalledWith({
        workspaceId: 'workspace-1',
        createdById: 'creator-1',
        data: {
          title: data.title,
          description: data.description,
          rewardPoints: data.rewardPoints,
          dueDate: expect.any(Date),
        },
        relations: { createdBy: { user: true } },
      });

      expect(result.assignees).toEqual([]);
      expect(result.title).toBe(mockEntity.title);
    });

    it('creates task with null description and dueDate', async () => {
      const mockEntity = mockTaskEntityFactory({
        description: null,
        dueDate: null,
      });
      taskRepository.create.mockResolvedValue(mockEntity);

      const data: Omit<CreateTaskRequest, 'assignees'> = {
        title: 'Task',
        rewardPoints: 50,
      };

      const result = await service.create({
        workspaceId: 'workspace-1',
        createdById: 'creator-1',
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
      expect(result.dueDate).toBeNull();
    });

    it('throws SERVER_ERROR if creation returns null', async () => {
      taskRepository.create.mockResolvedValue(null);

      const data: Omit<CreateTaskRequest, 'assignees'> = {
        title: 'Task',
        rewardPoints: 50,
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

  describe('findById', () => {
    it('returns task if found', async () => {
      const mockEntity = mockTaskEntityFactory();
      taskRepository.findById.mockResolvedValue(mockEntity);

      const result = await service.findById('task-1');

      expect(result).toEqual(mockEntity);
    });

    it('returns null if not found', async () => {
      taskRepository.findById.mockResolvedValue(null);

      const result = await service.findById('task-1');

      expect(result).toBeNull();
    });
  });

  describe('findByTaskIdAndWorkspaceId', () => {
    it('returns task if found', async () => {
      const mockEntity = mockTaskEntityFactory();
      taskRepository.findByTaskIdAndWorkspaceId.mockResolvedValue(mockEntity);

      const result = await service.findByTaskIdAndWorkspaceId({
        taskId: 'task-1',
        workspaceId: 'workspace-1',
      });

      expect(result).toEqual(mockEntity);
    });

    it('returns null if not found', async () => {
      taskRepository.findByTaskIdAndWorkspaceId.mockResolvedValue(null);

      const result = await service.findByTaskIdAndWorkspaceId({
        taskId: 'task-1',
        workspaceId: 'workspace-1',
      });

      expect(result).toBeNull();
    });
  });

  describe('updateByTaskIdAndWorkspaceId', () => {
    it('updates task and maps assignees', async () => {
      const existingTask = mockTaskEntityFactory();
      const updatedTask = mockTaskEntityFactory({
        title: 'Updated',
        taskAssignments: [
          mockTaskAssignmentEntityFactory({
            assignee: mockWorkspaceUserEntityFactory({
              user: mockUserEntityFactory({ firstName: 'Assignee' }),
            }),
          }),
        ],
      });

      taskRepository.findByTaskIdAndWorkspaceId.mockResolvedValue(existingTask);
      taskRepository.update.mockResolvedValue(updatedTask);

      const data: UpdateTaskRequest = {
        title: 'Updated',
        rewardPoints: 50,
        dueDate: '2025-01-01T00:00:00Z',
      };

      const result = await service.updateByTaskIdAndWorkspaceId({
        taskId: 'task-1',
        workspaceId: 'workspace-1',
        data,
      });

      expect(taskRepository.update).toHaveBeenCalledWith({
        id: 'task-1',
        data: {
          title: data.title,
          description: undefined,
          rewardPoints: data.rewardPoints,
          dueDate: expect.any(Date),
        },
        relations: {
          taskAssignments: { assignee: { user: true } },
          createdBy: { user: true },
        },
      });

      expect(result.title).toBe('Updated');
      expect(result.assignees[0].firstName).toBe('Assignee');
    });

    it('throws NOT_FOUND if task does not exist', async () => {
      taskRepository.findByTaskIdAndWorkspaceId.mockResolvedValue(null);

      await expect(
        service.updateByTaskIdAndWorkspaceId({
          taskId: 'task-1',
          workspaceId: 'workspace-1',
          data: { title: 'New' } as any,
        }),
      ).rejects.toMatchObject({
        status: HttpStatus.NOT_FOUND,
        response: { code: ApiErrorCode.INVALID_PAYLOAD },
      });
    });

    it('throws NOT_FOUND if update returns null', async () => {
      taskRepository.findByTaskIdAndWorkspaceId.mockResolvedValue(
        mockTaskEntityFactory(),
      );
      taskRepository.update.mockResolvedValue(null);

      await expect(
        service.updateByTaskIdAndWorkspaceId({
          taskId: 'task-1',
          workspaceId: 'workspace-1',
          data: { title: 'New' } as any,
        }),
      ).rejects.toMatchObject({
        status: HttpStatus.NOT_FOUND,
        response: { code: ApiErrorCode.INVALID_PAYLOAD },
      });
    });

    it('handles removing dueDate (set to null)', async () => {
      taskRepository.findByTaskIdAndWorkspaceId.mockResolvedValue(
        mockTaskEntityFactory(),
      );
      taskRepository.update.mockResolvedValue(mockTaskEntityFactory());

      await service.updateByTaskIdAndWorkspaceId({
        taskId: 'task-1',
        workspaceId: 'workspace-1',
        data: { title: 'T', rewardPoints: 10, dueDate: null },
      });

      const callArgs = taskRepository.update.mock.calls[0][0];
      expect(callArgs.data.dueDate).toBeNull();
    });

    it('handles ISO date string conversion', async () => {
      taskRepository.findByTaskIdAndWorkspaceId.mockResolvedValue(
        mockTaskEntityFactory(),
      );
      taskRepository.update.mockResolvedValue(mockTaskEntityFactory());

      const isoDate = '2025-05-05T12:00:00Z';
      await service.updateByTaskIdAndWorkspaceId({
        taskId: 'task-1',
        workspaceId: 'workspace-1',
        data: { title: 'T', rewardPoints: 10, dueDate: isoDate },
      });

      const callArgs = taskRepository.update.mock.calls[0][0];
      expect(callArgs.data.dueDate).toBeInstanceOf(Date);
      expect(callArgs.data.dueDate.toISOString()).toContain('2025-05-05');
    });
  });
});
