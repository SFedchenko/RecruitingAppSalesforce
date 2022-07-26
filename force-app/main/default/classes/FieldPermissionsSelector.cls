public class FieldPermissionsSelector {
    
    public static List<FieldPermissions> selectByObjectAndPermissionSet(String objectName, String permissionSetName) {
        String q = 'SELECT Field FROM FieldPermissions WHERE SobjectType =: objectName AND ParentId IN (SELECT Id FROM PermissionSet WHERE Name =: permissionSetName)';
        return Database.query(q);
    }

    public static List<FieldPermissions> selectByObjectAndProfile(String objectName, String profileName) {
        String q = 'SELECT Field FROM FieldPermissions WHERE SobjectType =: objectName AND ParentId IN (SELECT Id FROM PermissionSet WHERE PermissionSet.Profile.Name =: profileName)';
        return Database.query(q);
    }
}
