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
    public static CandidatesWrapper getCandidatesWrapper(Id userId, Id positionId, Integer limitParamWrapper, Integer offsetParamWrapper){
        String candidateTileFieldSet;
        String candidateModalFieldSet;
        CandidatesWrapper componentCandidatesWrapper = new CandidatesWrapper();

        Set<Id> componentCandidatesIds = JobApplicationService.candidatesIds(positionId);
        componentCandidatesWrapper.candidatesAmount = componentCandidatesIds.size();

        componentCandidatesWrapper.candidatesRecords = CandidateService.candidatesWithFieldsAndObjectAccess(
            CandidateSelector.selectByIdsWithLimitAndOffset(componentCandidatesIds, limitParamWrapper, offsetParamWrapper)
        );

        String userProfileName = UserService.getUserProfileName(userId);
        Set<String> profileNamesForCheck = new Set<String>{'Recruiter', 'System Administrator'};
        Set<String> userPermissionSetNames = UserService.getUserPermissionSetsNames(userId);
        String permissionSetNameForCheck = 'Interviewer';
        if (profileNamesForCheck.contains(userProfileName)) {
            candidateTileFieldSet = Field_set__mdt.getInstance('Recruiter_field_set').Candidate_tile_field_set__c;
            candidateModalFieldSet = Field_set__mdt.getInstance('Recruiter_field_set').Candidate_modal_field_set__c;
        } else if (userPermissionSetNames.contains(permissionSetNameForCheck)) {
            candidateTileFieldSet = Field_set__mdt.getInstance('Interviewer_field_set').Candidate_tile_field_set__c;
            candidateModalFieldSet = Field_set__mdt.getInstance('Interviewer_field_set').Candidate_modal_field_set__c;
        }

        componentCandidatesWrapper.candidateTileFields = CandidateService.getFieldSetData('Candidate__c', candidateTileFieldSet);

        componentCandidatesWrapper.candidateModalFields = CandidateService.getFieldSetData('Candidate__c', candidateModalFieldSet);

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