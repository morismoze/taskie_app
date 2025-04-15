import { Column, Entity, Index, OneToMany } from 'typeorm';
import { RootBaseEntity } from 'src/common/entity/root-base.entity';
import { WorkspaceMemberRole } from '../workspace-role.enum';
import { WorkspaceMember } from '../../workspace-module/persistence/workspace-member.entity';

@Entity({
  name: 'role',
})
export class WorkspaceRole extends RootBaseEntity {
  @Column({
    type: 'enum',
    enum: WorkspaceMemberRole,
  })
  @Index({
    unique: true,
  })
  name: string;

  // A role can be assigned to many workspace members (users)
  @OneToMany(() => WorkspaceMember, (workspaceMember) => workspaceMember.role)
  workspaceMembers: WorkspaceMember[];
}
