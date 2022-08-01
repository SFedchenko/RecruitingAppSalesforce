@isTest
private class SettingsPageLwcControllerTest {

    @isTest
    static void testGetSelectOptions() {

		Test.startTest();
        
        List<SettingsPageLwcController.SelectOption> testSelectOptions = SettingsPageLwcController.getSelectOptions();
        
        Test.stopTest();
        
        System.assertEquals(
            ( (SObject)Type.forName('Candidate__c').newInstance() ).getSObjectType().getDescribe().FieldSets.getMap().size(),
            testSelectOptions.size()
        );        
    }
    
    @isTest
    static void testGetSettingsDataWrapper() {

		Test.startTest();
        
        SettingsPageLwcController.SettingsDataWrapper testSettingsDataWrapper = SettingsPageLwcController.getSettingsDataWrapper();
        
        Test.stopTest();
        
        System.assertEquals(
            ( (SObject)Type.forName('Candidate__c').newInstance() ).getSObjectType().getDescribe().FieldSets.getMap().size(),
            testSettingsDataWrapper.selectOptions.size()
        );
        System.assertEquals(
            Field_set__mdt.getAll().size(),
            testSettingsDataWrapper.customMetadataRecords.size()
        );  
    }
    
    @isTest
    static void testGetFieldSetFields() {

		Test.startTest();
        
        List<SettingsPageLwcController.FieldsData> testFieldSetFieldsForRecruiter = SettingsPageLwcController.getFieldSetFields('Profile', 'Recruiter', 'recruiterCandidateTileFieldSet');
        List<SettingsPageLwcController.FieldsData> testFieldSetFieldsForInterviewer = SettingsPageLwcController.getFieldSetFields('PermissionSet', 'Interviewer', 'recruiterCandidateTileFieldSet');
        
        Test.stopTest();
        
        Integer recruiterCount = 0;
        for (SettingsPageLwcController.FieldsData field : testFieldSetFieldsForRecruiter) {
            if (field.isAccessible) {
                recruiterCount++;
            }
        }
        Integer interviewerCount = 0;
        for (SettingsPageLwcController.FieldsData field : testFieldSetFieldsForInterviewer) {
            if (field.isAccessible) {
                interviewerCount++;
            }
        }
        
        System.assertEquals(3, testFieldSetFieldsForRecruiter.size());
        System.assertEquals(3, recruiterCount);
        System.assertEquals(3, testFieldSetFieldsForInterviewer.size());
        System.assertEquals(1, interviewerCount);
    }
    
    @isTest
    static void testUpdateCustomMetadataRecords() {
        Map<String, Field_set__mdt> customMetadataRecords = Field_set__mdt.getAll();
		Map<String, Field_set__mdt> customMetadataRecordsForUpdate = customMetadataRecords.deepClone();
		customMetadataRecordsForUpdate.get('Recruiter_field_set').Candidate_tile_field_set__c = 'CandidateTileFieldSet';

		Test.startTest();
        
        List<String> methodReturnedList = SettingsPageLwcController.updateCustomMetadataRecords(customMetadataRecordsForUpdate);
        
        Test.stopTest();
        
        System.assertEquals('Error', methodReturnedList[0]);
        System.assertEquals('Metadata cannot be deployed from within a test', methodReturnedList[1]);
    }
}