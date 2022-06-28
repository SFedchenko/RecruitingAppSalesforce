public with sharing class PositionListVFController {
    public List<SelectOption> statusFilterOptions {get; set;}
    public Boolean showTable {get; set;}
    public String selectedStatusFilterOption {get; set;}
    public List<Position__c> selectedPositionsList {get; set;}
    
    public PositionListVFController() {
        statusFilterOptions = PositionService.positionFilterOptions();
        selectedStatusFilterOption = 'Open';
        applyFilter();
    }
    
    public PageReference applyFilter() {
        try{
        	selectedPositionsList = PositionService.positionsWithFieldsAndObjectAccess(
            	PositionSelector.selectByStatus(selectedStatusFilterOption)
            );
            if(selectedPositionsList.size() == 0) {
                showTable = false;
            	ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Info, System.Label.NoPositionsWithStatus + ' "' + selectedStatusFilterOption + '"'));
            } else {
                showTable = true;
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