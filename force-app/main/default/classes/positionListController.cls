public with sharing class PositionListController {
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
        String q = 'SELECT Id, Name, Status__c, Start_Date__c, End_Date__c, Min_Salary__c, Max_Salary__c FROM Position__c';
        if (selectedFilterPicklistOption != 'All') {
            q += ' WHERE Status__c =: selectedFilterPicklistOption';
     	}
        selectedPositionsList = Database.query(q);
        if(selectedPositionsList.size() == 0) {
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Info, 'There are no positions with status ' + '"' + selectedFilterPicklistOption + '"'));
		}
        return null;
    }
    
    public PageReference save() {
        try {
            update selectedPositionsList;
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Changes were saved succsessfully'));
        } catch(System.DMLException e) {
            ApexPages.addMessages(e);
            return null;
        }
        return null;
 	}
}