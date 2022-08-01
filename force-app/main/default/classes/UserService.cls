public class UserService {

    public static String getUserProfileName(Id userId) {
        List<User> userInfo = UserSelector.selectById(userId);
        Id profileId = userInfo[0].ProfileId;
        List<Profile> profileInfo = ProfileSelector.selectById(profileId);
        return profileInfo[0].Name;
    }

    public static Set<String> getUserPermissionSetsNames(Id userId) {
        List<PermissionSet> permissionSetInfo = PermissionSetSelector.selectByAssigneeId(userId);
        Set<String> permissionSetsNames = new Set<String>();
        for (PermissionSet p : permissionSetInfo) {
            permissionSetsNames.add(p.Name);
        }
        return permissionSetsNames;
    }
}