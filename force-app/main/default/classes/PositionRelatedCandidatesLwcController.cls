public class PositionRelatedCandidatesLwcController {

    public class FieldsData {
        @AuraEnabled
        public String fieldName {get; set;}
        @AuraEnabled
        public String fieldLabel {get; set;}
        @AuraEnabled
        public Boolean isAccessible {get; set;}
    }
	
    public class CandidatesWrapper {
        @AuraEnabled
        public List<Candidate__c> candidateTileRecords {get; set;}
        @AuraEnabled
        public List<Candidate__c> candidateModalRecords {get; set;}
        @AuraEnabled
        public Integer candidatesAmount {get; set;}
        @AuraEnabled
        public List<FieldsData> candidateTileFieldsData {get; set;}
        @AuraEnabled
        public List<FieldsData> candidateModalFieldsData {get; set;}
    }
    
    @AuraEnabled(cacheable=true)
    public static CandidatesWrapper getCandidatesWrapper(Id userId, Id positionId, Integer limitParamWrapper, Integer offsetParamWrapper) {
        String candidateTileFieldSet;
        String candidateModalFieldSet;
        List<Schema.FieldSetMember> candidateTileFields;
        List<Schema.FieldSetMember> candidateModalFields;
        CandidatesWrapper componentCandidatesWrapper = new CandidatesWrapper();
        Boolean showInaccessibleFields = false;
        Boolean fieldAccessibility;
        Set<String> tileFieldsForQuery = new Set<String>();
        Set<String> modalFieldsForQuery = new Set<String>();
        List<FieldsData> tileFieldsData = new List<FieldsData>();
        List<FieldsData> modalFieldsData = new List<FieldsData>();

        Set<Id> componentCandidatesIds = JobApplicationService.candidatesIds(positionId);
        componentCandidatesWrapper.candidatesAmount = componentCandidatesIds.size();

        String userProfileName = UserService.getUserProfileName(userId);
        Set<String> profileNamesForCheck = new Set<String>{'Recruiter', 'System Administrator'};
        Set<String> userPermissionSetNames = UserService.getUserPermissionSetsNames(userId);
        String permissionSetNameForCheck = 'Interviewer';
        if (profileNamesForCheck.contains(userProfileName) || userPermissionSetNames.contains(permissionSetNameForCheck)) {
            String customMetadataTypeRecordName;
            if (profileNamesForCheck.contains(userProfileName)) {
                customMetadataTypeRecordName = 'Recruiter_field_set';
            } else {
                customMetadataTypeRecordName = 'Interviewer_field_set';
            }
            
            showInaccessibleFields = Field_set__mdt.getInstance(customMetadataTypeRecordName).Show_inaccessible_fields__c;
            candidateTileFieldSet = Field_set__mdt.getInstance(customMetadataTypeRecordName).Candidate_tile_field_set__c;
            candidateTileFields = CandidateSelector.readFieldSet('Candidate__c', candidateTileFieldSet);
            candidateModalFieldSet = Field_set__mdt.getInstance(customMetadataTypeRecordName).Candidate_modal_field_set__c;
            candidateModalFields = CandidateSelector.readFieldSet('Candidate__c', candidateModalFieldSet);

            for (Schema.FieldSetMember field : candidateTileFields) {
                String tileFieldForQuery;
                FieldsData tileFieldData = new FieldsData();
                if (showInaccessibleFields) {
                    tileFieldForQuery = (String)field.getFieldPath();
                    tileFieldData.fieldName = tileFieldForQuery;
                    tileFieldData.fieldLabel = (String)field.getLabel();
                    tileFieldData.isAccessible = CandidateService.getIsFieldAccessible('Candidate__c', tileFieldForQuery);
                } else {
                    fieldAccessibility = CandidateService.getIsFieldAccessible('Candidate__c', (String)field.getFieldPath());
                    if (fieldAccessibility) {
                        tileFieldForQuery = (String)field.getFieldPath();
                        tileFieldData.fieldName = tileFieldForQuery;
                        tileFieldData.fieldLabel = (String)field.getLabel();
                        tileFieldData.isAccessible = fieldAccessibility;
                    }
                }
                tileFieldsForQuery.add(tileFieldForQuery);
                tileFieldsData.add(tileFieldData);
            }
            for (Schema.FieldSetMember field : candidateModalFields) {
                String modalFieldForQuery;
                FieldsData modalFieldData = new FieldsData();
                if (showInaccessibleFields) {
                    modalFieldForQuery = (String)field.getFieldPath();
                    modalFieldData.fieldName = modalFieldForQuery;
                    modalFieldData.fieldLabel = (String)field.getLabel();
                    modalFieldData.isAccessible = CandidateService.getIsFieldAccessible('Candidate__c', modalFieldForQuery);
                } else {
                    fieldAccessibility = CandidateService.getIsFieldAccessible('Candidate__c', (String)field.getFieldPath());
                    if (fieldAccessibility) {
                        modalFieldForQuery = (String)field.getFieldPath();
                        modalFieldData.fieldName = modalFieldForQuery;
                        modalFieldData.fieldLabel = (String)field.getLabel();
                        modalFieldData.isAccessible = fieldAccessibility;
                    }
                }
                modalFieldsForQuery.add(modalFieldForQuery);
                modalFieldsData.add(modalFieldData);
            }
            componentCandidatesWrapper.candidateTileRecords = CandidateSelector.selectByIdsWithLimitAndOffset(tileFieldsForQuery, componentCandidatesIds, limitParamWrapper, offsetParamWrapper);
            componentCandidatesWrapper.candidateModalRecords = CandidateSelector.selectByIdsWithLimitAndOffset(modalFieldsForQuery, componentCandidatesIds, limitParamWrapper, offsetParamWrapper);
            componentCandidatesWrapper.candidateTileFieldsData = tileFieldsData;
            componentCandidatesWrapper.candidateModalFieldsData = modalFieldsData;

        } else {
            componentCandidatesWrapper.candidateTileFieldsData = tileFieldsData;
            componentCandidatesWrapper.candidateModalFieldsData = modalFieldsData;
        }
        return componentCandidatesWrapper;
    }

    public class ColumnsForDatatable {
        @AuraEnabled
        public String label {get; set;}
        @AuraEnabled
        public String fieldName {get; set;}
    }

    public static List<ColumnsForDatatable> getColumnsForDatatable(String objectName, String fieldSetName) {
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

    public class JobAppsWrapper {
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