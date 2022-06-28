public with sharing class PositionService {
    
    public static List<SelectOption> positionFilterOptions() {
    	Schema.DescribeFieldResult describeResult = Position__c.Status__c.getDescribe();
    	List<Schema.PicklistEntry> entries = describeResult.getPicklistValues();
    	List<SelectOption> optionsToReturn = new List<SelectOption>();
        optionsToReturn.add(new SelectOption('All','All'));
    	for (Schema.PicklistEntry pEntry : entries) {
        	if (pEntry.isActive()) {
            	optionsToReturn.add(new SelectOption(pEntry.getValue(), pEntry.getLabel()));
        	}
    	}
    	return optionsToReturn;
	}
    
    public static List<Position__c> positionsWithFieldsAndObjectAccess(List<Position__c> positionsWithNotAppliedPermissions) {
        SObjectAccessDecision securityDecision = Security.stripInaccessible(AccessType.READABLE, positionsWithNotAppliedPermissions, true);
        List<Position__c> positionsWithAppliedPermissions = securityDecision.getRecords();
        return positionsWithAppliedPermissions;
    }
}