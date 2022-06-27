public with sharing class PositionListLwcService {
    public static List<Position__c> positionsWithFieldsAndObjectAccess(List<Position__c> positionsWithNotAppliedPermissions) {
        SObjectAccessDecision securityDecision = Security.stripInaccessible(AccessType.READABLE, positionsWithNotAppliedPermissions, true);
        List<Position__c> positionsWithAppliedPermissions = securityDecision.getRecords();
        return positionsWithAppliedPermissions;
    }
    
    public static String updateRecords(List<Position__c> records) {
        try {
            update records;
            return 'Success';
        } catch (System.DmlException e) {
            return 'Error';
        }
  }
}