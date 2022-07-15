public class PermissionSetAssignmentSelector {
    
    public static List<PermissionSetAssignment> selectByAssigneeId(Id assigneeId) {
        String q = 'SELECT Id, PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId =: assigneeId';
        return Database.query(q);
    }
}
