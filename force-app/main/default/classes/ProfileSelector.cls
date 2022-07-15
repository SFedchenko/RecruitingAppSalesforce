public class ProfileSelector {

    public static List<Profile> selectById(Id profileId) {
        String q = 'SELECT Id, Name FROM Profile WHERE Id =: profileId';
        return Database.query(q);
    }
}
