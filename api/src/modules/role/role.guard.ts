import { Injectable, CanActivate, ExecutionContext } from '@nestjs/common';
import { Reflector } from '@nestjs/core';

@Injectable()
export class RolesGuard implements CanActivate {
  constructor(private reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    // Nest's Reflector has a built-in method to merge the metadata set on controllers and route handlers
    // with getAllAndMerge which will merge the metadata from the class and the method.
    // If we wanted to get just one set of metadata and have a fallback (say if we want only the handler
    // metadata if it exists and if not get the class's metadata - this should mean route guard
    // can be on class level or on function handler level) we can use getAllAndOverride
    const roles = this.reflector.getAllAndOverride<number[]>('roles', [
      context.getClass(),
      context.getHandler(),
    ]);
    if (!roles.length) {
      return true;
    }

    const request = context.switchToHttp().getRequest();
    return roles.includes(request.user?.role?.id);
  }
}
