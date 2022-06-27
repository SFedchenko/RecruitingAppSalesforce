public with sharing class PositionListController {
    public Boolean showTable {get; set;}
    public String selectedFilterPicklistOption {get; set;}
    public List<Position__c> selectedPositionsList {get; set;}
    
    public PositionListController() {
        selectedFilterPicklistOption = 'Open';
        applyFilter();
    }
    
	public static List<SelectOption> getFilterPicklistOptions() {
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
    
    public PageReference applyFilter() {
        String q = 'SELECT Id, Name, Status__c, Start_Date__c, End_Date__c, Min_Salary__c, Max_Salary__c, UserRecordAccess.HasEditAccess FROM Position__c';
        if (selectedFilterPicklistOption != 'All') {
            q += ' WHERE Status__c =: selectedFilterPicklistOption';
     	}
        try{
            List<Position__c> positionsWithNotAppliedPermissions = Database.query(q);
        	SObjectAccessDecision securityDecision = Security.stripInaccessible(AccessType.READABLE, positionsWithNotAppliedPermissions, true);
            showTable = true;
        	selectedPositionsList = securityDecision.getRecords();
            if(selectedPositionsList.size() == 0) {
                showTable = false;
            	ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Info, System.Label.NoPositionsWithStatus + ' "' + selectedFilterPicklistOption + '"'));
			}
        } catch(QueryException qe) {
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Error, System.Label.LoadingErrorMessage));
            System.debug(qe.getMessage());
        }
        return null;
    }
    
    public PageReference save() {
        try {
            update selectedPositionsList;
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Info, System.Label.ChangesSaved));
            applyFilter();
            
        } catch(DMLException e) {
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Error, System.Label.UpdatindRecordsError));
            System.debug(e.getMessage());
            applyFilter();
        }
        return null;
 	}
}