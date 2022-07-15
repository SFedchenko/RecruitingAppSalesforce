public class PermissionSetSelector {
    
    public static List<PermissionSet> selectByPermissionSetsIds(Set<Id> permissionSetsIds) {
        String q = 'SELECT Id, Name FROM PermissionSet WHERE Id IN :permissionSetsIds';
        return Database.query(q);
    }
}
