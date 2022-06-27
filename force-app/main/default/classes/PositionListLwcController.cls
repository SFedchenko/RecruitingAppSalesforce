public with sharing class PositionListLwcController {

    public static List<Position__c> getPositions(String selectedFilterOption, Integer limitParam, Integer offsetParam) {
        String q = 'SELECT Id, Name, Status__c, Start_Date__c, End_Date__c, Min_Salary__c, Max_Salary__c, UserRecordAccess.HasEditAccess FROM Position__c';
        if (selectedFilterOption != 'All') {
            q += ' WHERE Status__c =: selectedFilterOption';
        }
        q += ' ORDER BY Name LIMIT :limitParam OFFSET :offsetParam';
        List<Position__c> positionsWithNotAppliedPermissions = Database.query(q);
        SObjectAccessDecision securityDecision = Security.stripInaccessible(AccessType.READABLE, positionsWithNotAppliedPermissions, true);
        List<Position__c> positionsWithAppliedPermissions = securityDecision.getRecords();
        return positionsWithAppliedPermissions;
    }
    
    public static Integer getPositionsAmount(String selectedFilterOption) {
        String q = 'SELECT COUNT() FROM Position__c';
        if (selectedFilterOption != 'All') {
            q += ' WHERE Status__c =: selectedFilterOption';
        }
        return Database.countQuery(q);
    }

    public class PositionsWrapper{
        @AuraEnabled
        public List<Position__c> positionsRecords {get; set;}
        @AuraEnabled
        public Integer positionsAmount {get; set;}
    }

    @AuraEnabled
    public static PositionsWrapper getPositionsWrapper(String selectedFilterOptionWrapper, Integer limitParamWrapper, Integer offsetParamWrapper){
        PositionsWrapper componentPositionsWrapper = new PositionsWrapper();
        componentPositionsWrapper.positionsRecords = getPositions(selectedFilterOptionWrapper, limitParamWrapper, offsetParamWrapper);
        componentPositionsWrapper.positionsAmount = getPositionsAmount(selectedFilterOptionWrapper);
        return componentPositionsWrapper;
    }

    @AuraEnabled
    public static String updatePositions(List<Position__c> positions) {
        try {
            update positions;
            return 'Success';
        } catch (System.DmlException e) {
            return 'Error';
        }
  }
}