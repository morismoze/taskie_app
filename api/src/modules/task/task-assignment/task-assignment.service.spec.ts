import { HttpStatus } from '@nestjs/common';
import { Test, TestingModule } from '@nestjs/testing';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';
import { ApiHttpException } from 'src/exception/api-http-exception.type';
import { UnitOfWorkService } from 'src/modules/unit-of-work/unit-of-work.service';
import { UpdateTaskAssignmentsRequest } from 'src/modules/workspace/workspace-module/dto/request/update-task-assignment-request.dto';
import { WorkspaceUserRole } from 'src/modules/workspace/workspace-user-module/domain/workspace-user-role.enum';
import { ProgressStatus } from '../task-module/domain/progress-status.enum';
import { TASK_MAXIMUM_ASSIGNEES_COUNT } from '../task-module/domain/task.constants';
import { TaskAssignmentCore } from './domain/task-assignment-core.domain';
import { TaskAssignmentWithAssigneeUser } from './domain/task-assignment-with-assignee-user.domain';
import { TaskAssignmentWithAssignee } from './domain/task-assignment-with-assignee.domain';
import { TaskAssignmentEntity } from './persistence/task-assignment.entity';
import { TaskAssignmentRepository } from './persistence/task-assignment.repository';
import { TaskAssignmentService } from './task-assignment.service';

