public class PositionSelector {
    
    public static List<Position__c> selectByStatus(String selectedFilterOption) {
        String q = 'SELECT Id, Name, Status__c, Start_Date__c, End_Date__c, Min_Salary__c, Max_Salary__c, UserRecordAccess.HasEditAccess FROM Position__c';
        if (selectedFilterOption != 'All') {
            q += ' WHERE Status__c =: selectedFilterOption';
     	}
        return Database.query(q);
    }
    
    public static List<Position__c> selectByStatusWithLimitAndOffset(String selectedFilterOption, Integer limitParam, Integer offsetParam) {
        String q = 'SELECT Id, Name, Status__c, Start_Date__c, End_Date__c, Min_Salary__c, Max_Salary__c, UserRecordAccess.HasEditAccess FROM Position__c';
        if (selectedFilterOption != 'All') {
            q += ' WHERE Status__c =: selectedFilterOption';
        }
        q += ' ORDER BY Name LIMIT :limitParam OFFSET :offsetParam';
        return Database.query(q);
    }
    
    public static Integer selectAmountByStatus(String selectedFilterOption) {
        String q = 'SELECT COUNT() FROM Position__c';
        if (selectedFilterOption != 'All') {
            q += ' WHERE Status__c =: selectedFilterOption';
        }
        return Database.countQuery(q);
    }
}