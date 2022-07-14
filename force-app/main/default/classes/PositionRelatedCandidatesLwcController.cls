public class PositionRelatedCandidatesLwcController {
	
    public class CandidatesWrapper{
        @AuraEnabled
        public List<Candidate__c> candidatesRecords {get; set;}
        @AuraEnabled
        public Integer candidatesAmount {get; set;}
        @AuraEnabled
        public List<String> candidateTileFields {get; set;}
        @AuraEnabled
        public List<String> candidateModalFields {get; set;}
    }
    
    @AuraEnabled(cacheable=true)
    public static CandidatesWrapper getCandidatesWrapper(Id positionId, Integer limitParamWrapper, Integer offsetParamWrapper){

        CandidatesWrapper componentCandidatesWrapper = new CandidatesWrapper();

        Set<Id> componentCandidatesIds = JobApplicationService.candidatesIds(positionId);
        componentCandidatesWrapper.candidatesAmount = componentCandidatesIds.size();

        componentCandidatesWrapper.candidatesRecords = CandidateService.candidatesWithFieldsAndObjectAccess(
            CandidateSelector.selectByIdsWithLimitAndOffset(componentCandidatesIds, limitParamWrapper, offsetParamWrapper)
        );

        componentCandidatesWrapper.candidateTileFields = CandidateService.getFieldSetData('Candidate__c', 'CandidateTileFieldSet');

        componentCandidatesWrapper.candidateModalFields = CandidateService.getFieldSetData('Candidate__c', 'CandidateModalFieldSet');

        return componentCandidatesWrapper;
    }

    public class ColumnsForDatatable{
        @AuraEnabled
        public String label {get; set;}
        @AuraEnabled
        public String fieldName {get; set;}
    }

    public static List<ColumnsForDatatable> getColumnsForDatatable(String objectName, String fieldSetName){
        List<ColumnsForDatatable> columnsForModalDatatable = new List<ColumnsForDatatable>();
        List<Schema.FieldSetMember> fieldSet = CandidateSelector.readFieldSet(objectName, fieldSetName);
        for (Schema.FieldSetMember f : fieldSet) {
            ColumnsForDatatable columnForModalDatatable = new ColumnsForDatatable();
            columnForModalDatatable.label = (String)f.getLabel();
            columnForModalDatatable.fieldName = (String)f.getFieldPath();
            columnsForModalDatatable.add(columnForModalDatatable);
        }
        return columnsForModalDatatable;
    }

    public class JobAppsWrapper{
        @AuraEnabled
        public List<Job_Application__c> jobAppsRecords {get; set;}
        @AuraEnabled
        public Integer jobAppsAmount {get; set;}
        @AuraEnabled
        public List<ColumnsForDatatable> columns {get; set;}
    }

    @AuraEnabled(cacheable=true)
    public static JobAppsWrapper getJobAppsWrapper(Id candidateId, Integer limitParamWrapper, Integer offsetParamWrapper) {
        JobAppsWrapper componentJobAppsWrapper = new JobAppsWrapper();
        componentJobAppsWrapper.jobAppsRecords = JobApplicationService.jobAppsWithFieldsAndObjectAccess(
            JobApplicationSelector.selectByCandidateIdWithLimitAndOffset('Job_Application__c', 'JobAppModalFieldSet', candidateId, limitParamWrapper, offsetParamWrapper)
        );

        componentJobAppsWrapper.jobAppsAmount = JobApplicationSelector.selectCountByCandidateId(candidateId);

        componentJobAppsWrapper.columns = PositionRelatedCandidatesLwcController.getColumnsForDatatable('Job_Application__c', 'JobAppModalFieldSet');
        return componentJobAppsWrapper;
    }
}