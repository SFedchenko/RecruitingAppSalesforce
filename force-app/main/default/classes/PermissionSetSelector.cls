public class PermissionSetSelector {
    
    public static List<PermissionSet> selectByAssigneeId(Id assigneeId) {
        String q = 'SELECT Id, Name FROM PermissionSet WHERE Id IN (SELECT PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId =: assigneeId)';
        return Database.query(q);
    }
}