describe('TaskAssignmentService', () => {
  let service: TaskAssignmentService;
  let taskAssignmentRepository: jest.Mocked<TaskAssignmentRepository>;
  let unitOfWorkService: jest.Mocked<UnitOfWorkService>;

  const mockAssigneeUser = {
    id: 'assignee-1',
    firstName: 'John',
    lastName: 'Doe',
    profileImageUrl: null,
  };

  const mockAssignee = {
    id: 'workspace-user-1',
    workspaceRole: WorkspaceUserRole.MEMBER,
    user: mockAssigneeUser,
  };

  const mockTaskAssignmentCore: TaskAssignmentCore = {
    id: 'assignment-1',
    status: ProgressStatus.IN_PROGRESS,
    createdAt: new Date('2024-01-01'),
    updatedAt: new Date('2024-01-01'),
    deletedAt: null,
  };

  const mockTaskAssignmentWithAssigneeUser: TaskAssignmentWithAssigneeUser = {
    ...mockTaskAssignmentCore,
    assignee: mockAssignee as TaskAssignmentWithAssigneeUser['assignee'],
  };

  const mockTaskAssignmentEntity: TaskAssignmentEntity = {
    id: 'assignment-1',
    status: ProgressStatus.IN_PROGRESS,
    createdAt: new Date('2024-01-01'),
    updatedAt: new Date('2024-01-01'),
    deletedAt: null,
    assignee: mockAssignee,
  } as TaskAssignmentEntity;

  beforeEach(async () => {
    jest.clearAllMocks();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        TaskAssignmentService,
        {
          provide: TaskAssignmentRepository,
          useValue: {
            sumPointsByAssignee: jest.fn(),
            createMultiple: jest.fn(),
            findAllByTaskId: jest.fn(),
            findAllByTaskIdAndAssigneeIds: jest.fn(),
            update: jest.fn(),
            deleteByTaskIdAndAssigneeIds: jest.fn(),
            countByTaskId: jest.fn(),
            updateAllByTaskId: jest.fn(),
          },
        },
        {
          provide: UnitOfWorkService,
          useValue: {
            withTransaction: jest.fn(),
          },
        },
      ],
    }).compile();

    service = module.get<TaskAssignmentService>(TaskAssignmentService);
    taskAssignmentRepository = module.get(
      TaskAssignmentRepository,
    ) as jest.Mocked<TaskAssignmentRepository>;
    unitOfWorkService = module.get(
      UnitOfWorkService,
    ) as jest.Mocked<UnitOfWorkService>;
  });

  describe('getAccumulatedPointsForWorkspaceUser', () => {
    it('returns accumulated points for a workspace user', async () => {
      taskAssignmentRepository.sumPointsByAssignee.mockResolvedValue(150);

      const workspaceId = 'workspace-1';
      const workspaceUserId = 'workspace-user-1';
      const result = await service.getAccumulatedPointsForWorkspaceUser({
        workspaceId,
        workspaceUserId,
      });

      expect(taskAssignmentRepository.sumPointsByAssignee).toHaveBeenCalledWith(
        {
          workspaceId,
          workspaceUserId,
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
      taskAssignmentRepository.createMultiple.mockResolvedValue([
        mockTaskAssignmentEntity,
      ]);

      const taskId = 'task-1';
      const assignments = [
        {
          workspaceUserId: 'workspace-user-1',
          status: ProgressStatus.IN_PROGRESS,
        },
      ];

      const result = await service.createMultiple({
        assignments,
        taskId,
      });

      expect(taskAssignmentRepository.findAllByTaskId).toHaveBeenCalledWith({
        taskId,
      });
      expect(
        taskAssignmentRepository.findAllByTaskIdAndAssigneeIds,
      ).toHaveBeenCalledWith({ taskId, assigneeIds: ['workspace-user-1'] });
      expect(taskAssignmentRepository.createMultiple).toHaveBeenCalledWith({
        assignments,
        taskId,
        relations: {
          assignee: {
            user: true,
          },
        },
      });
      expect(result).toEqual([mockTaskAssignmentEntity]);
    });

    it('throws TASK_ASSIGNEES_COUNT_MAXED_OUT when maximum assignees reached', async () => {
      const maxedOutAssignments = Array.from(
        { length: TASK_MAXIMUM_ASSIGNEES_COUNT },
        (_, i) => ({
          ...mockTaskAssignmentCore,
          id: `assignment-${i}`,
        }),
      );
      taskAssignmentRepository.findAllByTaskId.mockResolvedValue(
        maxedOutAssignments as TaskAssignmentEntity[],
      );

      const taskId = 'task-1';
      const assignments = [
        {
          workspaceUserId: 'workspace-user-new',
          status: ProgressStatus.IN_PROGRESS,
        },
      ];

      try {
        await service.createMultiple({
          assignments,
          taskId,
        });
      } catch (error) {
        expect(error).toBeInstanceOf(ApiHttpException);
        expect((error as ApiHttpException).getStatus()).toBe(
          HttpStatus.UNPROCESSABLE_ENTITY,
        );
        expect((error as ApiHttpException).getResponse()).toEqual({
          code: ApiErrorCode.TASK_ASSIGNEES_COUNT_MAXED_OUT,
        });
      }
    });

    it('throws TASK_ASSIGNEES_ALREADY_EXIST when assignee already assigned', async () => {
      taskAssignmentRepository.findAllByTaskId.mockResolvedValue([]);
      taskAssignmentRepository.findAllByTaskIdAndAssigneeIds.mockResolvedValue([
        mockTaskAssignmentEntity,
      ]);

      const taskId = 'task-1';
      const assignments = [
        {
          workspaceUserId: 'workspace-user-1',
          status: ProgressStatus.IN_PROGRESS,
        },
      ];

      try {
        await service.createMultiple({
          assignments,
          taskId,
        });
      } catch (error) {
        expect(error).toBeInstanceOf(ApiHttpException);
        expect((error as ApiHttpException).getStatus()).toBe(
          HttpStatus.UNPROCESSABLE_ENTITY,
        );
        expect((error as ApiHttpException).getResponse()).toEqual({
          code: ApiErrorCode.TASK_ASSIGNEES_ALREADY_EXIST,
        });
      }
    });

    it('throws SERVER_ERROR if created assignments count does not match requested', async () => {
      taskAssignmentRepository.findAllByTaskId.mockResolvedValue([]);
      taskAssignmentRepository.findAllByTaskIdAndAssigneeIds.mockResolvedValue(
        [],
      );
      taskAssignmentRepository.createMultiple.mockResolvedValue([]);

      const taskId = 'task-1';
      const assignments = [
        {
          workspaceUserId: 'workspace-user-1',
          status: ProgressStatus.IN_PROGRESS,
        },
      ];

      try {
        await service.createMultiple({
          assignments,
          taskId,
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

  describe('findAllByTaskIdWithAssigneeUser', () => {
    it('returns all task assignments with assignee user', async () => {
      taskAssignmentRepository.findAllByTaskId.mockResolvedValue([
        mockTaskAssignmentEntity,
      ]);

      const taskId = 'task-1';
      const result = await service.findAllByTaskIdWithAssigneeUser(taskId);

      expect(taskAssignmentRepository.findAllByTaskId).toHaveBeenCalledWith({
        taskId,
        relations: {
          assignee: {
            user: true,
          },
        },
      });
      expect(result).toEqual([mockTaskAssignmentEntity]);
    });
  });

  describe('findAllByTaskId', () => {
    it('returns all task assignments by task ID', async () => {
      taskAssignmentRepository.findAllByTaskId.mockResolvedValue([
        mockTaskAssignmentEntity,
      ]);

      const taskId = 'task-1';
      const result = await service.findAllByTaskId(taskId);

      expect(taskAssignmentRepository.findAllByTaskId).toHaveBeenCalledWith({
        taskId,
      });
      expect(result).toEqual([mockTaskAssignmentEntity]);
    });
  });

  describe('findAllByTaskIdAndAssigneeIds', () => {
    it('returns task assignments by task ID and assignee IDs', async () => {
      taskAssignmentRepository.findAllByTaskIdAndAssigneeIds.mockResolvedValue([
        mockTaskAssignmentEntity,
      ]);

      const taskId = 'task-1';
      const assigneeIds = ['workspace-user-1'];
      const result = await service.findAllByTaskIdAndAssigneeIds({
        taskId,
        assigneeIds,
      });

      expect(
        taskAssignmentRepository.findAllByTaskIdAndAssigneeIds,
      ).toHaveBeenCalledWith({
        taskId,
        assigneeIds,
      });
      expect(result).toEqual([mockTaskAssignmentEntity]);
    });
  });

  describe('findAllByTaskIdAndAssigneeIdsWithAssignee', () => {
    it('returns task assignments with assignee by task ID and assignee IDs', async () => {
      taskAssignmentRepository.findAllByTaskIdAndAssigneeIds.mockResolvedValue([
        mockTaskAssignmentEntity,
      ]);

      const taskId = 'task-1';
      const assigneeIds = ['workspace-user-1'];
      const result = await service.findAllByTaskIdAndAssigneeIdsWithAssignee({
        taskId,
        assigneeIds,
      });

      expect(
        taskAssignmentRepository.findAllByTaskIdAndAssigneeIds,
      ).toHaveBeenCalledWith({
        taskId,
        assigneeIds,
        relations: {
          assignee: true,
        },
      });
      expect(result).toEqual([mockTaskAssignmentEntity]);
    });
  });

  describe('updateAssignmentsByTaskId', () => {
    it('updates task assignments status', async () => {
      taskAssignmentRepository.findAllByTaskIdAndAssigneeIds.mockResolvedValue([
        mockTaskAssignmentEntity,
      ]);
      taskAssignmentRepository.update.mockResolvedValue({
        ...mockTaskAssignmentCore,
        status: ProgressStatus.COMPLETED,
      } as TaskAssignmentEntity);
      taskAssignmentRepository.findAllByTaskId.mockResolvedValue([
        mockTaskAssignmentEntity,
      ]);
      unitOfWorkService.withTransaction.mockImplementation(async (cb) => cb());

      const taskId = 'task-1';
      const data: UpdateTaskAssignmentsRequest['assignments'] = [
        {
          assigneeId: 'workspace-user-1',
          status: ProgressStatus.COMPLETED,
        },
      ];
      const result = await service.updateAssignmentsByTaskId({
        taskId,
        workspaceId: 'workspace-1',
        data,
      });

      expect(taskAssignmentRepository.update).toHaveBeenCalledWith({
        id: mockTaskAssignmentCore.id,
        data: { status: ProgressStatus.COMPLETED },
      });
      expect(result).toEqual([mockTaskAssignmentEntity]);
    });

    it('throws TASK_ASSIGNEES_INVALID if provided assignee does not exist', async () => {
      taskAssignmentRepository.findAllByTaskIdAndAssigneeIds.mockResolvedValue(
        [],
      );
      unitOfWorkService.withTransaction.mockImplementation(async (cb) => cb());

      const taskId = 'task-1';
      const data: UpdateTaskAssignmentsRequest['assignments'] = [
        {
          assigneeId: 'non-existent-assignee',
          status: ProgressStatus.COMPLETED,
        },
      ];

      try {
        await service.updateAssignmentsByTaskId({
          taskId,
          workspaceId: 'workspace-1',
          data,
        });
      } catch (error) {
        expect(error).toBeInstanceOf(ApiHttpException);
        expect((error as ApiHttpException).getStatus()).toBe(
          HttpStatus.UNPROCESSABLE_ENTITY,
        );
        expect((error as ApiHttpException).getResponse()).toEqual({
          code: ApiErrorCode.TASK_ASSIGNEES_INVALID,
        });
      }
    });

    it('throws INVALID_PAYLOAD if assignment deleted during update', async () => {
      taskAssignmentRepository.findAllByTaskIdAndAssigneeIds
        .mockResolvedValueOnce([
          mockTaskAssignmentWithAssigneeUser as TaskAssignmentEntity,
        ])
        .mockResolvedValueOnce([]);
      taskAssignmentRepository.update.mockResolvedValue(null);
      unitOfWorkService.withTransaction.mockImplementation(async (cb) => cb());

      const taskId = 'task-1';
      const data: UpdateTaskAssignmentsRequest['assignments'] = [
        {
          assigneeId: 'workspace-user-1',
          status: ProgressStatus.COMPLETED,
        },
      ];

      try {
        await service.updateAssignmentsByTaskId({
          taskId,
          workspaceId: 'workspace-1',
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

    it('skips update if status has not changed', async () => {
      const mockTaskAssignmentWithAssignee: TaskAssignmentWithAssignee = {
        ...mockTaskAssignmentEntity,
        status: ProgressStatus.IN_PROGRESS,
      };
      taskAssignmentRepository.findAllByTaskIdAndAssigneeIds.mockResolvedValue([
        mockTaskAssignmentWithAssignee as TaskAssignmentEntity,
      ]);
      taskAssignmentRepository.findAllByTaskId.mockResolvedValue([
        mockTaskAssignmentEntity,
      ]);
      unitOfWorkService.withTransaction.mockImplementation(async (cb) => cb());

      const taskId = 'task-1';
      const data: UpdateTaskAssignmentsRequest['assignments'] = [
        {
          assigneeId: 'workspace-user-1',
          status: ProgressStatus.IN_PROGRESS,
        },
      ];
      await service.updateAssignmentsByTaskId({
        taskId,
        workspaceId: 'workspace-1',
        data,
      });

      // Update should not be called since status didn't change
      expect(taskAssignmentRepository.update).not.toHaveBeenCalled();
    });
  });

  describe('deleteByTaskIdAndAssigneeId', () => {
    it('deletes a task assignment by task ID and assignee ID', async () => {
      taskAssignmentRepository.deleteByTaskIdAndAssigneeIds.mockResolvedValue(
        true,
      );

      const taskId = 'task-1';
      const assigneeId = 'workspace-user-1';
      await service.deleteByTaskIdAndAssigneeId({
        assigneeId,
        taskId,
      });

      expect(
        taskAssignmentRepository.deleteByTaskIdAndAssigneeIds,
      ).toHaveBeenCalledWith({
        taskId,
        assigneeIds: [assigneeId],
      });
    });

    it('is idempotent (does not throw if assignment does not exist)', async () => {
      taskAssignmentRepository.deleteByTaskIdAndAssigneeIds.mockResolvedValue(
        false,
      );

      const taskId = 'task-1';
      const assigneeId = 'non-existent-assignee';

      // Should not throw
      await expect(
        service.deleteByTaskIdAndAssigneeId({
          assigneeId,
          taskId,
        }),
      ).resolves.toBeUndefined();
    });
  });

  describe('closeAssignmentsByTaskId', () => {
    it('closes all assignments for a task', async () => {
      taskAssignmentRepository.countByTaskId.mockResolvedValue(1);
      taskAssignmentRepository.updateAllByTaskId.mockResolvedValue([
        {
          ...mockTaskAssignmentEntity,
          status: ProgressStatus.CLOSED,
        } as TaskAssignmentEntity,
      ]);
      unitOfWorkService.withTransaction.mockImplementation(async (cb) => cb());

      const taskId = 'task-1';
      await service.closeAssignmentsByTaskId(taskId);

      expect(taskAssignmentRepository.countByTaskId).toHaveBeenCalledWith(
        taskId,
      );
      expect(taskAssignmentRepository.updateAllByTaskId).toHaveBeenCalledWith({
        taskId,
        data: { status: ProgressStatus.CLOSED },
      });
    });

    it('throws INVALID_PAYLOAD if no assignments found', async () => {
      taskAssignmentRepository.countByTaskId.mockResolvedValue(0);

      const taskId = 'task-1';

      try {
        await service.closeAssignmentsByTaskId(taskId);
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

    it('throws INVALID_PAYLOAD if updated assignments count does not match', async () => {
      taskAssignmentRepository.countByTaskId.mockResolvedValue(2);
      taskAssignmentRepository.updateAllByTaskId.mockResolvedValue([
        {
          ...mockTaskAssignmentCore,
          status: ProgressStatus.CLOSED,
        } as TaskAssignmentEntity,
      ]);
      unitOfWorkService.withTransaction.mockImplementation(async (cb) => cb());

      const taskId = 'task-1';

      try {
        await service.closeAssignmentsByTaskId(taskId);
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
