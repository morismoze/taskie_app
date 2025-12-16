-- On task assignment update or delete we need to:
-- 1. Get updated accumulated points of the member whose assignment was updated
-- 2.a Check if there are any goals whose required points are now over member's accumulated points.
-- We do this only for update events in which status was updated to IN_PROGRESS, NOT_COMPLETED, CLOSED or
-- COMPLETED_AS_STALE as this is an edge case in which member could have a goal not completed anymore if 
-- the task assignment status was put into one of those three statuses. In that case, we need to amend the 
-- status of that goal back to IN_PROGRESS.
-- 2.b We also need update the goals' statuses to COMPLETED for the reverse case - if the accumulated points
-- are now equal or greated tha the required points

-- Function to get accumulated points for the workspace member
CREATE OR REPLACE FUNCTION get_contextual_member_accumulated_points(
    p_workspace_id UUID,
    p_workspace_user_id UUID
)
RETURNS INTEGER AS $$
DECLARE
    total_points INTEGER;
BEGIN
    SELECT COALESCE(SUM(t.reward_points), 0)
    INTO total_points
    FROM task_assignment ta
    INNER JOIN task t ON ta.task_id = t.id
    WHERE ta.assignee_id = p_workspace_user_id
      AND t.workspace_id = p_workspace_id
      AND ta.status = 'COMPLETED';
    
    RETURN total_points;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION check_task_assignment_status_change()
RETURNS TRIGGER AS $$
DECLARE
    v_accumulated_points INTEGER;
    v_workspace_id UUID;
BEGIN
    IF TG_OP = 'UPDATE' THEN
        -- 1. Get workspace ID from task entity
        SELECT workspace_id INTO v_workspace_id
        FROM task
        WHERE id = NEW.task_id;

        -- 2. Get member's accumulated points
        v_accumulated_points := get_contextual_member_accumulated_points(
            v_workspace_id,
            NEW.assignee_id
        );

        -- 3.a Update goals by [workspace ID, assignee ID and status = COMPLETED] back to IN progress
        --    status if accumulated points dropped below required points
        IF NEW.status IN ('IN_PROGRESS', 'NOT_COMPLETED', 'CLOSED', 'COMPLETED_AS_STALE') THEN
            UPDATE goal g
            SET status = 'IN_PROGRESS',
                updated_at = NOW()
            WHERE g.workspace_id = v_workspace_id
            AND g.assignee_id = NEW.assignee_id
            AND g.status = 'COMPLETED'
            AND g.required_points > v_accumulated_points;
        END IF;

        -- 3.b Update goals by [workspace ID, assignee ID and status != COMPLETED] putting the status to 
        --    COMPLETED if accumulated points became equal or greater then required points.
        --    COMPLETED_AS_STALE won't fall into accumulated points.
        IF NEW.status = 'COMPLETED' THEN
            UPDATE goal g
            SET status = 'COMPLETED',
                updated_at = NOW()
            WHERE g.workspace_id = v_workspace_id
            AND g.assignee_id = NEW.assignee_id
            AND g.required_points <= v_accumulated_points
            AND g.status <> 'COMPLETED';
        END IF;
    
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        -- If deleted assignment was not COMPLETED, skip
        IF OLD.status NOT IN ('COMPLETED') THEN
            RETURN OLD;
        END IF;

        -- 1. Get workspace ID from task entity
        SELECT workspace_id INTO v_workspace_id
        FROM task
        WHERE id = OLD.task_id;

        -- 2. Get member's accumulated points
        v_accumulated_points := get_contextual_member_accumulated_points(
            v_workspace_id,
            OLD.assignee_id
        );

        -- 3. Update goals by [workspace ID, assignee ID and status != COMPLETED] putting the status to 
        --    IN_PROGRESS if accumulated points dropped below required points
        UPDATE goal g
        SET status = 'IN_PROGRESS',
            updated_at = NOW()
        WHERE g.workspace_id = v_workspace_id
          AND g.assignee_id = OLD.assignee_id
          AND g.status = 'COMPLETED'
          AND g.required_points > v_accumulated_points;

        RETURN OLD;
    END IF;
    
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS task_assignment_after_update ON task_assignment;

CREATE TRIGGER task_assignment_after_update
    AFTER UPDATE OR DELETE ON task_assignment
    FOR EACH ROW
    EXECUTE FUNCTION check_task_assignment_status_change();