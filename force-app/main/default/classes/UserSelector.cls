public class UserSelector {

    public static List<User> selectById(Id userId) {
        String q = 'SELECT Id, ProfileId FROM User WHERE Id =: userId';
        return Database.query(q);
    }
}
