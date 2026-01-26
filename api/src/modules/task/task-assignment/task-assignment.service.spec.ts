import { HttpStatus } from '@nestjs/common';
import { Test, TestingModule } from '@nestjs/testing';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';
import { UnitOfWorkService } from 'src/modules/unit-of-work/unit-of-work.service';
import { UpdateTaskAssignmentsRequest } from 'src/modules/workspace/workspace-module/dto/request/update-task-assignment-request.dto';
import { WorkspaceUserRole } from 'src/modules/workspace/workspace-user-module/domain/workspace-user-role.enum';
import { WorkspaceUserWithUser } from 'src/modules/workspace/workspace-user-module/domain/workspace-user-with-user.domain';
import { WorkspaceUserEntity } from 'src/modules/workspace/workspace-user-module/persistence/workspace-user.entity';
import { ProgressStatus } from '../task-module/domain/progress-status.enum';
import { TASK_MAXIMUM_ASSIGNEES_COUNT } from '../task-module/domain/task.constants';
import { TaskAssignmentEntity } from './persistence/task-assignment.entity';
import { TaskAssignmentRepository } from './persistence/task-assignment.repository';
import { TaskAssignmentService } from './task-assignment.service';

const mockWorkspaceUserWithUserFactory = (
  overrides?: any,
): WorkspaceUserWithUser => ({
  id: 'workspace-user-1',
  workspaceRole: WorkspaceUserRole.MEMBER,
  user: {
    id: 'assignee-1',
    firstName: 'John',
    lastName: 'Doe',
    profileImageUrl: null,
  } as any,
  ...overrides,
});

const mockTaskAssignmentEntityFactory = (
  overrides?: Partial<TaskAssignmentEntity>,
): TaskAssignmentEntity => {
  const base = {
    id: 'assignment-1',
    status: ProgressStatus.IN_PROGRESS,
    createdAt: new Date(),
    updatedAt: new Date(),
    deletedAt: null,
    assignee: mockWorkspaceUserWithUserFactory(),
    ...overrides,
  };

  return base as unknown as TaskAssignmentEntity;
};

const createMockRepository = () => ({
  sumPointsByAssignee: jest.fn(),
  createMultiple: jest.fn(),
  findAllByTaskId: jest.fn(),
  findAllByTaskIdAndAssigneeIds: jest.fn(),
  update: jest.fn(),
  deleteByTaskIdAndAssigneeIds: jest.fn(),
  countByTaskId: jest.fn(),
  updateAllByTaskId: jest.fn(),
});

const createMockUnitOfWorkService = () => ({
  withTransaction: jest.fn().mockImplementation(async (cb) => {
    await Promise.resolve();
    return cb();
  }),
});

