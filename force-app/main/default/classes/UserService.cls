public class UserService {

    public static String getUserProfileName(Id userId) {
        List<User> userInfo = UserSelector.selectById(userId);
        Id profileId = userInfo[0].ProfileId;
        List<Profile> profileInfo = ProfileSelector.selectById(profileId);
        return profileInfo[0].Name;
    }

    public static Set<String> getUserPermissionSetsNames(Id userId) {
        List<PermissionSetAssignment> permissionSetAssignmentInfo = PermissionSetAssignmentSelector.selectByAssigneeId(userId);
        Set<Id> permissionSetsIds = new Set<Id>();
        for (PermissionSetAssignment p : permissionSetAssignmentInfo) {
            permissionSetsIds.add(p.PermissionSetId);
        }
        List<PermissionSet> permissionSetInfo = PermissionSetSelector.selectByPermissionSetsIds(permissionSetsIds);
        Set<String> permissionSetsNames = new Set<String>();
        for (PermissionSet p : permissionSetInfo) {
            permissionSetsNames.add(p.Name);
        }
        return permissionSetsNames;
    }
}
