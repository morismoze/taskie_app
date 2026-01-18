import { HttpStatus, Injectable } from '@nestjs/common';
import { DateTime } from 'luxon';
import { Nullable } from 'src/common/types/nullable.type';
import { ApiErrorCode } from 'src/exception/api-error-code.enum';
import { ApiHttpException } from 'src/exception/api-http-exception.type';
import { JwtPayload } from '../auth/core/strategies/jwt-payload.type';
import { WorkspaceUserRole } from '../workspace/workspace-user-module/domain/workspace-user-role.enum';
import { WorkspaceUserService } from '../workspace/workspace-user-module/workspace-user.service';
import { User } from './domain/user.domain';
import {
  RolePerWorkspace,
  UserResponse,
} from './dto/response/user-response.dto';
import { UserRepository } from './persistence/user.repository';

@Injectable()
export class UserService {
  constructor(
    private readonly userRepository: UserRepository,
    private readonly workspaceUserService: WorkspaceUserService,
  ) {}

  /**
   * This method creates a new user who "registered" via auth provider
   */
  async create(data: {
    email: NonNullable<User['email']>;
    firstName: User['firstName'];
    lastName: User['lastName'];
    socialId: NonNullable<User['socialId']>;
    provider: NonNullable<User['provider']>;
    profileImageUrl: User['profileImageUrl'];
    status: User['status'];
  }): Promise<User> {
    const existingUser = await this.userRepository.findByEmail(data.email!);

    if (existingUser) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.EMAIL_ALREADY_EXISTS,
        },
        HttpStatus.UNPROCESSABLE_ENTITY,
      );
    }

    const newUser = await this.userRepository.create(data);

    if (!newUser) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.SERVER_ERROR,
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }

    return newUser;
  }

  /**
   * This method creates a new virtual user who was created by a Manager user
   */
  async createVirtualUser(
    data: Pick<User, 'firstName' | 'lastName' | 'status'>,
  ): Promise<User> {
    const newVirtualUser = await this.userRepository.createVirtualUser(data);

    if (!newVirtualUser) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.SERVER_ERROR,
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }

    return newVirtualUser;
  }

  async me(data: JwtPayload): Promise<UserResponse> {
    // Using assertion because user should be always found based on how JWT works (custom secret)
    const user = (await this.findById(data.sub)) as User;

    const rolesPerWorkspaces: RolePerWorkspace[] = (
      await this.workspaceUserService.findAllByUserIdWithWorkspace(user.id)
    ).map((wu) => ({
      workspaceId: wu.workspace.id,
      role: wu.workspaceRole,
    }));

    const userDto: UserResponse = {
      email: user.email,
      firstName: user.firstName,
      id: user.id,
      lastName: user.lastName,
      roles: rolesPerWorkspaces,
      profileImageUrl: user.profileImageUrl,
      createdAt: DateTime.fromJSDate(user.createdAt).toISO()!,
    };

    return userDto;
  }

  findById(id: User['id']): Promise<Nullable<User>> {
    return this.userRepository.findById(id);
  }

  findByEmail(email: NonNullable<User['email']>): Promise<Nullable<User>> {
    return this.userRepository.findByEmail(email);
  }

  findBySocialIdAndProvider({
    socialId,
    provider,
  }: {
    socialId: NonNullable<User['socialId']>;
    provider: NonNullable<User['provider']>;
  }): Promise<Nullable<User>> {
    return this.userRepository.findBySocialIdAndProvider({
      socialId,
      provider,
    });
  }

  async update({
    id,
    data,
  }: {
    id: User['id'];
    data: Partial<Omit<User, 'id' | 'createdAt' | 'updatedAt' | 'deletedAt'>>;
  }): Promise<User> {
    const user = await this.userRepository.findById(id);

    if (!user) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.NOT_FOUND,
      );
    }

    // If email is present, check for email uniqueness
    if (data.email) {
      const existingUser = await this.userRepository.findByEmail(data.email);

      if (existingUser && existingUser.id !== id) {
        throw new ApiHttpException(
          {
            code: ApiErrorCode.EMAIL_ALREADY_EXISTS,
          },
          HttpStatus.CONFLICT,
        );
      }
    }

    const updatedUser = await this.userRepository.update({
      id,
      data,
    });

    if (!updatedUser) {
      // Somebody deleted themselves in the meantime
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.NOT_FOUND,
      );
    }

    return updatedUser;
  }

  /**
   * This should cascadely delete workspace_user,
   * goal, task_assignment and session entities
   * and set NULL to specific entities' properties.
   */
  async delete(userId: User['id']): Promise<void> {
    // We firstly need to check if user is the last Manager
    // in any workspace. Because if he was, deleting
    // it immediately would leave that/those workspace/s
    // in a state where it can't be admistrated anymore.
    const workspaceUsers =
      await this.workspaceUserService.findAllByUserId(userId);
    const workspaceUsersLastManager = workspaceUsers.filter(
      (wu) => wu.workspaceRole === WorkspaceUserRole.MANAGER,
    );

    // If there are some workspaces user is part of and is Manager in them
    // we block the deletion, and send those workspaces in the response
    // and prompt the user to delete them before deleting the account.
    if (workspaceUsersLastManager.length > 0) {
      throw new ApiHttpException(
        {
          code: ApiErrorCode.SOLE_MANAGER_CONFLICT,
        },
        HttpStatus.CONFLICT,
      );
    }

    const result = await this.userRepository.delete(userId);

    if (!result) {
      // Should never happen because we read userId from JWT
      // and if JWT is invalid, it will fail on the JWT guard
      throw new ApiHttpException(
        {
          code: ApiErrorCode.INVALID_PAYLOAD,
        },
        HttpStatus.NOT_FOUND,
      );
    }
  }
}