describe('TaskAssignmentService', () => {
  let service: TaskAssignmentService;
  let taskAssignmentRepository: ReturnType<typeof createMockRepository>;

  beforeEach(async () => {
    jest.clearAllMocks();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        TaskAssignmentService,
        {
          provide: TaskAssignmentRepository,
          useValue: createMockRepository(),
        },
        {
          provide: UnitOfWorkService,
          useValue: createMockUnitOfWorkService(),
        },
      ],
    }).compile();

    service = module.get<TaskAssignmentService>(TaskAssignmentService);
    taskAssignmentRepository = module.get(TaskAssignmentRepository);
  });

  describe('getAccumulatedPointsForWorkspaceUser', () => {
    it('returns accumulated points for a workspace user', async () => {
      taskAssignmentRepository.sumPointsByAssignee.mockResolvedValue(150);

      const result = await service.getAccumulatedPointsForWorkspaceUser({
        workspaceId: 'workspace-1',
        workspaceUserId: 'workspace-user-1',
      });

      expect(taskAssignmentRepository.sumPointsByAssignee).toHaveBeenCalledWith(
        {
          workspaceId: 'workspace-1',
          workspaceUserId: 'workspace-user-1',
        },
      );
      expect(result).toBe(150);
    });
  });

  describe('createMultiple', () => {
    it('creates multiple task assignments', async () => {
      taskAssignmentRepository.findAllByTaskId.mockResolvedValue([]);
      taskAssignmentRepository.findAllByTaskIdAndAssigneeIds.mockResolvedValue(
        [],
      );
      const mockAssignment = mockTaskAssignmentEntityFactory();
      taskAssignmentRepository.createMultiple.mockResolvedValue([
        mockAssignment,
      ]);

      const assignments = [
        {
          workspaceUserId: 'workspace-user-1',
          status: ProgressStatus.IN_PROGRESS,
        },
      ];

      const result = await service.createMultiple({
        assignments,
        taskId: 'task-1',
      });

      expect(taskAssignmentRepository.createMultiple).toHaveBeenCalledWith({
        assignments,
        taskId: 'task-1',
        relations: { assignee: { user: true } },
      });
      expect(result).toEqual([mockAssignment]);
    });

    it('throws TASK_ASSIGNEES_COUNT_MAXED_OUT when limit reached', async () => {
      const maxedOutAssignments = Array.from(
        { length: TASK_MAXIMUM_ASSIGNEES_COUNT },
        () => mockTaskAssignmentEntityFactory(),
      );
      taskAssignmentRepository.findAllByTaskId.mockResolvedValue(
        maxedOutAssignments,
      );

      await expect(
        service.createMultiple({
          assignments: [
            {
              workspaceUserId: 'new-user',
              status: ProgressStatus.IN_PROGRESS,
            },
          ],
          taskId: 'task-1',
        }),
      ).rejects.toMatchObject({
        status: HttpStatus.UNPROCESSABLE_ENTITY,
        response: { code: ApiErrorCode.TASK_ASSIGNEES_COUNT_MAXED_OUT },
      });
    });

    it('throws TASK_ASSIGNEES_ALREADY_EXIST when assignee already assigned', async () => {
      taskAssignmentRepository.findAllByTaskId.mockResolvedValue([]);
      taskAssignmentRepository.findAllByTaskIdAndAssigneeIds.mockResolvedValue([
        mockTaskAssignmentEntityFactory(),
      ]);

      await expect(
        service.createMultiple({
          assignments: [
            {
              workspaceUserId: 'workspace-user-1',
              status: ProgressStatus.IN_PROGRESS,
            },
          ],
          taskId: 'task-1',
        }),
      ).rejects.toMatchObject({
        status: HttpStatus.UNPROCESSABLE_ENTITY,
        response: { code: ApiErrorCode.TASK_ASSIGNEES_ALREADY_EXIST },
      });
    });

    it('throws SERVER_ERROR if created count does not match requested', async () => {
      taskAssignmentRepository.findAllByTaskId.mockResolvedValue([]);
      taskAssignmentRepository.findAllByTaskIdAndAssigneeIds.mockResolvedValue(
        [],
      );
      taskAssignmentRepository.createMultiple.mockResolvedValue([]);

      await expect(
        service.createMultiple({
          assignments: [
            {
              workspaceUserId: 'workspace-user-1',
              status: ProgressStatus.IN_PROGRESS,
            },
          ],
          taskId: 'task-1',
        }),
      ).rejects.toMatchObject({
        status: HttpStatus.INTERNAL_SERVER_ERROR,
        response: { code: ApiErrorCode.SERVER_ERROR },
      });
    });
  });

  describe('findAllByTaskIdWithAssigneeUser', () => {
    it('returns assignments with assignee user', async () => {
      const mockAssignment = mockTaskAssignmentEntityFactory();
      taskAssignmentRepository.findAllByTaskId.mockResolvedValue([
        mockAssignment,
      ]);

      const result = await service.findAllByTaskIdWithAssigneeUser('task-1');

      expect(taskAssignmentRepository.findAllByTaskId).toHaveBeenCalledWith({
        taskId: 'task-1',
        relations: { assignee: { user: true } },
      });
      expect(result).toEqual([mockAssignment]);
    });
  });

  describe('findAllByTaskId', () => {
    it('returns assignments by task ID', async () => {
      const mockAssignment = mockTaskAssignmentEntityFactory();
      taskAssignmentRepository.findAllByTaskId.mockResolvedValue([
        mockAssignment,
      ]);

      const result = await service.findAllByTaskId('task-1');

      expect(taskAssignmentRepository.findAllByTaskId).toHaveBeenCalledWith({
        taskId: 'task-1',
      });
      expect(result).toEqual([mockAssignment]);
    });
  });

  describe('findAllByTaskIdAndAssigneeIds', () => {
    it('returns assignments by task ID and assignee IDs', async () => {
      const mockAssignment = mockTaskAssignmentEntityFactory();
      taskAssignmentRepository.findAllByTaskIdAndAssigneeIds.mockResolvedValue([
        mockAssignment,
      ]);

      const result = await service.findAllByTaskIdAndAssigneeIds({
        taskId: 'task-1',
        assigneeIds: ['user-1'],
      });

      expect(
        taskAssignmentRepository.findAllByTaskIdAndAssigneeIds,
      ).toHaveBeenCalledWith({
        taskId: 'task-1',
        assigneeIds: ['user-1'],
      });
      expect(result).toEqual([mockAssignment]);
    });
  });

  describe('findAllByTaskIdAndAssigneeIdsWithAssignee', () => {
    it('returns assignments with assignee relation', async () => {
      const mockAssignment = mockTaskAssignmentEntityFactory();
      taskAssignmentRepository.findAllByTaskIdAndAssigneeIds.mockResolvedValue([
        mockAssignment,
      ]);

      const result = await service.findAllByTaskIdAndAssigneeIdsWithAssignee({
        taskId: 'task-1',
        assigneeIds: ['user-1'],
      });

      expect(
        taskAssignmentRepository.findAllByTaskIdAndAssigneeIds,
      ).toHaveBeenCalledWith({
        taskId: 'task-1',
        assigneeIds: ['user-1'],
        relations: { assignee: true },
      });
      expect(result).toEqual([mockAssignment]);
    });
  });

  describe('updateAssignmentsByTaskId', () => {
    it('updates assignment status', async () => {
      const existing = mockTaskAssignmentEntityFactory({
        assignee: mockWorkspaceUserWithUserFactory({
          id: 'user-1',
        }) as WorkspaceUserEntity,
        status: ProgressStatus.IN_PROGRESS,
      });

      taskAssignmentRepository.findAllByTaskIdAndAssigneeIds.mockResolvedValue([
        existing,
      ]);
      taskAssignmentRepository.update.mockResolvedValue({
        ...existing,
        status: ProgressStatus.COMPLETED,
      });
      taskAssignmentRepository.findAllByTaskId.mockResolvedValue([
        { ...existing, status: ProgressStatus.COMPLETED },
      ]);

      const data: UpdateTaskAssignmentsRequest['assignments'] = [
        { assigneeId: 'user-1', status: ProgressStatus.COMPLETED },
      ];

      const result = await service.updateAssignmentsByTaskId({
        taskId: 'task-1',
        workspaceId: 'ws-1',
        data,
      });

      expect(taskAssignmentRepository.update).toHaveBeenCalledWith({
        id: existing.id,
        data: { status: ProgressStatus.COMPLETED },
      });
      expect(result[0].status).toBe(ProgressStatus.COMPLETED);
    });

    it('throws TASK_ASSIGNEES_INVALID if assignee mismatch', async () => {
      taskAssignmentRepository.findAllByTaskIdAndAssigneeIds.mockResolvedValue(
        [],
      );

      const data: UpdateTaskAssignmentsRequest['assignments'] = [
        { assigneeId: 'non-existent', status: ProgressStatus.COMPLETED },
      ];

      await expect(
        service.updateAssignmentsByTaskId({
          taskId: 'task-1',
          workspaceId: 'ws-1',
          data,
        }),
      ).rejects.toMatchObject({
        status: HttpStatus.UNPROCESSABLE_ENTITY,
        response: { code: ApiErrorCode.TASK_ASSIGNEES_INVALID },
      });
    });

    it('throws INVALID_PAYLOAD if update returns null', async () => {
      const existing = mockTaskAssignmentEntityFactory({
        assignee: mockWorkspaceUserWithUserFactory({
          id: 'user-1',
        }) as WorkspaceUserEntity,
      });
      taskAssignmentRepository.findAllByTaskIdAndAssigneeIds.mockResolvedValue([
        existing,
      ]);
      taskAssignmentRepository.update.mockResolvedValue(null);

      const data: UpdateTaskAssignmentsRequest['assignments'] = [
        { assigneeId: 'user-1', status: ProgressStatus.COMPLETED },
      ];

      await expect(
        service.updateAssignmentsByTaskId({
          taskId: 'task-1',
          workspaceId: 'ws-1',
          data,
        }),
      ).rejects.toMatchObject({
        status: HttpStatus.NOT_FOUND,
        response: { code: ApiErrorCode.INVALID_PAYLOAD },
      });
    });

    it('skips update if status unchanged', async () => {
      const existing = mockTaskAssignmentEntityFactory({
        assignee: mockWorkspaceUserWithUserFactory({
          id: 'user-1',
        }) as WorkspaceUserEntity,
        status: ProgressStatus.IN_PROGRESS,
      });
      taskAssignmentRepository.findAllByTaskIdAndAssigneeIds.mockResolvedValue([
        existing,
      ]);
      taskAssignmentRepository.findAllByTaskId.mockResolvedValue([existing]);

      const data: UpdateTaskAssignmentsRequest['assignments'] = [
        { assigneeId: 'user-1', status: ProgressStatus.IN_PROGRESS },
      ];

      await service.updateAssignmentsByTaskId({
        taskId: 'task-1',
        workspaceId: 'ws-1',
        data,
      });

      expect(taskAssignmentRepository.update).not.toHaveBeenCalled();
    });
  });

  describe('deleteByTaskIdAndAssigneeId', () => {
    it('deletes assignment', async () => {
      taskAssignmentRepository.deleteByTaskIdAndAssigneeIds.mockResolvedValue(
        true,
      );

      await service.deleteByTaskIdAndAssigneeId({
        assigneeId: 'user-1',
        taskId: 'task-1',
      });

      expect(
        taskAssignmentRepository.deleteByTaskIdAndAssigneeIds,
      ).toHaveBeenCalledWith({
        taskId: 'task-1',
        assigneeIds: ['user-1'],
      });
    });

    it('is idempotent when delete returns false', async () => {
      taskAssignmentRepository.deleteByTaskIdAndAssigneeIds.mockResolvedValue(
        false,
      );

      await expect(
        service.deleteByTaskIdAndAssigneeId({
          assigneeId: 'user-1',
          taskId: 'task-1',
        }),
      ).resolves.not.toThrow();
    });
  });

  describe('closeAssignmentsByTaskId', () => {
    it('closes all assignments', async () => {
      taskAssignmentRepository.countByTaskId.mockResolvedValue(1);
      taskAssignmentRepository.updateAllByTaskId.mockResolvedValue([
        mockTaskAssignmentEntityFactory({ status: ProgressStatus.CLOSED }),
      ]);

      await service.closeAssignmentsByTaskId('task-1');

      expect(taskAssignmentRepository.updateAllByTaskId).toHaveBeenCalledWith({
        taskId: 'task-1',
        data: { status: ProgressStatus.CLOSED },
      });
    });

    it('throws INVALID_PAYLOAD if no assignments found', async () => {
      taskAssignmentRepository.countByTaskId.mockResolvedValue(0);

      await expect(
        service.closeAssignmentsByTaskId('task-1'),
      ).rejects.toMatchObject({
        status: HttpStatus.NOT_FOUND,
        response: { code: ApiErrorCode.INVALID_PAYLOAD },
      });
    });

    it('throws INVALID_PAYLOAD if update count mismatch', async () => {
      taskAssignmentRepository.countByTaskId.mockResolvedValue(2);
      taskAssignmentRepository.updateAllByTaskId.mockResolvedValue([
        mockTaskAssignmentEntityFactory(),
      ]);

      await expect(
        service.closeAssignmentsByTaskId('task-1'),
      ).rejects.toMatchObject({
        status: HttpStatus.NOT_FOUND,
        response: { code: ApiErrorCode.INVALID_PAYLOAD },
      });
    });
  });
});
