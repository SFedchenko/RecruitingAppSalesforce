public with sharing class positionListController {
    
    public positionListController() {
        selectedFilterPicklistOption = 'Open';
        ApplyFilter();
    }
    
	public List<SelectOption> getFilterPicklistOptions() {
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
    
    public string selectedFilterPicklistOption {get; set;}
    public list<Position__c> selectedPositionsList {get; set;}
    public PageReference ApplyFilter() {
        if (selectedFilterPicklistOption != 'All') {
            selectedPositionsList = new list<Position__c>([SELECT Id, Name, Status__c, Start_Date__c, End_Date__c, Min_Salary__c, Max_Salary__c
                                                           FROM Position__c
                                                           WHERE Status__c =: selectedFilterPicklistOption]);
        } else {
            selectedPositionsList = new list<Position__c>([SELECT Id, Name, Status__c, Start_Date__c, End_Date__c, Min_Salary__c, Max_Salary__c
                                                           FROM Position__c]);
        }
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