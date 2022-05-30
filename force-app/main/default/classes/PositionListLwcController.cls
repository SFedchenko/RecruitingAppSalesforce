public with sharing class PositionListLwcController {
    @AuraEnabled
    public static List<Position__c> getPositions(String selectedStatus) {
        String q = 'SELECT Id, Name, Status__c, Start_Date__c, End_Date__c, Min_Salary__c, Max_Salary__c FROM Position__c';
        if (selectedStatus != 'All') {
            q += ' WHERE Status__c =: selectedStatus';
     	}
        return Database.query(q);
    }
}