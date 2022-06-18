public with sharing class PositionListLwcController {

    @AuraEnabled
    public static List<Position__c> getPositions(String selectedFilterOption, Integer limitParam, Integer offsetParam) {
        String q = 'SELECT Id, Name, Status__c, Start_Date__c, End_Date__c, Min_Salary__c, Max_Salary__c FROM Position__c';
        if (selectedFilterOption != 'All') {
            q += ' WHERE Status__c =: selectedFilterOption ORDER BY Name LIMIT :limitParam OFFSET :offsetParam';
        } else {
            q += ' ORDER BY Name LIMIT :limitParam OFFSET :offsetParam';
        }
        return Database.query(q);
    }
    
    @AuraEnabled
    public static Integer getPositionsAmount(String selectedFilterOption) {
        String q = 'SELECT COUNT() FROM Position__c';
        if (selectedFilterOption != 'All') {
            q += ' WHERE Status__c =: selectedFilterOption';
        }
        return Database.countQuery(q);
    }

    @AuraEnabled
    public static String updatePositions(List<Position__c> positions) {
        try {
            update positions;
            return 'Success';
        } catch (DmlException e) {
            return 'Error';
        }
  }
}